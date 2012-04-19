//
//  NowPlaying.m
//  Subsonic
//
//  Created by Josh Betz on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NowPlaying.h"
#import "AppDelegate.h"
#import "Song.h"
#import "RSSParser.h"
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <MediaPlayer/MPVolumeView.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItemCollection.h>

@interface NowPlaying ()
@end

@implementation NowPlaying
@synthesize songID, playerItem, playButton, userName, userPassword, serverURL, albumArt, reflectionImage, albumArtID, nextButton, prevButton, volumeSlider, artistListProperty;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    if ([[songList objectAtIndex:currentIndex] albumArt] != nil){
        albumArtID = [[songList objectAtIndex:currentIndex] albumArt];
    }
    NSMutableArray *songArray = [[NSMutableArray array] init];
    for (int i = 0; i < [songList count]; i++){
        [songArray addObject:[songList objectAtIndex:i]];
    }
    songList = songArray;
    
    if(songList.count > 0 && differentAlbum == true) {
        [self buildPlaylist];
        
        NSString *artSize;
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
            //Retina
            artSize = @"640";
        }
        else {
            //Not Retina
            artSize = @"320";
        }
        
        if (albumArtID != nil) {
            userURL = [NSString stringWithFormat:@"%@&id=%@&size=%@", [AppDelegate getEndpoint:@"getCoverArt"], albumArtID, artSize];
            NSURL *imageURL = [NSURL URLWithString: userURL];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:imageData]; 
            albumArt.image = image;
            art = image;
            
            NSUInteger reflectionHeight = albumArt.bounds.size.height * 0.65;
            reflectionImage.image = [self reflectedImage:albumArt withHeight:reflectionHeight];
            reflectionImage.alpha = 0.60;
        }
        
        avPlayer = [[AVQueuePlayer alloc] initWithPlayerItem:[itemList objectAtIndex:currentIndex]];

        [self playSong:playButton];
        
        for ( int i=currentIndex+1; i < [itemList count]; i++ )
            [avPlayer insertItem:[itemList objectAtIndex:i] afterItem:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        
        differentAlbum = false;
    }
    else if (differentAlbum == false) {
        if (art != nil){
            albumArt.image = art;
            
            NSUInteger reflectionHeight = albumArt.bounds.size.height * 0.65;
            reflectionImage.image = [self reflectedImage:albumArt withHeight:reflectionHeight];
            reflectionImage.alpha = 0.60;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 3;
        label.font = [UIFont boldSystemFontOfSize: 12.0f];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.text = songInfo;
        self.navigationItem.titleView = label;
    }
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(20,380,280,20)];
    [volumeView sizeToFit];
    [self.view addSubview:volumeView];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (avPlayer.rate > 0)
        [playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    else
        [playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    nowPlaying = self;
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [self playSong:playButton];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [self playSong:playButton];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [self playSong:playButton];
        } else if (event.subtype == UIEventSubtypeRemoteControlNextTrack) {
            [self nextSong:nextButton];
        } else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack) {
            [self prevSong:prevButton];
        }
    }
}

- (void)viewDidUnload
{
    nowPlaying = self;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

// iOS5 Only
- (void) setMediaInfo {
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
        MPMediaItemArtwork *artwork = nil;
        if( albumArtID != nil) {
            artwork = [[MPMediaItemArtwork alloc] initWithImage:art];
        }
        
        NSDictionary *songInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [[songList objectAtIndex:currentIndex] artistName], MPMediaItemPropertyArtist,
                                  [[songList objectAtIndex:currentIndex] songName], MPMediaItemPropertyTitle,
                                  [[songList objectAtIndex:currentIndex] albumName], MPMediaItemPropertyAlbumTitle,
                                  artwork, MPMediaItemPropertyArtwork,
                                  nil];
        center.nowPlayingInfo = songInfo;
    }
    
    [self scrobble:NO withID:[[songList objectAtIndex:currentIndex] songID]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[avPlayer currentItem]];
    
    // Update the nav bar label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 3;
    label.font = [UIFont boldSystemFontOfSize: 12.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    NSString *songData;
    songData = [[songList objectAtIndex:currentIndex] artistName];
    songData = [songData stringByAppendingString:@"\n"];
    songData = [songData stringByAppendingString: [[songList objectAtIndex:currentIndex] songName]];
    songData = [songData stringByAppendingString:@"\n"];
    songData = [songData stringByAppendingString: [[songList objectAtIndex:currentIndex] albumName]];
    label.text = songData;
    songInfo = songData;
    self.navigationItem.titleView = label;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self scrobble:YES withID:[[songList objectAtIndex:currentIndex] songID]];
    [avPlayer advanceToNextItem];
    currentIndex++;
    [self setMediaInfo];
}

- (void)buildPlaylist {
    BOOL noProblems = true;
    for (int i = 0; i < [[[[[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex] albumList] objectAtIndex:selectedAlbumIndex] songList]count]; i++){
        if ([[[[[[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex] albumList] objectAtIndex:selectedAlbumIndex] songList]objectAtIndex:i]songData] == nil){
            noProblems = false;
            break;
        }
    }
    if (noProblems == true){
        itemList = [[[[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex] albumList] objectAtIndex:selectedAlbumIndex] songList];
    }
    else {
        queueList = [NSMutableArray array];
        itemList = [NSMutableArray array];
        
        NSString *maxBitRate;
        if ( hqMode )
            maxBitRate = @"256";
        else
            maxBitRate = @"128";
        
        for (int i = 0; i < [songList count]; i++){
            userURL = [NSString stringWithFormat:@"%@&id=%@&maxBitRate=%@", [AppDelegate getEndpoint:@"stream"], [[songList objectAtIndex:i] songID], maxBitRate];
            url = [NSURL URLWithString:userURL];
            [queueList addObject:url];
        }
        
        NSLog(@"%d", [queueList count]);
        for (int i = 0; i < [queueList count]; i++){
            url = [queueList objectAtIndex:i];
            AVPlayerItem *songItem = [AVPlayerItem playerItemWithURL:url];
            [itemList addObject:songItem];
        }
    }
}

- (IBAction)done:(id)sender
{  
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)playSong:(id)sender{
    if ([itemList count] > 0){
        if (avPlayer.rate == 0.0){
            UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
            [avPlayer play];
            newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
            [playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        }   
        else {
            [avPlayer pause];
            [playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        }
    }
    [self setMediaInfo];
}

-(IBAction)nextSong:(id)nextButton{
    [avPlayer advanceToNextItem];
    currentIndex++;
    [self setMediaInfo];
}

-(IBAction)prevSong:(id)prevButton{
    currentIndex--;
    if( currentIndex < 0 )
        currentIndex = 0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 3;
    label.font = [UIFont boldSystemFontOfSize: 12.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    NSString *songData;
    songData = [[songList objectAtIndex:currentIndex] artistName];
    songData = [songData stringByAppendingString:@"\n"];
    songData = [songData stringByAppendingString: [[songList objectAtIndex:currentIndex] songName]];
    songData = [songData stringByAppendingString:@"\n"];
    songData = [songData stringByAppendingString: [[songList objectAtIndex:currentIndex] albumName]];
    label.text = songData;
    songInfo = songData;
    self.navigationItem.titleView = label;
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    
    avPlayer = [[AVQueuePlayer alloc] initWithPlayerItem:[AVPlayerItem playerItemWithURL:[queueList objectAtIndex:currentIndex]]];
    [avPlayer play];
    
    [self scrobble:NO withID:[[songList objectAtIndex:currentIndex] songID]];
    
    [self buildPlaylist];
    for ( int i=currentIndex+1; i < [itemList count]; i++ )
        [avPlayer insertItem:[AVPlayerItem playerItemWithURL:[queueList objectAtIndex:i]] afterItem:nil];
    
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
}

-(BOOL)scrobble:(BOOL)submission withID:(NSString *)id {
    NSString *scrobbleURL = [NSString stringWithFormat:@"%@&id=%@&submission=%@", [AppDelegate getEndpoint:@"scrobble"], id, (submission ? @"true" : @"false") ];
    RSSParser *parser = [[RSSParser alloc] initWithRSSFeed: scrobbleURL];

    if ( parser != nil )
        return true;

    return false;
}

-(void)adjustVolume
{
    if (avPlayer != nil)
    {
        //[avPlayer set = volumeSlider.value;
    }
} 

#pragma mark - Image Reflection

CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh)
{
    CGImageRef theCGImage = NULL;
    
    // gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // create the bitmap context
    CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh,
                                                               8, 0, colorSpace, kCGImageAlphaNone);
    
    // define the start and end grayscale values (with the alpha, even though
    // our bitmap context doesn't support alpha the gradient requires it)
    CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
    
    // create the CGGradient and then release the gray color space
    CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGColorSpaceRelease(colorSpace);
    
    // create the start and end points for the gradient vector (straight down)
    CGPoint gradientStartPoint = CGPointZero;
    CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);
    
    // draw the gradient into the gray bitmap context
    CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
                                gradientEndPoint, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(grayScaleGradient);
    
    // convert the context into a CGImageRef and release the context
    theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
    CGContextRelease(gradientBitmapContext);
    
    // return the imageref containing the gradient
    return theCGImage;
}

CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create the bitmap context
    CGContextRef bitmapContext = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8,
                                                        0, colorSpace,
                                                        // this will give us an optimal BGRA format for the device:
                                                        (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGColorSpaceRelease(colorSpace);
    
    return bitmapContext;
}

- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height
{
    if(height == 0)
        return nil;
    
    // create a bitmap graphics context the size of the image
    CGContextRef mainViewContentContext = MyCreateBitmapContext(fromImage.bounds.size.width, height);
    
    // create a 2 bit CGImage containing a gradient that will be used for masking the 
    // main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
    // function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
    CGImageRef gradientMaskImage = CreateGradientImage(1, height);
    
    // create an image by masking the bitmap of the mainView content with the gradient view
    // then release the  pre-masked content bitmap and the gradient bitmap
    CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, fromImage.bounds.size.width, height), gradientMaskImage);
    CGImageRelease(gradientMaskImage);
    
    // In order to grab the part of the image that we want to render, we move the context origin to the
    // height of the image that we want to capture, then we flip the context so that the image draws upside down.
    CGContextTranslateCTM(mainViewContentContext, 0.0, height);
    CGContextScaleCTM(mainViewContentContext, 1.0, -1.0);
    
    // draw the image into the bitmap context
    CGContextDrawImage(mainViewContentContext, fromImage.bounds, fromImage.image.CGImage);
    
    // create CGImageRef of the main view bitmap content, and then release that bitmap context
    CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    // convert the finished reflection image to a UIImage 
    UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
    
    // image is retained by the property setting above, so we can release the original
    CGImageRelease(reflectionImage);
    
    return theImage;
}


@end
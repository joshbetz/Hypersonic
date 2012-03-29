//
//  NowPlaying.m
//  Subsonic
//
//  Created by Josh Betz on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NowPlaying.h"
#import "AppDelegate.h"
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <MediaPlayer/MPVolumeView.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItemCollection.h>

@interface NowPlaying ()
@end

@implementation NowPlaying
@synthesize songID, playerItem, playButton, userName, userPassword, serverURL, albumArt, albumArtID, nextButton, prevButton, volumeSlider;
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
    if(songList.count > 0 && differentAlbum == true) {
        queueList = [NSMutableArray array];
        itemList = [NSMutableArray array];
        NSString *userURL;
        NSURL *url;
        for (int i = 0; i < [songList count]; i++){
            userURL = @"http://";
            userURL = [userURL stringByAppendingString:server];
            userURL = [userURL stringByAppendingString:@"/rest/stream.view?u="];
            userURL = [userURL stringByAppendingString:name];
            userURL = [userURL stringByAppendingString:@"&p="];
            userURL = [userURL stringByAppendingString:password];
            userURL = [userURL stringByAppendingString:@"&v=1.1.0&c=Hypersonic&id="];
            userURL = [userURL stringByAppendingString:[[songList objectAtIndex:i] songID]];
            url = [NSURL URLWithString:userURL];
            [queueList addObject:url];
        }
        if (albumArtID != nil) {
            userURL = @"http://";
            userURL = [userURL stringByAppendingString:server];
            userURL = [userURL stringByAppendingString:@"/rest/getCoverArt.view?u="];
            userURL = [userURL stringByAppendingString:name];
            userURL = [userURL stringByAppendingString:@"&p="];
            userURL = [userURL stringByAppendingString:password];
            userURL = [userURL stringByAppendingString:@"&v=1.1.0&c=Hypersonic&id="];
            userURL = [userURL stringByAppendingString:albumArtID];
            NSURL *imageURL = [NSURL URLWithString: userURL];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:imageData]; 
            albumArt.image = image;
            art = image;
        }
    
        NSLog(@"%d", [queueList count]);
        playerItem = [AVPlayerItem playerItemWithURL:[queueList objectAtIndex:currentIndex]];
        avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        for (int i = 0; i < [queueList count]; i++){
            url = [queueList objectAtIndex:i];
            [itemList addObject:[AVPlayerItem playerItemWithURL:url]];
        }
        differentAlbum = false;
        
        avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[avPlayer currentItem]];
    }
    else if (differentAlbum == false) {
        if (art != nil){
            albumArt.image = art;
        }
    }
    //AVPlayerLayer *avPlayerLayer = [[AVPlayerLayer playerLayerWithPlayer:avPlayer] retain];
    //[avPlayer play];
    //avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(20,380,280,20)];
    [volumeView sizeToFit];
    [self.view addSubview:volumeView];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if( avPlayer.rate == 0 || (differentAlbum == true && [itemList count] > 0))
        [self playSong:playButton];
    else if (avPlayer.rate > 0)
        [playButton setTitle:@"Pause" forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
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

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self nextSong:nextButton];
}

- (void)viewDidUnload
{
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
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:art];
        NSDictionary *songInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"Some artist", MPMediaItemPropertyArtist,
                                  @"Some title", MPMediaItemPropertyTitle,
                                  @"Some Album", MPMediaItemPropertyAlbumTitle,
                                  artwork, MPMediaItemPropertyArtwork,
                                  nil];
        center.nowPlayingInfo = songInfo;
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
            [playButton setTitle:@"Pause" forState:UIControlStateNormal];
        }   
        else {
            [avPlayer pause];
            [playButton setTitle:@"Play" forState:UIControlStateNormal];
        }
    }
    [self setMediaInfo];
}

-(IBAction)nextSong:(id)nextButton{
    if ([itemList count] > 0){
        currentIndex++;
        if (currentIndex == [queueList count]){
            [avPlayer pause];
            currentIndex = 0;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
            avPlayer = [AVPlayer playerWithPlayerItem:[itemList objectAtIndex:currentIndex]];
            [avPlayer play];
            newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
            avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone; 
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[avPlayer currentItem]];
        }
    }
}


-(IBAction)prevSong:(id)prevButton{
    if ([itemList count] > 0){
        currentIndex--;
        if (currentIndex < 0){
            currentIndex = 0;
        }
        UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
        avPlayer = [AVPlayer playerWithPlayerItem:[itemList objectAtIndex:currentIndex]];
        [avPlayer play];
        newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
        avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[avPlayer currentItem]];
    }
}

-(void)adjustVolume
{
    if (avPlayer != nil)
    {
        //[avPlayer set = volumeSlider.value;
    }
} 

@end
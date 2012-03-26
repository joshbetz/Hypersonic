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
#import "MediaPlayer/MPVolumeView.h"
@interface NowPlaying ()
@end

@implementation NowPlaying
@synthesize songID, avPlayer, playerItem, playButton, userName, userPassword, serverURL, albumArt, albumArtID, songList, queueList, nextButton, prevButton, itemList, volumeSlider;
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
    self.queueList = [NSMutableArray array];
    self.itemList = [NSMutableArray array];
    NSString *userURL;
    NSURL *url;
    for (int i = 0; i < [songList count] - 1; i++){
        userURL = @"http://";
        userURL = [userURL stringByAppendingString:server];
        userURL = [userURL stringByAppendingString:@"/rest/stream.view?u="];
        userURL = [userURL stringByAppendingString:name];
        userURL = [userURL stringByAppendingString:@"&p="];
        userURL = [userURL stringByAppendingString:password];
        userURL = [userURL stringByAppendingString:@"&v=1.1.0&c=Hypersonic&id="];
        userURL = [userURL stringByAppendingString:[[songList objectAtIndex:i] songID]];
        url = [NSURL URLWithString:userURL];
        [self.queueList addObject:url];
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
    }
    NSLog(@"%d", [queueList count]);
    playerItem = [AVPlayerItem playerItemWithURL:[queueList objectAtIndex:currentIndex]];
    avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    for (int i = 0; i < [queueList count] - 1; i++){
        url = [queueList objectAtIndex:i];
        [self.itemList addObject:[AVPlayerItem playerItemWithURL:url]];
    }
    //AVPlayerLayer *avPlayerLayer = [[AVPlayerLayer playerLayerWithPlayer:avPlayer] retain];
    //[avPlayer play];
    //avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(200,100,100,200)];
    [volumeView sizeToFit];
    [self.view addSubview:volumeView];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

- (IBAction)done:(id)sender
{  
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)playSong:(id)playButton{
    if ([[(UIButton *)playButton currentTitle] isEqualToString:@"Play"]){
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    [avPlayer play];
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    [playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }   
    else if ([[(UIButton *)playButton currentTitle] isEqualToString:@"Pause"]){
        [avPlayer pause];
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
}

-(IBAction)nextSong:(id)nextButton{
    currentIndex++;
    if (currentIndex == [queueList count]){
        currentIndex--;
    }
    else {
        UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
        avPlayer = [AVPlayer playerWithPlayerItem:[itemList objectAtIndex:currentIndex]];
        [avPlayer play];
        newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    }
}


-(IBAction)prevSong:(id)prevButton{
    currentIndex--;
    if (currentIndex < 0){
        currentIndex++;
    }
    else {
        UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
        avPlayer = [AVPlayer playerWithPlayerItem:[itemList objectAtIndex:currentIndex]];
        [avPlayer play];
        newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];

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
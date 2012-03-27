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
@synthesize songID, playerItem, playButton, userName, userPassword, serverURL, albumArt, albumArtID, songList, queueList, nextButton, prevButton, itemList, volumeSlider;
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
    if(avPlayer.rate == 0) {
        self.queueList = [NSMutableArray array];
        self.itemList = [NSMutableArray array];
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
        for (int i = 0; i < [queueList count]; i++){
            url = [queueList objectAtIndex:i];
            [self.itemList addObject:[AVPlayerItem playerItemWithURL:url]];
        }
    }
    //AVPlayerLayer *avPlayerLayer = [[AVPlayerLayer playerLayerWithPlayer:avPlayer] retain];
    //[avPlayer play];
    //avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(20,420,280,20)];
    [volumeView sizeToFit];
    [self.view addSubview:volumeView];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self playSong:playButton];
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

-(IBAction)playSong:(id)sender{
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
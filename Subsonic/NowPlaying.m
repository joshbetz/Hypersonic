//
//  NowPlaying.m
//  Subsonic
//
//  Created by Josh Betz on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NowPlaying.h"
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVPlayer.h>

@interface NowPlaying ()
@end

@implementation NowPlaying
@synthesize songID, avPlayer, playerItem, playButton;
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
    NSString *userURL = @"http://wilmothighschool.com:4040/rest/stream.view?u=mobileappdev&p=mobile123&v=1.1.0&c=myapp&id=";
    userURL = [userURL stringByAppendingString:songID];
    NSLog(userURL);
    NSURL *url=[NSURL URLWithString:userURL];
    playerItem = [AVPlayerItem playerItemWithURL:url];
    avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    //AVPlayerLayer *avPlayerLayer = [[AVPlayerLayer playerLayerWithPlayer:avPlayer] retain];
    //[avPlayer play];
    //avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
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
    [avPlayer play];
    [playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }   
    else if ([[(UIButton *)playButton currentTitle] isEqualToString:@"Pause"]){
        [avPlayer pause];
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
}
@end
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
@synthesize songID, avPlayer, playerItem, playButton, userName, userPassword, serverURL, albumArt, albumArtID;
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
    NSString *userURL = @"http://";
    userURL = [userURL stringByAppendingString:serverURL];
    userURL = [userURL stringByAppendingString:@"/rest/stream.view?u="];
    userURL = [userURL stringByAppendingString:userName];
    userURL = [userURL stringByAppendingString:@"&p="];
    userURL = [userURL stringByAppendingString:userPassword];
    userURL = [userURL stringByAppendingString:@"&v=1.1.0&c=Hypersonic&id="];
    userURL = [userURL stringByAppendingString:songID];
    NSURL *url=[NSURL URLWithString:userURL];
    if (albumArtID != nil) {
    userURL = @"http://";
    userURL = [userURL stringByAppendingString:serverURL];
    userURL = [userURL stringByAppendingString:@"/rest/getCoverArt.view?u="];
    userURL = [userURL stringByAppendingString:userName];
    userURL = [userURL stringByAppendingString:@"&p="];
    userURL = [userURL stringByAppendingString:userPassword];
    userURL = [userURL stringByAppendingString:@"&v=1.1.0&c=Hypersonic&id="];
    userURL = [userURL stringByAppendingString:albumArtID];
    NSURL *imageURL = [NSURL URLWithString: userURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData]; 
    albumArt.image = image;
    }
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
//
//  NowPlaying.h
//  Subsonic
//
//  Created by Josh Betz on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVPlayer.h>

@interface NowPlaying : UIViewController {
    NSString *songID;
    AVPlayerItem *playerItem;
    AVPlayer *avPlayer;
    UIButton *playButton;
}

@property (nonatomic, strong) NSString *songID;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
- (IBAction)done:(id)sender;
-(IBAction)playSong:(id)playButton;

@end

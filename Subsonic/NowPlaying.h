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
    NSString *serverURL;
    NSString *userName;
    NSString *userPassword;
    AVPlayerItem *playerItem;
    AVPlayer *avPlayer;
    UIButton *playButton;
    UIImageView *albumArt;
    NSString *albumArtID;
    NSMutableArray *songList;
    NSMutableArray *queueList;
    UIButton *nextButton;
    UIButton *prevButton;
    @public 
    int currentIndex;
}

@property (nonatomic, strong) NSString *songID;
@property (nonatomic, strong) NSMutableArray *songList;
@property (nonatomic, strong) NSMutableArray *queueList;
@property (nonatomic, strong) NSString *albumArtID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, strong) NSString *serverURL;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) IBOutlet UIButton *prevButton;
@property (nonatomic, strong) IBOutlet UIImageView *albumArt;
- (IBAction)done:(id)sender;
-(IBAction)playSong:(id)playButton;
-(IBAction)nextSong:(id)nextButton;
-(IBAction)prevSong:(id)prevButton;

@end

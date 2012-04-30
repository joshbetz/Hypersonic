//
//  AppDelegate.h
//  Subsonic
//
//  Created by Josh Betz on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVPlayer.h>
#import "ArtistTableViewController.h"
#import "NowPlaying.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

extern NSString *server;
extern NSString *name;
extern NSString *password;
extern NSString *localServer;
extern BOOL localMode;
extern BOOL hqMode;
extern BOOL connectionProblem;
extern NSString *endpoint;
extern AVQueuePlayer *avPlayer;
extern NSMutableArray *songList;
extern NSMutableArray *queueList;
extern NSMutableArray *itemList;
extern int currentIndex;
extern int selectedArtistSection;
extern int selectedArtistIndex;
extern int selectedAlbumIndex;
extern NSMutableArray *artistList;
extern UIImage *art;
extern BOOL differentAlbum;
extern BOOL multiDisk;
extern BOOL firstTimeAlbum;
extern NSString *songInfo;
extern NowPlaying *nowPlaying;
extern BOOL albumMeth;
-(void)loadSettings;
-(void)saveSettings;
+(void)updateArtists;
+(NSString *)getEndpoint:(NSString *)method;
@end

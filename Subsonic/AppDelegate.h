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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

extern NSString *server;
extern NSString *name;
extern NSString *password;
extern NSString *localServer;
extern BOOL localMode;
extern BOOL hqMode;

extern NSString *endpoint;
extern AVQueuePlayer *avPlayer;
extern NSMutableArray *songList;
extern NSMutableArray *queueList;
extern NSMutableArray *itemList;
extern int currentIndex;
extern NSMutableArray *artistList;
extern UIImage *art;
extern BOOL differentAlbum;

-(void)loadSettings;
-(void)saveSettings;
+(void)updateArtists;
+(NSString *)getEndpoint:(NSString *)method;
@end

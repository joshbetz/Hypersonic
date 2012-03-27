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

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *serverURL;
    NSString *userName;
    NSString *userPassword;
    NSMutableArray *artistList;
    
}

extern NSString *server;
extern NSString *name;
extern NSString *password;
extern AVPlayer *avPlayer;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *serverURL;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSMutableArray *artistList;
-(void)loadSettings;
@end

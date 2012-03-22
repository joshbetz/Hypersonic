//
//  AppDelegate.h
//  Subsonic
//
//  Created by Josh Betz on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *serverURL;
    NSString *userName;
    NSString *userPassword;
    NSMutableArray *artistList;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *serverURL;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSMutableArray *artistList;
-(void)loadSettings;
@end

//
//  AppDelegate.m
//  Subsonic
//
//  Created by Josh Betz on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ArtistTableViewController.h"
#import "RSSParser.h"
@implementation AppDelegate

@synthesize window = _window, userName, userPassword, serverURL, artistList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self loadSettings];
    if (serverURL != nil){
        NSString *userURL = @"http://";
        userURL = [userURL stringByAppendingString:serverURL];
        userURL = [userURL stringByAppendingString:@"/rest/getIndexes.view?u="];
        userURL = [userURL stringByAppendingString:userName];
        userURL = [userURL stringByAppendingString:@"&p="];
        userURL = [userURL stringByAppendingString:userPassword];
        userURL = [userURL stringByAppendingString:@"&v=1.1.0&c=myapp"];
        RSSParser *rssParser = [[RSSParser alloc] initWithRSSFeed: userURL];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Start"]; 
        UINavigationController *xy = [[vc viewControllers] objectAtIndex:0];
        ArtistTableViewController *next = [[xy viewControllers] objectAtIndex:0];
        next.artistList = rssParser.artistList;
        next.serverURL = serverURL;
        next.userPassword = userPassword;
        next.userName = userName;
        self.window.rootViewController = vc;
	} else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LoginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
        self.window.rootViewController = vc;
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void)loadSettings{
	
    
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	serverURL = [prefs objectForKey:@"serverURL"];
	userPassword = [prefs objectForKey:@"userPassword"];
	userName = [prefs objectForKey:@"userName"];
    
	
}
         
@end

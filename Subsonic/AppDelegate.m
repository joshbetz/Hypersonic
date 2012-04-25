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
#import "NowPlaying.h"
#import "MKiCloudSync.h"

@implementation AppDelegate

@synthesize window = _window;

NSString *password;
NSString *name;
NSString *server;
NSString *localServer;
BOOL localMode;
BOOL hqMode;
BOOL connectionProblem = false;
NSString *endpoint;
AVQueuePlayer *avPlayer;
NSMutableArray *songList;
NSMutableArray *queueList;
NSMutableArray *itemList;
UIImage *art;
int currentIndex;
BOOL differentAlbum = false;
NSMutableArray *artistList;
int selectedArtistSection;
int selectedArtistIndex;
int selectedAlbumIndex;
BOOL multiDisk;
BOOL firstTimeAlbum;
NSString *songInfo;
NowPlaying *nowPlaying;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [MKiCloudSync start];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    [self loadSettings];
    
    if (server != nil){
        endpoint = [AppDelegate getEndpoint:@"getIndexes"];
        
        if ( artistList == nil )
            [AppDelegate updateArtists];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Start"]; 
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
    if (server != nil && password != nil && name != nil){
        NSString *userURL = [AppDelegate getEndpoint:@"ping"];
        RSSParser *rssParser = [[RSSParser alloc] initWithRSSFeed: userURL];
        NSMutableArray *errors = rssParser.errorList;
        
        if (![errors count] > 0 && !connectionProblem){
            [self saveSettings];
        }
    }
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

-(void)loadSettings {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
	server = [prefs objectForKey:@"iCloud-serverURL"];
	password = [prefs objectForKey:@"iCloud-userPassword"];
	name = [prefs objectForKey:@"iCloud-userName"];
    localServer = [prefs objectForKey:@"iCloud-localServerURL"];
    localMode = [prefs boolForKey:@"iCloud-localMode"];
    hqMode = [prefs boolForKey:@"iCloud-hqMode"];
    
    NSData *data = [prefs objectForKey:@"local-artistList"];
    artistList = [[NSKeyedUnarchiver unarchiveObjectWithData:data]mutableCopy];
}

-(void)saveSettings {

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:server forKey:@"iCloud-serverURL"];
    [prefs setObject:password forKey:@"iCloud-userPassword"];
    [prefs setObject:name forKey:@"iCloud-userName"];
    [prefs setObject:localServer forKey:@"iCloud-localServerURL"];
    [prefs setBool:localMode forKey:@"iCloud-localMode"];
    [prefs setBool:hqMode forKey:@"iCloud-hqMode"];
    [prefs synchronize];  
    
}

+(NSString *)getEndpoint:(NSString *)method {
    NSString *serverURL;
    if ( localMode )
        serverURL = localServer;
    else
        serverURL = server;
        
    if ( [serverURL length] > 8 && ![[serverURL substringToIndex:7] isEqualToString:@"http://"] && ![[serverURL substringToIndex:8] isEqualToString:@"https://"] )
        serverURL = [NSString stringWithFormat:@"http://%@", serverURL];
    
    return [NSString stringWithFormat:@"%@/rest/%@.view?v=1.1.0&c=Hypersonic&u=%@&p=%@", serverURL, method, name, password];
}

+ (void)updateArtists
{   
    NSString *userURL = [AppDelegate getEndpoint:@"getIndexes"];
    
    RSSParser *rssParser = [[RSSParser alloc] initWithRSSFeed: userURL];
    artistList = rssParser.artistList;
    NSLog(@"%d", [artistList count]);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rssParser.artistList];
	[prefs setObject:data  forKey:@"local-artistList"];
    [prefs synchronize];
}
         
@end

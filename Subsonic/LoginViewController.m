//
//  LoginViewController.m
//  Subsonic
//
//  Created by Erin Rasmussen on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ArtistTableViewController.h"
#import "RSSParser.h"
#import "MKiCloudSync.h"

@implementation LoginViewController
@synthesize loginButton, passwordText, nameText, serverText, userPassword, userName, serverURL, artistListProperty;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Login"]) {
        userName = nameText.text;
        serverURL = serverText.text;
        userPassword = passwordText.text;
        UINavigationController *navigationController = segue.destinationViewController;
        navigationController = [[navigationController viewControllers] objectAtIndex:0];
        name = userName;
        password = userPassword;
        server = serverURL;
        NSString *userURL = [AppDelegate getEndpoint:@"getIndexes"];
        RSSParser *rssParser = [[RSSParser alloc] initWithRSSFeed: userURL];
        artistList = rssParser.artistList;
        artistListProperty = rssParser.artistList;
        [self saveSettings];
    }
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *imageSize = @"Default.png";
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2) {
        imageSize = @"Default@2x.png";
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageSize]];
    [tempImageView setFrame:self.tableView.frame]; 
    
    self.tableView.backgroundView = tempImageView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(iCloudLogin) 
                                                 name:kMKiCloudSyncNotification                                                    
                                               object:nil];
    [MKiCloudSync requestUpdate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:kMKiCloudSyncNotification];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)loadSettings {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
	server = [prefs objectForKey:@"iCloud-serverURL"];
	password = [prefs objectForKey:@"iCloud-userPassword"];
	name = [prefs objectForKey:@"iCloud-userName"];
    localServer = [prefs objectForKey:@"iCloud-localServerURL"];
    localMode = [prefs boolForKey:@"iCloud-localMode"];
    hqMode = [prefs boolForKey:@"iCloud-hqMode"];
}

- (void) iCloudLogin {
    [self loadSettings];
    
    if ([server length] != 0 && [password length] != 0 && [name length] != 0) {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Login with iCloud?" message:@"Hypersonic preferences were found in iCloud. Login with these settings?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login",nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    }
    else if (buttonIndex == 1)
    {
        nameText.text = name;
        serverText.text = server;
        passwordText.text = password;
        [self login:nil];
    }
}

-(void)saveSettings{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:userName  forKey:@"iCloud-userName"];
	[prefs setObject:userPassword forKey:@"iCloud-userPassword"];
	[prefs setObject:serverURL forKey:@"iCloud-serverURL"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:artistListProperty];
	[prefs setObject:data  forKey:@"local-artistList"];
    [prefs synchronize];
	
}

-(IBAction)login:(id)sender{
    if (([nameText.text length] == 0 && [name length] == 0) || ([serverText.text length] == 0 && [server length] == 0) || ([passwordText.text length] == 0 && [password length] == 0)){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Please enter a server URL, username, and password!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close",nil];
        [alertView show];
    }
    else{
        name = nameText.text;
        server = serverText.text;
        password = passwordText.text;
        
        NSString *userURL = [AppDelegate getEndpoint:@"ping"];
        NSURL *temp = [NSURL URLWithString:userURL];
        if (temp != nil) {
            RSSParser *rssParser = [[RSSParser alloc] initWithRSSFeed: userURL];
            NSMutableArray *errors = rssParser.errorList;
            if ([errors count] > 0 || connectionProblem){
                if ([errors count] > 0){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:[[errors objectAtIndex:0] message] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close",nil];
                    [alertView show];
                }
                connectionProblem = false;
            }
            else{
                [self saveSettings];
                [self performSegueWithIdentifier:@"Login" sender:nil];
            }
        }
    }
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    if (([nameText.text length] != 0 || [name length] != 0) && ([serverText.text length] != 0 || [server length] != 0) && ([passwordText.text length] != 0 || [password length] != 0)){
        [self login:sender];
    }
    
}
-(IBAction)backgroundTouched:(id)sender
{
    [serverText resignFirstResponder];
    [passwordText resignFirstResponder];
    [nameText resignFirstResponder];
}

@end

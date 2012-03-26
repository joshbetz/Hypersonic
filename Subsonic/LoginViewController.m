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

@implementation LoginViewController
@synthesize loginButton, password, name, server, userPassword, userName, serverURL, artistList;
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
        userName = name.text;
        serverURL = server.text;
        userPassword = password.text;
        UINavigationController *navigationController = segue.destinationViewController;
        navigationController = [[navigationController viewControllers] objectAtIndex:0];
        ArtistTableViewController *nextViewController = [[navigationController viewControllers] objectAtIndex:0];
        NSString *userURL = @"http://";
        userURL = [userURL stringByAppendingString:serverURL];
        userURL = [userURL stringByAppendingString:@"/rest/getIndexes.view?u="];
        userURL = [userURL stringByAppendingString:userName];
        userURL = [userURL stringByAppendingString:@"&p="];
        userURL = [userURL stringByAppendingString:userPassword];
        userURL = [userURL stringByAppendingString:@"&v=1.1.0&c=Hypersonic"];
        RSSParser *rssParser = [[RSSParser alloc] initWithRSSFeed: userURL];
        nextViewController.artistList = rssParser.artistList;
        nextViewController.serverURL = serverURL;
        nextViewController.userPassword = userPassword;
        nextViewController.userName = userName;
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
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default@2x.png"]];
    [tempImageView setFrame:self.tableView.frame]; 
    
    self.tableView.backgroundView = tempImageView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)saveSettings{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:userName  forKey:@"userName"];
	[prefs setObject:userPassword forKey:@"userPassword"];
	[prefs setObject:serverURL forKey:@"serverURL"];
    [prefs synchronize];
	
}

-(IBAction)login:(id)loginButton{
    [self saveSettings];
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}
-(IBAction)backgroundTouched:(id)sender
{
    [server resignFirstResponder];
    [password resignFirstResponder];
    [name resignFirstResponder];
}

@end

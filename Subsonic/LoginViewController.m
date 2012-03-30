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
        //ArtistTableViewController *nextViewController = [[navigationController viewControllers] objectAtIndex:0];
        name = userName;
        password = userPassword;
        server = serverURL;
        NSString *userURL = endpoint;
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
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:artistListProperty];
	[prefs setObject:data  forKey:@"artistList"];
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
    [serverText resignFirstResponder];
    [passwordText resignFirstResponder];
    [nameText resignFirstResponder];
}

@end

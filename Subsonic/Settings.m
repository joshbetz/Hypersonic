//
//  Settings.m
//  Subsonic
//
//  Created by Josh Betz on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "AppDelegate.h"
#import "RSSParser.h"

@interface Settings ()

@end

@implementation Settings

@synthesize loginLabel, localServerLabel, serverLabel, passwordLabel, localModeSwitch, hqModeSwitch;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.parentViewController.title = @"Settings";
    
    serverLabel.text = server;
    loginLabel.text = name;
    localServerLabel.text = localServer;
    localModeSwitch.on = localMode;
    hqModeSwitch.on = hqMode;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([loginLabel.text length] == 0 || [serverLabel.text length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Please enter a server URL, username, and password!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close",nil];
        [alertView show];
    }
    else{
        NSString *tempServer = serverLabel.text;
        NSString *tempName = loginLabel.text;
        localServer = localServerLabel.text;
        localMode = localModeSwitch.on;
        hqMode = hqModeSwitch.on;
        NSString *tempPassword = password;
        if( [passwordLabel.text length] > 0 )
            tempPassword = passwordLabel.text;
        NSString *userURL = [self makeURL:@"ping" :tempServer :tempName :tempPassword];
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
                server = serverLabel.text;
                name = loginLabel.text;
                localServer = localServerLabel.text;
                localMode = localModeSwitch.on;
                hqMode = hqModeSwitch.on;
                if( [passwordLabel.text length] > 0 )
                    password = passwordLabel.text;
            }
        }
    }
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSString *)makeURL:(NSString *)method: (NSString *)serverName: (NSString *)login: (NSString *)passwordUser{
    NSString *serverURL;
    if ( localMode )
        serverURL = localServer;
    else
        serverURL = serverName;
    
    if ( [serverURL length] > 8 && ![[serverURL substringToIndex:7] isEqualToString:@"http://"] && ![[serverURL substringToIndex:8] isEqualToString:@"https://"] )
        serverURL = [NSString stringWithFormat:@"http://%@", serverURL];
    
    return [NSString stringWithFormat:@"%@/rest/%@.view?v=1.1.0&c=Hypersonic&u=%@&p=%@", serverURL, method, login, passwordUser];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void) hideKeyboard {
    [[self.tableView superview] endEditing:YES];
}

@end

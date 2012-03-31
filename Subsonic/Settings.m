//
//  Settings.m
//  Subsonic
//
//  Created by Josh Betz on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings

@synthesize login, loginLabel, localServer, localServerLabel, server, serverLabel,  password, passwordLabel;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.parentViewController.title = @"Settings";
    
    [self loadSettings];
    serverLabel.text = server;
    loginLabel.text = login;
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

-(void)loadSettings{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	server = [prefs objectForKey:@"serverURL"];
	login = [prefs objectForKey:@"userName"];
}

-(void)saveSettings{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
	//[prefs setObject:data  forKey:@"artistList"];
    [prefs synchronize];
}

@end

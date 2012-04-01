//
//  Settings.m
//  Subsonic
//
//  Created by Josh Betz on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "AppDelegate.h"

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
    
    server = serverLabel.text;
    name = loginLabel.text;
    localServer = localServerLabel.text;
    localMode = localModeSwitch.on;
    hqMode = hqModeSwitch.on;
    
    if( [passwordLabel.text length] > 0 )
        password = passwordLabel.text;
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

- (void) hideKeyboard {
    [[self.tableView superview] endEditing:YES];
}

@end

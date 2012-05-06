//
//  AlbumMethodsTableViewController.m
//  Subsonic
//
//  Created by Erin Rasmussen on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumMethodsTableViewController.h"
#import "AppDelegate.h"
#import "AlbumSongTableViewController.h"

@implementation AlbumMethodsTableViewController
@synthesize activityIndicator;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    types[0] = @"Random";
    types[1] = @"Newest";
    types[2] = @"Highest";
    types[3] = @"Frequent";
    types[4] = @"Recent";
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.parentViewController.title = @"Albums";
    
    if ( [avPlayer currentItem] == nil )
        self.parentViewController.navigationItem.rightBarButtonItem = nil;
    else {
        // custom now playing button
        UIButton *nowplaying = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 61, 31)];
        [nowplaying setImage:[UIImage imageNamed:@"nowplaying.png"] forState:UIControlStateNormal];
        [nowplaying addTarget:self action:@selector(pushToPlayer) forControlEvents:UIControlEventTouchUpInside];
        self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nowplaying];
    }
}

- (void) pushToPlayer {
    [self.navigationController pushViewController:nowPlaying animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    albumMeth = true;
    if ([[segue identifier] isEqualToString:@"Random"]) {
        AlbumSongTableViewController *nextViewController = [segue destinationViewController];
        
        if ([self.tableView indexPathForSelectedRow].row == 0){
            nextViewController.userURL = [NSString stringWithFormat:@"%@&type=%@", [AppDelegate getEndpoint:@"getAlbumList"], @"random"];
        }
        else if ([self.tableView indexPathForSelectedRow].row == 1){
            nextViewController.userURL = [NSString stringWithFormat:@"%@&type=%@", [AppDelegate getEndpoint:@"getAlbumList"], @"newest"];
        }
        else if ([self.tableView indexPathForSelectedRow].row == 2){
            nextViewController.userURL = [NSString stringWithFormat:@"%@&type=%@", [AppDelegate getEndpoint:@"getAlbumList"], @"highest"];
        }
        else if ([self.tableView indexPathForSelectedRow].row == 3){
            nextViewController.userURL = [NSString stringWithFormat:@"%@&type=%@", [AppDelegate getEndpoint:@"getAlbumList"], @"frequent"];
        }
        else if ([self.tableView indexPathForSelectedRow].row == 4){
            nextViewController.userURL = [NSString stringWithFormat:@"%@&type=%@", [AppDelegate getEndpoint:@"getAlbumList"], @"recent"];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Random";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = types[[indexPath row]];
    // Configure the cell...
    
    return cell;
}


@end

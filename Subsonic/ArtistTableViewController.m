//
//  ArtistTableViewController.m
//  Subsonic
//
//  Created by Erin Rasmussen on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArtistTableViewController.h"
#import "RSSParser.h"
#import "Artist.h"
#import "AlbumTableViewController.h"
#import "AlbumSongTableViewController.h"
#import "LoginViewController.h"

@implementation ArtistTableViewController

@synthesize artistList, serverURL, userName,userPassword;

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
   /* NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	serverURL = [prefs objectForKey:@"serverURL"];
	userPassword = [prefs objectForKey:@"userPassword"];
	userName = [prefs objectForKey:@"userName"];
    NSLog(@"1");
	if (serverURL == nil){
        NSLog(@"2");
        LoginViewController *next = [[LoginViewController alloc] init];
        //[self pushViewController:self.window.rootViewController];
        //[self.window addSubview: next];
        [self presentModalViewController:next animated:YES];
        
	}	*/
    
    //NSString *userURL = @"http://wilmothighschool.com:4040/rest/getIndexes.view?u=mobileappdev&p=mobile123&v=1.1.0&c=myapp";
    //RSSParser *rssParser = [[RSSParser alloc] initWithRSSFeed: userURL];
    //artistList = rssParser.artistList;
    [super viewDidLoad];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if ([[segue identifier] isEqualToString:@"ShowAlbums"]) {
        /*NSString *artistID = [[artistList objectAtIndex:[self.tableView indexPathForSelectedRow].row] artistID];
        NSString *userURL = @"http://wilmothighschool.com:4040/rest/getMusicDirectory.view?u=mobileappdev&p=mobile123&v=1.1.0&c=myapp&id=";
        userURL = [userURL stringByAppendingString:artistID];
        NSLog(userURL);
        AlbumTableViewController *nextViewController = [segue destinationViewController];
        nextViewController.parser = [[RSSParser alloc] initWithRSSFeed: userURL];    
        nextViewController.albumList = nextViewController.parser.albumList;
        NSLog([NSString stringWithFormat:@"%d", [nextViewController.albumList count]]); */
    }
    else if ([[segue identifier] isEqualToString:@"AlbumClick"]) {
        NSString *artistID = [[artistList objectAtIndex:[self.tableView indexPathForSelectedRow].row] artistID];
        NSString *userURL = @"http://wilmothighschool.com:4040/rest/getMusicDirectory.view?u=mobileappdev&p=mobile123&v=1.1.0&c=myapp&id=";
        userURL = [userURL stringByAppendingString:artistID];
        AlbumSongTableViewController *nextViewController = [segue destinationViewController];
        nextViewController.parser = [[RSSParser alloc] initWithRSSFeed: userURL];
    }
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
    return [artistList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[artistList objectAtIndex: indexPath.row] artistName] ];
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

@end

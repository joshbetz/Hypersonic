//
//  AlbumSongTableViewController.m
//  Subsonic
//
//  Created by Erin Rasmussen on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumSongTableViewController.h"
#import "Artist.h"
#import "Album.h"
#import "Song.h"
#import "NowPlaying.h"

@implementation AlbumSongTableViewController
@synthesize songList, albumList, parser, userPassword, userName, serverURL;
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
    albumList = parser.albumList;
    songList  = parser.songList;
    if ([albumList count] > 0) {
        albums = true;
    }
    else {
        albums = false;
    }
    if ([songList count] > 0){
        songs = true;
    }
    else {
        songs = false;
    }
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
        NSString *albumID = [[albumList objectAtIndex:[self.tableView indexPathForSelectedRow].row] albumID];
        NSString *userURL = @"http://";
        userURL = [userURL stringByAppendingString:serverURL];
        userURL = [userURL stringByAppendingString:@"/rest/getMusicDirectory.view?u="];
        userURL = [userURL stringByAppendingString:userName];
        userURL = [userURL stringByAppendingString:@"&p="];
        userURL = [userURL stringByAppendingString:userPassword];
        userURL = [userURL stringByAppendingString:@"&v=1.1.0&c=Hypersonic&id="];
         userURL = [userURL stringByAppendingString:albumID];
         AlbumSongTableViewController *nextViewController = [segue destinationViewController];
        nextViewController.userName = userName;
        nextViewController.userPassword = userPassword;
        nextViewController.serverURL = serverURL;
         nextViewController.parser = [[RSSParser alloc] initWithRSSFeed: userURL];    
    }
    if ([[segue identifier] isEqualToString:@"SelectedSong"]) {
        NSString *song = [[songList objectAtIndex:[self.tableView indexPathForSelectedRow].row] songID];
        NowPlaying *nextViewController = [segue destinationViewController];
        nextViewController.songID = song;    
        nextViewController.userName = userName;
        nextViewController.userPassword = userPassword;
        nextViewController.serverURL = serverURL;
        if ([[songList objectAtIndex:[self.tableView indexPathForSelectedRow].row] albumArt] != nil){
        nextViewController.albumArtID = [[songList objectAtIndex:[self.tableView indexPathForSelectedRow].row] albumArt];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (songs == true && albums && true){
        // fix this edge case!
        return 0;
    } else if (songs == true){
        return [songList count];
    }
    else {
        return [albumList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Edge case with songs and albums mixed - need a way to fill the table in an organized way.
    if (songs == true && albums && true){
        static NSString *CellIdentifier = @"Albums";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        
        return cell;
    } else if (songs == true){
    static NSString *CellIdentifier = @"Songs";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[songList objectAtIndex: indexPath.row] songName] ];
    // Configure the cell...
    
    return cell;
    }
    else {
        static NSString *CellIdentifier = @"Albums";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[albumList objectAtIndex: indexPath.row] albumName] ];
        
        return cell;
    }
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

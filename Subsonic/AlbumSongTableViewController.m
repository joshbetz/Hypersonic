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
#import "AppDelegate.h"

@implementation AlbumSongTableViewController
@synthesize albumList, userURL, userPassword, userName, serverURL;
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
    RSSParser *parser = [[RSSParser alloc] initWithRSSFeed: userURL];
    
    albumList = parser.albumList;
    songList  = parser.songList;
    if ([songList count] > 0){
        songs = true;
        self.title = [[songList objectAtIndex:0] albumName];
    }
    else {
        songs = false;
    }    
    if ([albumList count] > 0) {
        albums = true;
        self.title = [[albumList objectAtIndex:0] artistName];
    }
    else {
        albums = false;
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
    
    if ( [avPlayer currentItem] == nil )
        self.navigationItem.rightBarButtonItem = nil;
    else {
        UIBarButtonItem *nowPlaying = [[UIBarButtonItem alloc] initWithTitle:@"Now Playing" style:UIBarButtonItemStylePlain target:self action: @selector(pushToPlayer)];
        self.navigationItem.rightBarButtonItem = nowPlaying;
    }
}

- (void) pushToPlayer {
    NowPlaying *player = [self.storyboard instantiateViewControllerWithIdentifier:@"NowPlaying"];
    [self.navigationController pushViewController:player animated:YES];
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
        AlbumSongTableViewController *nextViewController = [segue destinationViewController];
        NSString *directoryID = [[albumList objectAtIndex:[self.tableView indexPathForSelectedRow].row] albumID];
        nextViewController.userURL = [NSString stringWithFormat:@"%@&id=%@", [AppDelegate getEndpoint:@"getMusicDirectory"], directoryID];
    }
    if ([[segue identifier] isEqualToString:@"SelectedSong"]) {
        NowPlaying *nextViewController = [segue destinationViewController];
        
        art = nil;
        currentIndex = [self.tableView indexPathForSelectedRow].row;
        differentAlbum = true;
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
    if ( songs && albums ) {
        static NSString *CellIdentifier = @"Albums";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        
        return cell;
    }
    else if ( songs ) {
        static NSString *CellIdentifier = @"Songs";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[songList objectAtIndex: indexPath.row] songName] ];
               
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"Albums";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[albumList objectAtIndex: indexPath.row] albumName]];
        if ([[albumList objectAtIndex: indexPath.row] artistName] != nil){
            cell.detailTextLabel.text = [[albumList objectAtIndex: indexPath.row] artistName];
        }
        else{
            cell.detailTextLabel.text = @"";
        }
        if ([[albumList objectAtIndex: indexPath.row] coverArt] != nil){
            NSString *userURL = [NSString stringWithFormat:@"%@&id=%@", [AppDelegate getEndpoint:@"getCoverArt"], [[albumList objectAtIndex: indexPath.row] coverArt]];
            NSURL *imageURL = [NSURL URLWithString: userURL];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:imageData]; 
            cell.imageView.image = image;
        }
        return cell;
    }
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    if ( songs && !albums ) {
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = indexPath.row % 2 ? [UIColor colorWithRed: 248.0/255.0 green: 248.0/255.0 blue: 248.0/255.0 alpha: 1.0] : [UIColor whiteColor];
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
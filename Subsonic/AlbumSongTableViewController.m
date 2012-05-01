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
@synthesize albumList, userURL, userPassword, userName, serverURL, artistListProperty, activityIndicator;
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
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.backgroundColor = [UIColor grayColor];
	activityIndicator.hidesWhenStopped = YES;
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    [self.view addSubview:activityIndicator];
    
    NSMutableArray *currentAlbumList = [[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex] albumList];
    NSMutableArray *currentSongList = [[[[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex] albumList]objectAtIndex:selectedAlbumIndex]songList];
    NSMutableArray *currentDiskList = [[[[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex] albumList]objectAtIndex:selectedAlbumIndex]diskList];
    
    // special albums or playlists
    if (albumMeth == true || playlistMeth == true){
        RSSParser *parser = [[RSSParser alloc] initWithRSSFeed: userURL];
        albumList = parser.albumList;
        songList  = parser.songList;
        if ([songList count] > 0){
            songs = true;
            songCount = 0;
            self.title = [[songList objectAtIndex:0] albumName];
        }
        else {
            songs = false;
        }    
        if ([albumList count] > 0) {
            albums = true;
            albumCount = [albumList count];
            //self.title = [[albumList objectAtIndex:0] artistName];
            
            if (firstTimeAlbum == false){
                multiDisk = true;
            }
            else {
                firstTimeAlbum = false;
            }
        }
        else {
            albums = false;
        }

    }
    
    // something is in the album list and this is the first time
    else if (currentAlbumList != nil && firstTimeAlbum){
        firstTimeAlbum = false;
        albumList = [[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex] albumList];
        albums = true;
    }
    
    // something is in the song list and it's only 1 disk
    else if (currentSongList != nil && !multiDisk){
        songList = [[[[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex] albumList]objectAtIndex:selectedAlbumIndex] songList];
        songs = true;
    }
    
    // something is in the disk list and it's multidisk
    else if (currentDiskList != nil && multiDisk){
        multiDisk = false;
        albumList = [[[[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex] albumList]objectAtIndex:selectedAlbumIndex]diskList];
    }
    
    // every other case
    else{
        RSSParser *parser = [[RSSParser alloc] initWithRSSFeed: userURL];
        albumList = parser.albumList;
        songList  = parser.songList;
        if ([songList count] > 0){
            songs = true;
            songCount = 0;
            self.title = [[songList objectAtIndex:0] albumName];
            [[[[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex] albumList] objectAtIndex:selectedAlbumIndex] setSongList:songList];
            [self saveSettings];
        }
        else {
            songs = false;
        }    
        if ([albumList count] > 0) {
            albums = true;
            albumCount = [albumList count];
            self.title = [[albumList objectAtIndex:0] artistName];
            
            if (firstTimeAlbum == false){
                multiDisk = true;
                [[[[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex]albumList]objectAtIndex:selectedAlbumIndex] setDiskList:albumList];
            }
            else {
                firstTimeAlbum = false;
                [[[artistList objectAtIndex:selectedArtistSection] objectAtIndex:selectedArtistIndex] setAlbumList:albumList];
            }
            
            [self saveSettings];
        }
        else {
            albums = false;
        }
    }
        
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    if ( [avPlayer currentItem] == nil )
        self.navigationItem.rightBarButtonItem = nil;
    else {
        // custom now playing button
        UIButton *nowplaying = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 61, 31)];
        [nowplaying setImage:[UIImage imageNamed:@"nowplaying.png"] forState:UIControlStateNormal];
        [nowplaying addTarget:self action:@selector(pushToPlayer) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nowplaying];
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
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
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
        if (!playlistMeth && !albumMeth)
            selectedAlbumIndex = [self.tableView indexPathForSelectedRow].row;
    }
    else if ([[segue identifier] isEqualToString:@"SelectedSong"]) {
        art = nil;
        currentIndex = [self.tableView indexPathForSelectedRow].row;
        differentAlbum = true;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    activityIndicator.center = self.view.center;
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
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
        if (albumCount > 0){
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
                NSString *URL = [NSString stringWithFormat:@"%@&id=%@", [AppDelegate getEndpoint:@"getCoverArt"], [[albumList objectAtIndex: indexPath.row] coverArt]];
                NSURL *imageURL = [NSURL URLWithString: URL];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:imageData]; 
                cell.imageView.image = image;
            }
            albumCount--;
            return cell;
        }
        else {
            static NSString *CellIdentifier = @"Songs";
            
            UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell2 == nil) {
                cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            // Configure the cell...
            cell2.textLabel.text = [NSString stringWithFormat:@"%@", [[songList objectAtIndex: songCount] songName] ];
            songCount++;
            return cell2;
        }
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
            NSString *URL = [NSString stringWithFormat:@"%@&id=%@", [AppDelegate getEndpoint:@"getCoverArt"], [[albumList objectAtIndex: indexPath.row] coverArt]];
            NSURL *imageURL = [NSURL URLWithString: URL];
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

-(void)saveSettings{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self setArtistListProperty:artistList];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:artistListProperty];
	[prefs setObject:data  forKey:@"local-artistList"];
    [prefs synchronize];
}

@end
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
#import "AlbumSongTableViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "NowPlaying.h"

@implementation ArtistTableViewController
@synthesize artistSearchDisplayController = _artistSearchDisplayController;
@synthesize artistSearchBar = _artistSearchBar;
@synthesize itemsFromCurrentSearch;

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
    [super viewDidLoad];
    
    itemsFromCurrentSearch = [NSMutableArray array];
    
    [self.tableView reloadData];
    NSIndexPath *scrollToPath = [NSIndexPath indexPathForRow:0 inSection:0]; 
    [self.tableView scrollToRowAtIndexPath:scrollToPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)viewDidUnload
{
    //Initializing SearchBar components
    //[self setArtistSearchBar:nil];
    //artistSearchBar = nil;
    //artistSearchDisplayController = nil;
    //[self setArtistSearchDisplayController:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.parentViewController.title = @"Artists";
    
    if ( [avPlayer currentItem] == nil )
        self.parentViewController.navigationItem.rightBarButtonItem = nil;
    else {
        // custom now playing button
        UIButton *nowplaying = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 61, 31)];
        [nowplaying setImage:[UIImage imageNamed:@"nowplaying.png"] forState:UIControlStateNormal];
        [nowplaying addTarget:self action:@selector(pushToPlayer) forControlEvents:UIControlEventTouchUpInside];
        self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nowplaying];
    }
    
    self.parentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
}

- (void) refresh {
    [AppDelegate updateArtists];
    [self.tableView reloadData];
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
    //Normal Segue
    if ([[segue identifier] isEqualToString:@"AlbumClick"]) {
        AlbumSongTableViewController *nextViewController = [segue destinationViewController];
        
        NSString *directoryID = [[[artistList objectAtIndex:[self.tableView indexPathForSelectedRow].section]objectAtIndex:[self.tableView indexPathForSelectedRow].row ] artistID];
        selectedArtistSection = [self.tableView indexPathForSelectedRow].section;
        selectedArtistIndex = [self.tableView indexPathForSelectedRow].row;
        nextViewController.userURL = [NSString stringWithFormat:@"%@&id=%@", [AppDelegate getEndpoint:@"getMusicDirectory"], directoryID];
        
    }
    //Segue from Search results
    else {
        AlbumSongTableViewController *nextViewController = [segue destinationViewController];
        
        NSString *directoryID = [[self.itemsFromCurrentSearch objectAtIndex:[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row ] artistID];
        nextViewController.userURL = [NSString stringWithFormat:@"%@&id=%@", [AppDelegate getEndpoint:@"getMusicDirectory"], directoryID];
        
        //Leave search Land!
        [self.searchDisplayController setActive:NO];
    }
    
    firstTimeAlbum = true;
    multiDisk = false;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self performSegueWithIdentifier:@"FromSearch" sender:self];
    }
    
    // How to get segue destination controller and set object?!
    // Before doing:
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if([tableView isEqual:self.artistSearchDisplayController.searchResultsTableView]){
        
        //Search will always have 1 section
        return 1;
    }else{
        
        return [artistList count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Number of rows if in search table view
    if ([tableView 
         isEqual:self.artistSearchDisplayController.searchResultsTableView]){
        return [self.itemsFromCurrentSearch count];
    
    }else{
        
        return [[artistList objectAtIndex:section] count];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObject:@"A"];
    [temp addObject:@"B"];
    [temp addObject:@"C"];
    [temp addObject:@"D"];
    [temp addObject:@"E"];
    [temp addObject:@"F"];
    [temp addObject:@"G"];
    [temp addObject:@"H"];
    [temp addObject:@"I"];
    [temp addObject:@"J"];
    [temp addObject:@"K"];
    [temp addObject:@"L"];
    [temp addObject:@"M"];
    [temp addObject:@"N"];
    [temp addObject:@"O"];
    [temp addObject:@"P"];
    [temp addObject:@"Q"];
    [temp addObject:@"R"];
    [temp addObject:@"S"];
    [temp addObject:@"T"];
    [temp addObject:@"U"];
    [temp addObject:@"V"];
    [temp addObject:@"W"];
    [temp addObject:@"X-Z"];
    [temp addObject:@"#"];
    return temp;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObject:@"A"];
    [temp addObject:@"B"];
    [temp addObject:@"C"];
    [temp addObject:@"D"];
    [temp addObject:@"E"];
    [temp addObject:@"F"];
    [temp addObject:@"G"];
    [temp addObject:@"H"];
    [temp addObject:@"I"];
    [temp addObject:@"J"];
    [temp addObject:@"K"];
    [temp addObject:@"L"];
    [temp addObject:@"M"];
    [temp addObject:@"N"];
    [temp addObject:@"O"];
    [temp addObject:@"P"];
    [temp addObject:@"Q"];
    [temp addObject:@"R"];
    [temp addObject:@"S"];
    [temp addObject:@"T"];
    [temp addObject:@"U"];
    [temp addObject:@"V"];
    [temp addObject:@"W"];
    [temp addObject:@"X-Z"];
    [temp addObject:@"#"];
    return [temp indexOfObject:title];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    switch (section) {
        case 0: return @"A";
            break;
        case 1: return @"B";
            break;
        case 2: return @"C";
            break;
        case 3: return @"D";
            break;
        case 4: return @"E";
            break;
        case 5: return @"F";
            break;
        case 6: return @"G";
            break;
        case 7: return @"H";
            break;
        case 8: return @"I";
            break;
        case 9: return @"J";
            break;
        case 10: return @"K";
            break;
        case 11: return @"L";
            break;
        case 12: return @"M";
            break;
        case 13: return @"N";
            break;
        case 14: return @"O";
            break;
        case 15: return @"P";
            break;
        case 16: return @"Q";
            break;
        case 17: return @"R";
            break;
        case 18: return @"S";
            break;
        case 19: return @"T";
            break;
        case 20: return @"U";
            break;
        case 21: return @"V";
            break;
        case 22: return @"W";
            break;
        case 23: return @"X-Z";
            break;
        case 24: return @"#";
            break;
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Following conditional returns cell depending on which table is 
    //being populated
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        cell.textLabel.text =[NSString stringWithFormat:@"%@", [[self.itemsFromCurrentSearch objectAtIndex:indexPath.row] artistName]];
    
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[[artistList objectAtIndex: indexPath.section]objectAtIndex:indexPath.row] artistName] ];
        
    }
    // Configure the cell...
    
    return cell;
}

//Callback function made when the searchbar text changes
//This can be implemented 2 ways
//1. Search through the values we already have (done currently)
//2. Hit the server
- (void)filterContentForSearchText:(NSString*)searchText 
                             scope:(NSString*)scope
{
    
    if(![searchText isEqualToString:@""]){
        UniChar alph = [[searchText lowercaseString] characterAtIndex:0];
        NSInteger arrIndex = -1;
        
        if(alph == 'a'){
            arrIndex = 0;
        
        }else if (alph == 'b') {
            arrIndex = 1;
        
        }else if (alph == 'c') {
            arrIndex = 2;
        
        }else if (alph == 'd') {
            arrIndex = 3;
            
        }else if (alph == 'e') {
            arrIndex = 4;
            
        }else if (alph == 'f') {
            arrIndex = 5;
            
        }else if (alph == 'g') {
            arrIndex = 6;
            
        }else if (alph == 'h') {
            arrIndex = 7;
            
        }else if (alph == 'i') {
            arrIndex = 8;
            
        }else if (alph == 'j') {
            arrIndex = 9;
            
        }else if (alph == 'k') {
            arrIndex = 10;
            
        }else if (alph == 'l') {
            arrIndex = 11;
            
        }else if (alph == 'm') {
            arrIndex = 12;
            
        }else if (alph == 'n') {
            arrIndex = 13;
            
        }else if (alph == 'o') {
            arrIndex = 14;
            
        }else if (alph == 'p') {
            arrIndex = 15;
            
        }else if (alph == 'q') {
            arrIndex = 16;
            
        }else if (alph == 'r') {
            arrIndex = 17;
            
        }else if (alph == 's') {
            arrIndex = 18;
            
        }else if (alph == 't') {
            arrIndex = 19;
            
        }else if (alph == 'u') {
            arrIndex = 20;
            
        }else if (alph == 'v') {
            arrIndex = 21;
            
        }else if (alph == 'w') {
            arrIndex = 22;
            
        }else if((alph == 'x') || (alph == 'y') || (alph == 'z')){
            arrIndex = 23;
        } else {
            arrIndex = 24;
        }

        //Continuously sort tableview results, results placed in 'itemsFromCurrentSearch'
        NSInteger i = 0;
        NSMutableArray *temp;
        NSString *temp1;
        
        self.itemsFromCurrentSearch = [NSMutableArray array];
        
        if(arrIndex != -1){
            temp = [[NSMutableArray alloc] initWithArray:[artistList objectAtIndex:arrIndex]];

            for(i = 0; i < [[artistList objectAtIndex:arrIndex] count]; i++){
                temp1 = [[[temp objectAtIndex:i] artistName] lowercaseString];
                NSRange range = [temp1 rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (range.location != NSNotFound){
                    [self.itemsFromCurrentSearch addObject:[temp objectAtIndex:i]];
                    
                }
            }
        }
    }
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString 
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
@end

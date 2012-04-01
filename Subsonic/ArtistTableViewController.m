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
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height) arrowImageName:@"grayArrow.png" textColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0] ];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
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
    
    self.parentViewController.title = @"Artists";
    
    [self.tableView reloadData];
    NSIndexPath *scrollToPath = [NSIndexPath indexPathForRow:0 inSection:0]; 
    [self.tableView scrollToRowAtIndexPath:scrollToPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    if ( [avPlayer currentItem] == nil )
        self.parentViewController.navigationItem.rightBarButtonItem = nil;
    else {
        UIBarButtonItem *nowPlaying = [[UIBarButtonItem alloc] initWithTitle:@"Now Playing" style:UIBarButtonItemStylePlain target:self action: @selector(pushToPlayer)];
        self.parentViewController.navigationItem.rightBarButtonItem = nowPlaying;
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
    if ([[segue identifier] isEqualToString:@"AlbumClick"]) {
        NSString *artistID = [[[artistList objectAtIndex:[self.tableView indexPathForSelectedRow].section]objectAtIndex:[self.tableView indexPathForSelectedRow].row ] artistID];
        NSString *userURL = [NSString stringWithFormat:@"%@&id=%@", [AppDelegate getEndpoint:@"getMusicDirectory"], artistID];
        AlbumSongTableViewController *nextViewController = [segue destinationViewController];
        nextViewController.parser = [[RSSParser alloc] initWithRSSFeed: userURL];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [artistList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[artistList objectAtIndex:section] count];
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[[artistList objectAtIndex: indexPath.section]objectAtIndex:indexPath.row] artistName] ];
    // Configure the cell...
    
    return cell;
}

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [AppDelegate updateArtists];
    
	_reloading = YES;
    
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
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

@end

//
//  FirstViewController.m
//  Subsonic
//
//  Created by Josh Betz on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "RSSParser.h"
#import "Artist.h"

@implementation FirstViewController
@synthesize testLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *userURL = @"http://wilmothighschool.com:4040/rest/getIndexes.view?u=mobileappdev&p=mobile123&v=1.1.0&c=myapp";
    RSSParser *rssParser = [[RSSParser alloc] initWithRSSFeed: userURL];
    NSMutableArray *artistList = rssParser.artistList;
    userURL = @"http://wilmothighschool.com:4040/rest/getMusicDirectory.view?u=mobileappdev&p=mobile123&v=1.1.0&c=myapp&id=";
    userURL = [userURL stringByAppendingString:[[artistList objectAtIndex:0] artistID]];
    NSLog([[artistList objectAtIndex:0] artistName]);
    NSLog(userURL);
    rssParser = [[RSSParser alloc] initWithRSSFeed: userURL];
    NSLog([[artistList objectAtIndex:0] artistID]);
    [[[artistList objectAtIndex:0] albumList] addObjectsFromArray:rssParser.albumList];
    NSLog([[[[artistList objectAtIndex:0] albumList] objectAtIndex:1] albumID]);
    //testLabel.text = [[[rssParser articleList] objectAtIndex: 0] message];
	// Do any additional setup after loading the view, typically from a nib.
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

//
//  SecondViewController.m
//  Subsonic
//
//  Created by Josh Betz on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "APITestViewController.h"

@implementation SecondViewController
@synthesize submitButton;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"submitAPI"]) {
        APITestViewController *nextViewController = [segue destinationViewController];
        nextViewController.username = @"mobileappdev";
        nextViewController.password = @"mobile123";
        nextViewController.apiURL = @"http://wilmothighschool.com:4040/rest/getIndexes.view?u=mobileappdev&p=mobile123&v=1.1.0&c=Subsonic";
        NSURL *url = [NSURL URLWithString:@"http://wilmothighschool.com:4040/rest/getIndexes.view?u=mobileappdev&p=mobile123&v=1.1.0&c=Subsonic/rest/getLicense.view"];
        //NSXMLParser 
        //nextViewController.testLabel.text 
    }
}

@end

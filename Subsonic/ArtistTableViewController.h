//
//  ArtistTableViewController.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistTableViewController: UITableViewController
{
    IBOutlet UISearchDisplayController *artistSearchDisplayController;
    IBOutlet UISearchBar *artistSearchBar;
    NSMutableArray *itemsFromCurrentSearch;
}
@property (strong, nonatomic) IBOutlet UISearchDisplayController *artistSearchDisplayController;
@property (strong, nonatomic) IBOutlet UISearchBar *artistSearchBar;
@property (strong, nonatomic) NSMutableArray *itemsFromCurrentSearch;

@end

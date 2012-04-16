//
//  ArtistTableViewController.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface ArtistTableViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UISearchDisplayController *artistSearchDisplayController;
    IBOutlet UISearchBar *artistSearchBar;
    NSMutableArray *itemsFromCurrentSearch;
	
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
}
@property (strong, nonatomic) IBOutlet UISearchDisplayController *artistSearchDisplayController;
@property (strong, nonatomic) IBOutlet UISearchBar *artistSearchBar;
@property (strong, nonatomic) NSMutableArray *itemsFromCurrentSearch;


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end

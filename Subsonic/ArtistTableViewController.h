//
//  ArtistTableViewController.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistTableViewController : UITableViewController{
    UIActivityIndicatorView * activityIndicator;
}
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

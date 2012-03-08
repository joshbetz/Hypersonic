//
//  ArtistTableViewController.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistTableViewController : UITableViewController{
    NSMutableArray *artistList;
}
@property (nonatomic, strong) NSMutableArray *artistList;
@end

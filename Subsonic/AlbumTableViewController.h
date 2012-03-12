//
//  AlbumTableViewController.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSParser.h"

@interface AlbumTableViewController : UITableViewController {
    RSSParser *parser;
    NSMutableArray *albumList;
}
@property (strong, nonatomic) RSSParser *parser;
@property (strong, nonatomic) NSMutableArray *albumList;
@end

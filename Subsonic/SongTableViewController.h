//
//  SongTableViewController.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSParser.h"

@interface SongTableViewController : UITableViewController{
    RSSParser *parser;
    NSMutableArray *songList;
}
@property (strong, nonatomic) RSSParser *parser;
@property (strong, nonatomic) NSMutableArray *songList;
@end

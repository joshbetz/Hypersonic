//
//  AlbumSongTableViewController.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSParser.h"

@interface AlbumSongTableViewController : UITableViewController{
    NSMutableArray *albumList;
    RSSParser *parser;
    BOOL songs;
    BOOL albums;
    NSString *userName;
    NSString *serverURL;
    NSString *userPassword;
}
@property (nonatomic, strong) NSMutableArray *albumList;
@property (strong, nonatomic) RSSParser *parser;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSString *serverURL;
@end

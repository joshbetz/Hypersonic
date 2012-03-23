//
//  PlaylistTableViewController.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Playlist.h"

@interface PlaylistTableViewController : UITableViewController{
    NSMutableArray *playlistList;
    NSString *serverURL;
    NSString *userName;
    NSString *userPassword;
}
@property (nonatomic, strong) NSMutableArray *playlistList;
@property (strong, nonatomic) NSString *serverURL;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPassword;
@end

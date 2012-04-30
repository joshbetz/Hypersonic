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
    NSString *userURL;
    BOOL songs;
    BOOL albums;
    NSString *userName;
    NSString *serverURL;
    NSString *userPassword;
    NSMutableArray *artistListProperty;
    int albumCount;
    int songCount;
    UIActivityIndicatorView * activityIndicator;
}

@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSMutableArray *albumList;
@property (strong, nonatomic) NSString *userURL;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSString *serverURL;
@property (nonatomic, strong) NSMutableArray *artistListProperty;

-(void)saveSettings;
@end

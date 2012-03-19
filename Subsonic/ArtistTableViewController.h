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
    NSString *serverURL;
    NSString *userName;
    NSString *userPassword;
}
@property (nonatomic, strong) NSMutableArray *artistList;
@property (strong, nonatomic) NSString *serverURL;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPassword;
@end

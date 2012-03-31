//
//  Settings.h
//  Subsonic
//
//  Created by Josh Betz on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UITableViewController
{
    IBOutlet UITextField *serverLabel;
    IBOutlet UITextField *loginLabel;
    IBOutlet UITextField *localServerLabel;
    IBOutlet UITextField *passwordLabel;
    
    NSString *server;
    NSString *login;
    NSString *localServer;
    NSString *password;
}

@property (strong, nonatomic) IBOutlet UITextField *serverLabel;
@property (strong, nonatomic) IBOutlet UITextField *loginLabel;
@property (strong, nonatomic) IBOutlet UITextField *localServerLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordLabel;

@property (strong, nonatomic) NSString *server;
@property (strong, nonatomic) NSString *login;
@property (strong, nonatomic) NSString *localServer;
@property (strong, nonatomic) NSString *password;

@end

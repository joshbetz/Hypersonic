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
    IBOutlet UISwitch *localModeSwitch;
    IBOutlet UISwitch *hqModeSwitch;
    IBOutlet UISwitch *iCloudModeSwitch;
}

@property (strong, nonatomic) IBOutlet UITextField *serverLabel;
@property (strong, nonatomic) IBOutlet UITextField *loginLabel;
@property (strong, nonatomic) IBOutlet UITextField *localServerLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordLabel;
@property (strong, nonatomic) IBOutlet UISwitch *localModeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *hqModeSwitch;

-(NSString *)makeURL:(NSString *)method: (NSString *)serverName: (NSString *)login: (NSString *)passwordUser;
@end

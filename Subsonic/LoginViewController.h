//
//  LoginViewController.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UITableViewController
{
    UIButton *loginButton;
    UITextField *server;
    UITextField *name;
    UITextField *password;
    NSString *serverURL;
    NSString *userName;
    NSString *userPassword;
    NSMutableArray *artistList;
}

@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UITextField *server;
@property (nonatomic, strong) IBOutlet UITextField *name;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (strong, nonatomic) NSString *serverURL;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSMutableArray *artistList;
-(void)saveSettings;
-(IBAction)login:(id)loginButton;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
@end

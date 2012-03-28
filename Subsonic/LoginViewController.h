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
    UITextField *serverText;
    UITextField *nameText;
    UITextField *passwordText;
    NSString *serverURL;
    NSString *userName;
    NSString *userPassword;
    NSMutableArray *artistListProperty;
}

@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UITextField *serverText;
@property (nonatomic, strong) IBOutlet UITextField *nameText;
@property (nonatomic, strong) IBOutlet UITextField *passwordText;
@property (nonatomic, strong) NSString *serverURL;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, strong) NSMutableArray *artistListProperty; 
-(void)saveSettings;
-(IBAction)login:(id)loginButton;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
@end

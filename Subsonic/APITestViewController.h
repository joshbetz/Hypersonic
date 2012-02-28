//
//  APITestViewController.h
//  Subsonic
//
//  Created by Erin Rasmussen on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APITestViewController : UIViewController {
    UILabel *testLabel;
}
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *apiURL;
@property (nonatomic, retain) IBOutlet UILabel *testLabel;

@end

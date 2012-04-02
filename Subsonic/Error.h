//
//  Error.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Error : NSObject{
	NSString *message;
    NSString *code;
}

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *code;

@end


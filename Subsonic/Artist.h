//
//  Artist.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artist : NSObject<NSCoding>{
    NSString *artistName;
    NSString *artistID;
    NSMutableArray *albumList;
}

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *artistID;
@property (nonatomic, strong) NSMutableArray *albumList;

-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;
@end

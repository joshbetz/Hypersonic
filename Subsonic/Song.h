//
//  Song.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject{
    NSString *songName;
    NSString *songID;
    NSString *artistName;
    NSString *albumName;
}


@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *songID;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSString *artistName;
@end

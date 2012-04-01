//
//  Album.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject {
    NSString *albumName;
    NSString *albumID;
    NSString *artistName;
    NSString *parentID;
    NSString *coverArt;
    NSMutableArray *songList;
}

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *albumID;
@property (nonatomic, strong) NSMutableArray *songList;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSString *parentID;
@property (nonatomic, strong) NSString *coverArt;
@end

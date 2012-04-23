//
//  Song.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVPlayerItem.h>

@interface Song : NSObject <NSCoding>{
    NSString *songName;
    NSString *songID;
    NSString *artistName;
    NSString *albumName;
    NSString *albumArg;
    NSString *songDuration;
    AVPlayerItem *songData;
}


@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *songID;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *albumArt;
@property (nonatomic, strong) NSString *songDuration;
@property (nonatomic, strong) AVPlayerItem *songData;

-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;
- (id)copyWithZone:(NSZone *)zone;
@end

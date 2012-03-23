//
//  Playlist.h
//  Subsonic
//
//  Created by Erin Rasmussen on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Playlist : NSObject{
    NSString *playlistID;
    NSString *playlistName;
}
@property(nonatomic, strong) NSString *playlistID;
@property(nonatomic, strong) NSString *playlistName;

@end

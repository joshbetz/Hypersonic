//
//  Album.m
//  Subsonic
//
//  Created by Erin Rasmussen on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Album.h"

@implementation Album
@synthesize artistName, albumID, albumName, songList, parentID, coverArt, diskList;
-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:albumID forKey:@"albumID"];
    [encoder encodeObject:artistName forKey:@"albumArtistName"];
    [encoder encodeObject:songList forKey:@"songList"];
    [encoder encodeObject:parentID forKey:@"parentID"];
    [encoder encodeObject:albumName forKey:@"albumName"];
    [encoder encodeObject:coverArt forKey:@"coverArt"];
    [encoder encodeObject:diskList forKey:@"diskList"];
}

-(id)initWithCoder:(NSCoder *)decoder{
    self.albumID = [decoder decodeObjectForKey:@"albumID"];
    self.artistName = [decoder decodeObjectForKey:@"albumArtistName"];
    self.songList = [decoder decodeObjectForKey:@"songList"];
    self.albumName = [decoder decodeObjectForKey:@"albumName"];
    self.parentID = [decoder decodeObjectForKey:@"parentID"];
    self.coverArt = [decoder decodeObjectForKey:@"coverArt"];
    self.diskList = [decoder decodeObjectForKey:@"diskList"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setArtistName:[self.artistName copyWithZone:zone]];
        [copy setAlbumID:[self.albumID copyWithZone:zone]];
        [copy setSongList:[self.songList copyWithZone:zone]];
        [copy setAlbumName:[self.albumName copyWithZone:zone]];
        [copy setCoverArt:[self.coverArt copyWithZone:zone]];
        [copy setParentID:[self.parentID copyWithZone:zone]];
        [copy setDiskList:[self.diskList copyWithZone:zone]];
    }
    
    return copy;
    
}
@end

//
//  Song.m
//  Subsonic
//
//  Created by Erin Rasmussen on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Song.h"
#import <AVFoundation/AVPlayerItem.h>

@implementation Song 
@synthesize songID, songName, artistName, albumName, albumArt, songDuration, songData;
-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:songID forKey:@"songID"];
    [encoder encodeObject:artistName forKey:@"songArtistName"];
    [encoder encodeObject:albumName forKey:@"songAlbumName"];
    [encoder encodeObject:albumArt forKey:@"songAlbumArt"];
    [encoder encodeObject:songName forKey:@"songName"];
    [encoder encodeObject:songName forKey:@"songDuration"];
    [encoder encodeObject:songData forKey:@"songData"];
}

-(id)initWithCoder:(NSCoder *)decoder{
    self.songID = [decoder decodeObjectForKey:@"songID"];
    self.artistName = [decoder decodeObjectForKey:@"songArtistName"];
    self.albumName = [decoder decodeObjectForKey:@"songAlbumName"];
    self.albumArt = [decoder decodeObjectForKey:@"songAlbumArt"];
    self.songName = [decoder decodeObjectForKey:@"songName"];
    self.songDuration = [decoder decodeObjectForKey:@"songDuration"];
    self.songData = [decoder decodeObjectForKey:@"songData"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setArtistName:[self.artistName copyWithZone:zone]];
        [copy setSongID:[self.songID copyWithZone:zone]];
        [copy setSongName:[self.songName copyWithZone:zone]];
        [copy setAlbumName:[self.albumName copyWithZone:zone]];
        [copy setAlbumArt:[self.albumArt copyWithZone:zone]];
        [copy setSongDuration:[self.songDuration copyWithZone:zone]];
        [copy setSongData:[self.songData copyWithZone:zone]];
    }
    
    return copy;
    
}
@end

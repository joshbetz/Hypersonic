//
//  Artist.m
//  Subsonic
//
//  Created by Erin Rasmussen on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Artist.h"

@implementation Artist
@synthesize artistID, artistName, albumList;

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:artistID forKey:@"artistID"];
    [encoder encodeObject:artistName forKey:@"artistName"];
    [encoder encodeObject:albumList forKey:@"albumList"];
}

-(id)initWithCoder:(NSCoder *)decoder{
    self.artistID = [decoder decodeObjectForKey:@"artistID"];
    self.artistName = [decoder decodeObjectForKey:@"artistName"];
    self.albumList = [decoder decodeObjectForKey:@"albumList"];
    return self;
}
@end

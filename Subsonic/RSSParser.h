//
//  RSSParser.h
//  Project1Solution
//
//  Created by Michael Griepentrog on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Error.h"
#import "Artist.h"
#import "Album.h"

@interface RSSParser : NSObject <NSXMLParserDelegate> {
@public
	NSMutableArray *articleList;
    NSMutableArray *artistList;
    NSMutableArray *albumList;
@private
	NSString *rssURL;
	NSMutableString *currentData;
    Error *currentError;
    Artist *currentArtist;
    Album *currentAlbum;
	BOOL accumulatingParsedCharacterData;
	BOOL inItemTag;
    BOOL isDir;
}

-(RSSParser*) initWithRSSFeed: (NSString *)anRSSFeed;

@property (nonatomic, strong) NSMutableArray *articleList;
@property (nonatomic, strong) NSString *rssURL;
@property (nonatomic, strong) NSMutableString *currentData;
@property (nonatomic, strong) Error *currentError;
@property (nonatomic, strong) Artist *currentArtist;
@property (nonatomic, strong) Album *currentAlbum;
@property (nonatomic, strong) NSMutableArray *artistList;
@property (nonatomic, strong) NSMutableArray *albumList;

@end
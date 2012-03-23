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
#import "Song.h"
#import "Playlist.h"

@interface RSSParser : NSObject <NSXMLParserDelegate> {
@public
	NSMutableArray *articleList;
    NSMutableArray *artistList;
    NSMutableArray *albumList;
    NSMutableArray *songList;
    NSMutableArray *playlistList;
@private
	NSString *rssURL;
	NSMutableString *currentData;
    Error *currentError;
    Artist *currentArtist;
    Album *currentAlbum;
    Song *currentSong;
    Playlist *currentPlaylist;
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
@property (nonatomic, strong) Song *currentSong;
@property (nonatomic, strong) Playlist *currentPlaylist;
@property (nonatomic, strong) NSMutableArray *artistList;
@property (nonatomic, strong) NSMutableArray *albumList;
@property (nonatomic, strong) NSMutableArray *songList;
@property (nonatomic, strong) NSMutableArray *playlistList;
@end
//
//  RSSParser.m
//  Project1Solution
//
//  Created by Michael Griepentrog on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSSParser.h"
#import "Artist.h"
#import "Song.h"

@implementation RSSParser

@synthesize articleList, rssURL, currentData, currentError, artistList, currentArtist, currentAlbum, albumList, songList, currentSong;

-(RSSParser*) initWithRSSFeed: (NSString *)anRSSFeed {
    self = [super init];
	
    if ( self ) {
        self.rssURL = anRSSFeed;
		self.articleList = [NSMutableArray array];
        self.albumList = [NSMutableArray array];
        self.artistList = [NSMutableArray array];
        self.songList = [NSMutableArray array];
		NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:anRSSFeed]];
		
		if(data != nil)
		{
			self.currentData = [NSMutableString string];
			//
			// It's also possible to have NSXMLParser download the data by passing it a URL, but this is not desirable
			// because it gives less control over the network, particularly in responding to connection errors.
			//
			NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
			[parser setDelegate:self];
			[parser parse];
		}
		else 
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
																message:@"Unable to download RSS feed. Please check your network connection" 
															   delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close",nil];
			[alertView show];
			return nil;
		}
        
    }
    return self;
}

// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kEntryElementName = @"subsonic-response";
static NSString * const kLinkElementName = @"error";
static NSString * const kArtistElement = @"artist";
static NSString * const kAlbumOrSongElement = @"child";
static NSString * const kAlbumAccess = @"album";

#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    isDir = false;
    if ([elementName isEqualToString:kEntryElementName]) {
        Error *error = [[Error alloc] init];
        self.currentError = error;
		inItemTag = YES;
    } else if ([elementName isEqualToString:kLinkElementName]) {
		[currentData setString:[attributeDict objectForKey:@"message"]];
        //self.currentError.message = [self.currentData copy];
        /*if (inItemTag) {
         accumulatingParsedCharacterData = YES;
         // The mutable string needs to be reset to empty.
         [currentData setString:@""];
         }*/
    } else if ([elementName isEqualToString:kArtistElement]) {
		Artist *artist = [[Artist alloc] init];
        currentArtist = artist;
        [currentData setString:[attributeDict objectForKey:@"name"]];
        self.currentArtist.artistName = [self.currentData copy];
        [currentData setString:[attributeDict objectForKey:@"id"]];
        self.currentArtist.artistID = [self.currentData copy];
    } else if ([elementName isEqualToString:kAlbumOrSongElement] && [[attributeDict objectForKey:@"isDir"] isEqualToString:@"true"]) {
		Album *album = [[Album alloc] init];
        currentAlbum = album;
        isDir = true;
        [currentData setString:[attributeDict objectForKey:@"title"]];
        self.currentAlbum.albumName = [self.currentData copy];
        [currentData setString:[attributeDict objectForKey:@"id"]];
        self.currentAlbum.albumID = [self.currentData copy];
        if ([attributeDict objectForKey:@"artist"] != nil) {
        [currentData setString:[attributeDict objectForKey:@"artist"]];
        self.currentAlbum.artistName = [self.currentData copy];
        }
        [currentData setString:[attributeDict objectForKey:@"parent"]];
        self.currentAlbum.parentID = [self.currentData copy];
    }
    else if ([elementName isEqualToString:kAlbumOrSongElement] && [[attributeDict objectForKey:@"isDir"] isEqualToString:@"false"]) {
		Song *song = [[Song alloc] init];
        currentSong = song;
        isDir = false;
        [currentData setString:[attributeDict objectForKey:@"title"]];
        self.currentSong.songName = [self.currentData copy];
        [currentData setString:[attributeDict objectForKey:@"id"]];
        self.currentSong.songID = [self.currentData copy];
        [currentData setString:[attributeDict objectForKey:@"artist"]];
        self.currentSong.artistName = [self.currentData copy];
        [currentData setString:[attributeDict objectForKey:@"album"]];
        self.currentSong.albumName = [self.currentData copy];
    }
    else if ([elementName isEqualToString:kAlbumAccess]) {
		Album *album = [[Album alloc] init];
        currentAlbum = album;
        isDir = true;
        [currentData setString:[attributeDict objectForKey:@"title"]];
        self.currentAlbum.albumName = [self.currentData copy];
        [currentData setString:[attributeDict objectForKey:@"id"]];
        self.currentAlbum.albumID = [self.currentData copy];
        if ([attributeDict objectForKey:@"artist"] != nil) {
            [currentData setString:[attributeDict objectForKey:@"artist"]];
            self.currentAlbum.artistName = [self.currentData copy];
        }
        [currentData setString:[attributeDict objectForKey:@"parent"]];
        self.currentAlbum.parentID = [self.currentData copy];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {     
    if ([elementName isEqualToString:kEntryElementName]) {
        [self.articleList addObject:self.currentError];
		inItemTag = NO;
    } else if ([elementName isEqualToString:kLinkElementName]) {
        self.currentError.message = [self.currentData copy];
    } else if ([elementName isEqualToString:kArtistElement]) {
        [self.artistList addObject:self.currentArtist];
    } else if ([elementName isEqualToString:kAlbumOrSongElement] && isDir == true) {
        [self.albumList addObject:self.currentAlbum];
        isDir = false;
    } else if ([elementName isEqualToString:kAlbumOrSongElement] && isDir == false) {
        [self.songList addObject:self.currentSong];
    } else if ([elementName isEqualToString:kAlbumAccess]) {
        [self.albumList addObject:self.currentAlbum];
        isDir = false;
    }

    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"Parse error occurred: %@", [parseError localizedDescription]);
	self.articleList = nil;
}

// This method is called by the parser when it find parsed character data ("PCDATA") in an element. The parser is not
// guaranteed to deliver all of the parsed character data for an element in a single invocation, so it is necessary to
// accumulate character data until the end of the element is reached.
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [self.currentData appendString:string];
    }
}


@end

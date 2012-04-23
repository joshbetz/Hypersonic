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
#import "Playlist.h"
#import "AppDelegate.h"

@implementation RSSParser

@synthesize errorList, rssURL, currentData, currentError, artistList, currentArtist, currentAlbum, albumList, songList, currentSong, playlistList, currentPlaylist, currentLetter;

-(RSSParser*) initWithRSSFeed: (NSString *)anRSSFeed {
    self = [super init];
	
    if ( self ) {
        self.rssURL = anRSSFeed;
		self.errorList = [NSMutableArray array];
        self.albumList = [NSMutableArray array];
        self.artistList = [NSMutableArray array];
        for (int i = 0; i < 25; i++){       //X-Z is one and # is also one
            [artistList addObject:[NSMutableArray array]];
        }
        self.songList = [NSMutableArray array];
        self.playlistList = [NSMutableArray array];
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
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to find server. Please check your network connection and/or server URL" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close",nil];
            connectionProblem = true;
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
static NSString * const kPlaylist = @"playlist";
static NSString * const kPlaylistEntry = @"entry";
static NSString * const kLetter = @"index";
#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    isDir = false;
    if ([elementName isEqualToString:kEntryElementName]) {
        
    } 
    else if ([elementName isEqualToString:kLetter]) {
        NSString *letter = [attributeDict objectForKey:@"name"];
        currentLetter = letter;
		inItemTag = YES;
    }
    else if ([elementName isEqualToString:kLinkElementName]) {
		Error *error = [[Error alloc] init];
        currentError = error;
        [currentData setString:[attributeDict objectForKey:@"message"]];
        self.currentError.message = [self.currentData copy];
        [currentData setString:[attributeDict objectForKey:@"code"]];
        self.currentError.code = [self.currentData copy];
       
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
        if ([attributeDict objectForKey:@"coverArt"] != nil){
            [currentData setString:[attributeDict objectForKey:@"coverArt"]];
            self.currentAlbum.coverArt = [self.currentData copy];
        }
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
        [currentData setString:[attributeDict objectForKey:@"duration"]];
        self.currentSong.songDuration = [self.currentData copy];
        if ([attributeDict objectForKey:@"coverArt"] != nil){
            [currentData setString:[attributeDict objectForKey:@"coverArt"]];
            self.currentSong.albumArt = [self.currentData copy];
        }
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
        if ([attributeDict objectForKey:@"coverArt"] != nil){
            [currentData setString:[attributeDict objectForKey:@"coverArt"]];
            self.currentAlbum.coverArt = [self.currentData copy];
        }
    }
    else if ([elementName isEqualToString:kPlaylist]) {
		Playlist *playlist = [[Playlist alloc] init];
        currentPlaylist = playlist;
        [currentData setString:[attributeDict objectForKey:@"name"]];
        self.currentPlaylist.playlistName = [self.currentData copy];
        [currentData setString:[attributeDict objectForKey:@"id"]];
        self.currentPlaylist.playlistID = [self.currentData copy];
    }
    else if ([elementName isEqualToString:kPlaylistEntry] && [[attributeDict objectForKey:@"isDir"] isEqualToString:@"false"]) {
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
        if ([attributeDict objectForKey:@"coverArt"] != nil){
            [currentData setString:[attributeDict objectForKey:@"coverArt"]];
            self.currentSong.albumArt = [self.currentData copy];
        }
    }
    else if ([elementName isEqualToString:kPlaylistEntry] && [[attributeDict objectForKey:@"isDir"] isEqualToString:@"true"]) {
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
        if ([attributeDict objectForKey:@"coverArt"] != nil){
            [currentData setString:[attributeDict objectForKey:@"coverArt"]];
            self.currentAlbum.coverArt = [self.currentData copy];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {     
    if ([elementName isEqualToString:kEntryElementName]) {
		inItemTag = NO;
    } else if ([elementName isEqualToString:kLinkElementName]) {
        [self.errorList addObject:self.currentError];
    } else if ([elementName isEqualToString:kArtistElement]) {
        if ([currentLetter isEqualToString:@"A"]){
            [[self.artistList objectAtIndex:0]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"B"]){
            [[self.artistList objectAtIndex:1]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"C"]){
            [[self.artistList objectAtIndex:2]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"D"]){
            [[self.artistList objectAtIndex:3]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"E"]){
            [[self.artistList objectAtIndex:4]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"F"]){
            [[self.artistList objectAtIndex:5]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"G"]){
            [[self.artistList objectAtIndex:6]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"H"]){
            [[self.artistList objectAtIndex:7]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"I"]){
            [[self.artistList objectAtIndex:8]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"J"]){
            [[self.artistList objectAtIndex:9]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"K"]){
            [[self.artistList objectAtIndex:10]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"L"]){
            [[self.artistList objectAtIndex:11]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"M"]){
            [[self.artistList objectAtIndex:12]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"N"]){
            [[self.artistList objectAtIndex:13]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"O"]){
            [[self.artistList objectAtIndex:14]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"P"]){
            [[self.artistList objectAtIndex:15]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"Q"]){
            [[self.artistList objectAtIndex:16]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"R"]){
            [[self.artistList objectAtIndex:17]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"S"]){
            [[self.artistList objectAtIndex:18]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"T"]){
            [[self.artistList objectAtIndex:19]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"U"]){
            [[self.artistList objectAtIndex:20]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"V"]){
            [[self.artistList objectAtIndex:21]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"W"]){
            [[self.artistList objectAtIndex:22]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"X-Z"]){
            [[self.artistList objectAtIndex:23]addObject:self.currentArtist];
        }
        else if ([currentLetter isEqualToString:@"#"]){
            [[self.artistList objectAtIndex:24]addObject:self.currentArtist];
        }
        
    } else if ([elementName isEqualToString:kAlbumOrSongElement] && isDir == true) {
        [self.albumList addObject:self.currentAlbum];
        isDir = false;
    } else if ([elementName isEqualToString:kAlbumOrSongElement] && isDir == false) {
        [self.songList addObject:self.currentSong];
    } else if ([elementName isEqualToString:kAlbumAccess]) {
        [self.albumList addObject:self.currentAlbum];
        isDir = false;
    } else if ([elementName isEqualToString:kPlaylist]) {
        [self.playlistList addObject:self.currentPlaylist];
    } else if ([elementName isEqualToString:kPlaylistEntry] && isDir == false) {
        [self.songList addObject:self.currentSong];
    } else if ([elementName isEqualToString:kPlaylistEntry] && isDir == true) {
        [self.albumList addObject:self.currentAlbum];
        isDir = false;
    }

    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"Parse error occurred: %@", [parseError localizedDescription]);
    Error *error = [[Error alloc] init];
    error.message = @"Problem with the URL!";
    error.code = @"404";
	[self.errorList addObject:error];
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

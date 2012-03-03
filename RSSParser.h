//
//  RSSParser.h
//  Project1Solution
//
//  Created by Michael Griepentrog on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Error.h"


@interface RSSParser : NSObject <NSXMLParserDelegate> {
@public
	NSMutableArray *articleList;
@private
	NSString *rssURL;
	NSMutableString *currentData;
    Error *currentError;
	BOOL accumulatingParsedCharacterData;
	BOOL inItemTag;
}

-(RSSParser*) initWithRSSFeed: (NSString *)anRSSFeed;

@property (nonatomic, strong) NSMutableArray *articleList;
@property (nonatomic, strong) NSString *rssURL;
@property (nonatomic, strong) NSMutableString *currentData;
@property (nonatomic, strong) Error *currentError;


@end
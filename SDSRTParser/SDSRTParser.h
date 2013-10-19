//
//  SDSRTParser.h
//  SDSRTParser
//
//  Created by Olivier Poitrey on 10/18/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDSubtitle.h"

typedef NS_ENUM(NSInteger, SDSRTParserError)
{
    SDSRTMissingIndexError,
    SDSRTCarriageReturnIndexError,
    SDSRTInvalidTimeError,
    SDSRTMissingTimeError,
    SDSRTMissingTimeBoundariesError
};

@interface SDSRTParser : NSObject

@property (nonatomic, copy) NSArray *subtitles;

- (void)loadFromString:(NSString *)subtitlesString error:(NSError **)error;

@end

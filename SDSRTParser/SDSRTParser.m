//
//  SDSRTParser.m
//  SDSRTParser
//
//  Created by Olivier Poitrey on 10/18/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#import "SDSRTParser.h"

@implementation SDSRTParser

- (void)loadFromString:(NSString *)subtitlesString error:(NSError **)error
{
    _subtitles = [SDSRTParser parseString:subtitlesString error:error];
}

+ (NSArray *)parseString:(NSString *)string error:(NSError **)error
{
    NSMutableArray *subtitles = [[NSMutableArray alloc] init];
    NSScanner *scanner = [NSScanner scannerWithString:string];
    scanner.charactersToBeSkipped = [NSCharacterSet whitespaceCharacterSet];
    NSUInteger line = 1;

    while (![scanner isAtEnd])
    {
        //@autoreleasepool
        {
            // Skip garbage lines if any
            [scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:NULL];
            NSString *cr;
            while ([scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&cr])
            {
                line += cr.length;
            }

            if ([scanner isAtEnd])
            {
                break;
            }

            NSInteger index;
            if (![scanner scanInteger:&index])
            {
                if (error) *error = [self errorWithDescription:@"Missing index" type:SDSRTMissingIndexError line:line];
                return nil;
            }

            if (![scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&cr])
            {
                if (error) *error = [self errorWithDescription:@"Missing return after index" type:SDSRTCarriageReturnIndexError line:line];
                return nil;
            }
            line += cr.length;

            NSTimeInterval startTime = [self scanTime:scanner];
            if (startTime == -1)
            {
                if (error) *error = [self errorWithDescription:@"Invalid start time" type:SDSRTInvalidTimeError line:line];
                return nil;
            }

            if (![scanner scanString:@"-->" intoString:NULL])
            {
                if (error) *error = [self errorWithDescription:@"Missing or invalid time boundaries separator" type:SDSRTMissingTimeBoundariesError line:line];
                return nil;
            }

            NSTimeInterval endTime = [self scanTime:scanner];
            if (endTime == -1)
            {
                if (error) *error = [self errorWithDescription:@"Invalid end time" type:SDSRTInvalidTimeError line:line];
                return nil;
            }

            if (![scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&cr])
            {
                if (error) *error = [self errorWithDescription:@"Missing return after time boundaries" type:SDSRTCarriageReturnIndexError line:line];
                return nil;
            }
            line += cr.length;

            NSMutableString *content = [[NSMutableString alloc] init]
            ;
            NSString *lineString;
            while ([scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&lineString])
            {
                [content appendString:lineString];
                [scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&cr];
                line += cr.length;
                if (cr.length > 1)
                {
                    break;
                }
            }
            [subtitles addObject:[[SDSubtitle alloc] initWithIndex:index startTime:startTime endTime:endTime content:content]];
        }
    }

    return [subtitles copy];
}

+ (NSTimeInterval)scanTime:(NSScanner *)scanner
{
    NSInteger hours, minutes, seconds, milliseconds;
    if (![scanner scanInteger:&hours]) return -1;
    if (![scanner scanString:@":" intoString:NULL]) return -1;
    if (![scanner scanInteger:&minutes]) return -1;
    if (![scanner scanString:@":" intoString:NULL]) return -1;
    if (![scanner scanInteger:&seconds]) return -1;
    if (![scanner scanString:@"," intoString:NULL]) return -1;
    if (![scanner scanInteger:&milliseconds]) return -1;

    if (hours < 0  || minutes < 0  || seconds <  0 || milliseconds < 0 ||
        hours > 60 || minutes > 60 || seconds > 60 || milliseconds > 999)
    {
        return -1;
    }

    return (hours * 60 * 60) + (minutes * 60) + seconds + (milliseconds / 1000.0);
}

+ (NSError *)errorWithDescription:(NSString *)description type:(SDSRTParserError)type line:(NSUInteger)line
{
    description = [description stringByAppendingFormat:@" at %d line", (uint)line + 1];
    return [NSError errorWithDomain:@"SDSRTParser" code:type userInfo:@
    {
        NSLocalizedDescriptionKey: description,
        @"line": @(line)
    }];
}

@end

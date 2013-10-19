//
//  SDSRTParserTests.m
//  SDSRTParserTests
//
//  Created by Olivier Poitrey on 10/18/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SDSRTParser.h"

@interface SDSRTParser (Private)

+ (NSArray *)parseString:(NSString *)string error:(NSError **)error;

@end

@interface SDSRTParserTests : XCTestCase

@end

@implementation SDSRTParserTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMissingIndex
{
    NSError *error;
    NSArray *subtitles = [SDSRTParser parseString:@"a\n00:00:00,000 --> 00:00:08,123\ntest\n\n" error:&error];

    XCTAssertNil(subtitles, @"Returns nil");
    XCTAssertNotNil(error, @"Error is set");
    XCTAssertEqual(error.code, SDSRTMissingIndexError, @"Error type");
    XCTAssertEqual([error.userInfo[@"line"] integerValue], (NSInteger)1, @"Error location");
}

- (void)testInvalidStartTime
{
    NSError *error;
    NSArray *subtitles = [SDSRTParser parseString:@"1\n-1:00:00,000 --> 00:00:08,123\ntest\n\n" error:&error];

    XCTAssertNil(subtitles, @"Returns nil");
    XCTAssertNotNil(error, @"Error is set");
    XCTAssertEqual(error.code, SDSRTInvalidTimeError, @"Error type");
    XCTAssertEqual([error.userInfo[@"line"] integerValue], (NSInteger)2, @"Error location");
}

- (void)testInvalidTimeBoundary
{
    NSError *error;
    NSArray *subtitles = [SDSRTParser parseString:@"1\n00:00:00,000 ---> 00:00:08,123\ntest\n\n" error:&error];

    XCTAssertNil(subtitles, @"Returns nil");
    XCTAssertNotNil(error, @"Error is set");
    XCTAssertEqual(error.code, SDSRTMissingTimeBoundariesError, @"Error type");
    XCTAssertEqual([error.userInfo[@"line"] integerValue], (NSInteger)2, @"Error location");
}

- (void)testSkipSpaces
{
    NSError *error;
    NSArray *subtitles = [SDSRTParser parseString:@"   1   \n    00:00:00,000    -->    00:00:08,123    \n     test    \n  \n   \n\n\n" error:&error];

    XCTAssertNotNil(subtitles, @"Returns result");
    XCTAssertNil(error, @"No error");
}

- (void)testParseMultiple
{
    NSError *error;
    NSArray *subtitles = [SDSRTParser parseString:@"1\n00:00:00,000 --> 00:00:08,123\ntest\n\n2\n00:00:10,000 --> 00:01:00,000\ntest\n\n" error:&error];

    XCTAssertNotNil(subtitles, @"Returns result");
    XCTAssertNil(error, @"No error");
    XCTAssertEqual(subtitles.count, (NSUInteger)2, @"Parsed 2 subtitles");
}

- (void)testTimeParsing
{
    NSError *error;
    NSArray *subtitles = [SDSRTParser parseString:@"1\n00:00:00,000 --> 00:00:08,123\ntest\n\n" error:&error];


    XCTAssertNotNil(subtitles, @"Returns result");
    XCTAssertNil(error, @"No error");
    XCTAssertEqual(subtitles.count, (NSUInteger)1, @"Parsed 1 subtitle");
    SDSubtitle *subtitle = (SDSubtitle *)subtitles[0];
    XCTAssertEqual(subtitle.endTime, (NSTimeInterval)8.123, @"Time parsed");
}

- (void)testNoCarriageReturnAtEOF
{
    NSError *error;
    NSArray *subtitles = [SDSRTParser parseString:@"1\n00:00:00,000 --> 00:00:08,123\ntest" error:&error];


    XCTAssertNotNil(subtitles, @"Returns result");
    XCTAssertNil(error, @"No error");
    XCTAssertEqual(subtitles.count, (NSUInteger)1, @"Parsed 1 subtitle");
    SDSubtitle *subtitle = (SDSubtitle *)subtitles[0];
    XCTAssertEqualObjects(subtitle.content, @"test", @"Content parsed");
}

- (void)testSampleFile
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"sample" ofType:@"srt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

    NSError *error;
    NSArray *subtitles = [SDSRTParser parseString:content error:&error];

    XCTAssertNotNil(subtitles, @"Returns result");
    XCTAssertNil(error, @"No error");
    XCTAssertEqual(subtitles.count, (NSUInteger)18, @"Parsed 18 subtitle");
}

@end

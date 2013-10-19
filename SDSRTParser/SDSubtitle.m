//
//  SDSubtitle.m
//  SDSRTParser
//
//  Created by Olivier Poitrey on 10/19/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#import "SDSubtitle.h"

@interface SDSubtitle ()

@property (nonatomic, assign, readwrite) NSUInteger index;
@property (nonatomic, assign, readwrite) NSTimeInterval startTime;
@property (nonatomic, assign, readwrite) NSTimeInterval endTime;
@property (nonatomic, copy, readwrite) NSString *content;

@end

@implementation SDSubtitle

- (id)initWithIndex:(NSUInteger)index startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime content:(NSString *)content
{
    if ((self = [super init]))
    {
        _index = index;
        _startTime = startTime;
        _endTime = endTime;
        _content = content;
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"#%lu %f -> %f: %@", (unsigned long)_index, _startTime, _endTime, _content];
}

@end

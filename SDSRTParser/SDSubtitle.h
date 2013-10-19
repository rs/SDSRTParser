//
//  SDSubtitle.h
//  SDSRTParser
//
//  Created by Olivier Poitrey on 10/19/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDSubtitle : NSObject

@property (nonatomic, assign, readonly) NSUInteger index;
@property (nonatomic, assign, readonly) NSTimeInterval startTime;
@property (nonatomic, assign, readonly) NSTimeInterval endTime;
@property (nonatomic, copy, readonly) NSString *content;

- (id)initWithIndex:(NSUInteger)index startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime content:(NSString *)content;

@end

SDSRTParser
===========

[![Build Status](https://travis-ci.org/rs/SDSRTParser.png?branch=master)](https://travis-ci.org/rs/SDSRTParser)

SDSRTParser is an easy to use Objective-C SRT subtitle parser.

Sample usage example:

```objective-c
SDSRTParser *parser = [[SDSRTParser alloc] init];
[parser loadFromString:@"1\n00:00:12,345 --> 00:00:34,567\nfoo\nbar\n\n..."];

for (SDSubtitle *subtitle in parser.subtitles)
{
    subtitle.index;
    subtitle.startTime;
    subtitle.endTime
    subtitle.content;
}
```

//
//  TweetSchedule.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TweetSchedule.h"

@implementation TweetSchedule






-(TweetSchedule *)transformTweetSchedule {
    _urlschedulearruidtipArr = [_urlschedulearruidtip componentsSeparatedByString:@","];
    NSString *nullStr = _urlschedulearruidtipArr.firstObject;
    if (_urlschedulearruidtipArr.count == 1 && nullStr.length == 0) {
        _urlschedulearruidtipArr = @[];
    }
    return self;
}

@end

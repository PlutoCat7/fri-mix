//
//  Dairy.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "Dairy.h"
#import "HouseTweet.h"
@implementation Dairy

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"dairyrangeJA" : [RangeModel class],
             @"fileJA": [FileModel class],
             @"dairyremindJA": [RemindModel class]
             };
}


-(Dairy *)transformDairy{
    
    if (_arruidrange.length && !_arruidrangeArr) {
        NSString *firstText = [_arruidrange substringToIndex:1];
        if ([firstText isEqualToString:@","]) {
            _arruidrange = [_arruidrange substringFromIndex:1];
        }
        NSString *lastText = [_arruidrange substringFromIndex:_arruidrange.length-1];
        if ([lastText isEqualToString:@","]) {
            _arruidrange = [_arruidrange substringToIndex:_arruidrange.length-1];
        }
        _arruidrangeArr = [_arruidrange componentsSeparatedByString:@","];
    }
    //    if (self.dairyid) {
    if (_arrurlfile.length && !_arrurlfileArr) {
        NSString *firstText = [_arrurlfile substringToIndex:1];
        if ([firstText isEqualToString:@","]) {
            _arrurlfile = [_arrurlfile substringFromIndex:1];
        }
        NSString *lastText = [_arrurlfile substringFromIndex:_arrurlfile.length-1];
        if ([lastText isEqualToString:@","]) {
            _arrurlfile = [_arrurlfile substringToIndex:_arrurlfile.length-1];
        }
        _arrurlfileArr = [_arrurlfile componentsSeparatedByString:@","];
    }
    //    }else{
    //
    //        __block NSMutableArray *images = [NSMutableArray new];
    //        [_arrurlfileArr enumerateObjectsUsingBlock:^(TweetImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            [images addObject:obj.image];
    //        }];
    //        _arrurlfileArr = images;
    //        return self;
    //    }
    
//    if (_arruidremind.length && !_arruidremindArr) {
//        NSString *firstText = [_arruidremind substringToIndex:1];
//        if ([firstText isEqualToString:@","]) {
//            _arruidremind = [_arruidremind substringFromIndex:1];
//        }
//        NSString *lastText = [_arruidremind substringFromIndex:_arruidremind.length-1];
//        if ([lastText isEqualToString:@","]) {
//            _arruidremind = [_arruidremind substringToIndex:_arruidremind.length-1];
//        }
//
//        _arruidremindArr = [_arruidremind componentsSeparatedByString:@","];
//    }
    
//    if (_urlfilesmall.length && !_urlfilesmallArr) {
//        NSString *firstText = [_urlfilesmall substringToIndex:1];
//        if ([firstText isEqualToString:@","]) {
//            _urlfilesmall = [_urlfilesmall substringFromIndex:1];
//        }
//        NSString *lastText = [_urlfilesmall substringFromIndex:_urlfilesmall.length-1];
//        if ([lastText isEqualToString:@","]) {
//            _urlfilesmall = [_urlfilesmall substringToIndex:_urlfilesmall.length-1];
//        }
//
//        _urlfilesmallArr = [_urlfilesmall componentsSeparatedByString:@","];
//    }
    
    _urlfilesmallArr = [[NSMutableArray alloc] init];
    
    return self;
}



@end


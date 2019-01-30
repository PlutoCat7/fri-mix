//
//  GBGameTimeDivisionCompletePreview.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBGameTimeDivisionCompletePreview : UIView

+ (void)showWithComplete:(void(^)(NSInteger index))complete
         sectionDateList:(NSArray<NSArray<NSDate *> *> *)sectionDateList
                 weScore:(NSInteger)wescore
                oppScore:(NSInteger)oppScore;

@end

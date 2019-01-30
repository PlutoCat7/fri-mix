//
//  GBGameCompletePreview.h
//  GB_Football
//
//  Created by wsw on 16/8/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBGameCompletePreview : UIView

+ (void)showWithComplete:(void(^)(NSInteger index))complete dataList:(NSArray<NSString *> *)dataList;

@end

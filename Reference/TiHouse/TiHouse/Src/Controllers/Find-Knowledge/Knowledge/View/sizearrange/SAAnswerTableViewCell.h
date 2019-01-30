//
//  SAAnswerTableViewCell.h
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowModeInfo.h"

@interface SAAnswerTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^clickItemBlock)(KnowModeInfo * knowModeInfo);
@property (nonatomic, copy) void (^clickFavorBlock)(KnowModeInfo * knowModeInfo);

- (void)refreshWithKnowModeInfo:(KnowModeInfo *)knowModeInfo isFontBold:(BOOL)isFontBold;

+ (CGFloat)defaultHeight:(NSString *)content;

@end

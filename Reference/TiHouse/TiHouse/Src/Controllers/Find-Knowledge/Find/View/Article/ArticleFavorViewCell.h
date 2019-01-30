//
//  ArticleFavorViewCell.h
//  TiHouse
//
//  Created by weilai on 2018/2/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindAssemarcInfo.h"

@interface ArticleFavorViewCell : UITableViewCell

@property (nonatomic, copy) void (^clickFavorBlock)(FindAssemarcInfo * info);

- (void)refreshWithInfo:(FindAssemarcInfo *)info;

+ (CGFloat)defaultHeight:(NSString *)content;

@end

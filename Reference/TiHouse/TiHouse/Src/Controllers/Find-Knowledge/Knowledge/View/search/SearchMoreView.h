//
//  SearchMoreView.h
//  TiHouse
//
//  Created by weilai on 2018/4/22.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"

@interface SearchMoreView : UIView
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

@property (nonatomic, copy) void (^clickItemBlock)(KnowType knowType);

- (void)updateMoreLabe:(KnowType)knowType;

@end

//
//  SearchMoreView.m
//  TiHouse
//
//  Created by weilai on 2018/4/22.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SearchMoreView.h"

@interface SearchMoreView()

@property (assign, nonatomic) KnowType knowType;

@end

@implementation SearchMoreView

- (IBAction)actionMore:(id)sender {
    if (self.clickItemBlock) {
        self.clickItemBlock(_knowType);
    }
}

- (void)updateMoreLabe:(KnowType)knowType {
    _knowType = knowType;
    switch (knowType) {
        case KnowType_Poster:
            self.moreLabel.text = @"查看更多有数小报搜索结果";
            break;
            
        case KnowType_SFurniture:
        case KnowType_SIndoor:
        case KnowType_SLiveroom:
        case KnowType_SRestaurant:
        case KnowType_SRoom:
        case KnowType_SKitchen:
            self.moreLabel.text = @"查看更多尺寸宝典搜索结果";
            break;
            
        case KnowType_FLiveroom:
        case KnowType_FRoom:
        case KnowType_FToilet:
        case KnowType_FKitchen:
        case KnowType_FRestaurant:
        case KnowType_FOther:
            self.moreLabel.text = @"查看更多家居风水搜索结果";
            break;
            
        default:
            break;
    }
}

@end

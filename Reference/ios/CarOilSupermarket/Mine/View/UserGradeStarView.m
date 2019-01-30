//
//  UserGradeStarView.m
//  CarOilSupermarket
//
//  Created by wangshiwen on 2018/3/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "UserGradeStarView.h"

@interface UserGradeStarView ()


@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starListView;


@end

@implementation UserGradeStarView

- (void)refreshViewLevel:(NSInteger)level {
    
    if (level == -1) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
        [self.starListView enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < level) {
                obj.image = [UIImage imageNamed:@"user_grade_star_light"];
            }else {
                obj.image = [UIImage imageNamed:@"user_grade_star"];
            }
        }];
    }
}

@end

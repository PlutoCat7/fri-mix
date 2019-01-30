//
//  PlayerDetailCommontSectionView.h
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPlayerDetailCommontSectionViewHeight (38*kAppScale)


@interface PlayerDetailCommontSectionView : UITableViewHeaderFooterView

- (void)refreshWithCommentCount:(NSInteger)count;

@end

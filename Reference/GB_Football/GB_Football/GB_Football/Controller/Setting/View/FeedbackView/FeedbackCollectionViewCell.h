//
//  FeedbackCollectionViewCell.h
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBView.h"

@interface FeedbackCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet GBView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

//
//  TimeDivisionFooterView.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeDivisionFooterViewDelegate <NSObject>

- (void)didClickFooterView;

@end

@interface TimeDivisionFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (nonatomic, weak) id<TimeDivisionFooterViewDelegate> delegate;

@end

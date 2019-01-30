//
//  ChartTopView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/21.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "ChartTopView.h"
#import "XXNibBridge.h"
#import "UIColor+Extension.h"

@interface ChartTopView ()<XXNibBridge>

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

@implementation ChartTopView

- (void)refreshUIWith:(NSInteger)number text:(NSString *)text detailText:(NSString *)detailText {
    
    self.numberLabel.textColor = [UIColor color:self.textcColor withAlpha:0.5];
    self.numberLabel.text = [NSString stringWithFormat:@"%02td", number];
    self.textLabel.text = text;
    self.detailTextLabel.text = detailText;
    self.lineView.backgroundColor = [UIColor color:self.textcColor withAlpha:0.4];
}

- (IBAction)actionMore:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(actionMore:)]) {
        [self.delegate actionMore:self];
    }
}

- (void)hideMoreButton {
    
    self.moreButton.hidden = YES;
    self.moreImageView.hidden = YES;
}

@end

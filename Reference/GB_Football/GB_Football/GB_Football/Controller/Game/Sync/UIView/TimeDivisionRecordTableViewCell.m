//
//  TimeDivisionRecordTableViewCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TimeDivisionRecordTableViewCell.h"

@interface TimeDivisionRecordTableViewCell ()

@property (nonatomic, strong) CAShapeLayer *beginLayer;
@property (nonatomic, strong) CAShapeLayer *endLayer;

@property (nonatomic, assign) BOOL isShowBeginLayer;
@property (nonatomic, assign) BOOL isShowEndLayer;

@end

@implementation TimeDivisionRecordTableViewCell

-(void)localizeUI{

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isShowBeginLayer) {
            if (!self.beginLayer) {
                self.beginLayer =  [self layerWithFrame:self.beginView.bounds];
            }
            if (!self.beginLayer.superlayer) {
                [self.beginView.layer addSublayer:self.beginLayer];
            }
        }
        if (self.isShowEndLayer) {
            if (!self.endLayer) {
                self.endLayer =  [self layerWithFrame:self.endView.bounds];
            }
            if (!self.endLayer.superlayer) {
                [self.endView.layer addSublayer:self.endLayer];
            }
        }
    });
}

- (void)showBeginLayer:(BOOL)show {
    
    self.isShowBeginLayer = show;
    if (show) {
        
        self.beginTimeLabel.text = LS(@"multi-section.record");
        self.beginTimeLabel.textColor = [UIColor greenColor];
    }else {
        [self.beginLayer removeFromSuperlayer];
        self.beginTimeLabel.textColor = [UIColor whiteColor];

    }
}

- (void)showEndLayer:(BOOL)show {
    
    self.isShowEndLayer = show;
    if (show) {
        
        self.endTimeLabel.text = LS(@"multi-section.record");
        self.endTimeLabel.textColor = [UIColor greenColor];
    }else {
        [self.endLayer removeFromSuperlayer];
        self.endTimeLabel.textColor = [UIColor whiteColor];
    }
}


- (CAShapeLayer *)layerWithFrame:(CGRect)frame {
    
    CAShapeLayer *border =  [CAShapeLayer layer];
    border.strokeColor = [UIColor greenColor].CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:frame].CGPath;
    
    border.frame = self.bounds;
    
    border.lineWidth = 1.f;
    
    border.lineCap = @"square";
    
    border.lineDashPattern = @[@4, @2];
    
    return border;
}

#pragma mark - Action

- (IBAction)actionBeginTime:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBeginTime:)]) {
        [self.delegate didClickBeginTime:self];
    }
}
- (IBAction)actionEndTime:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEndTime:)]) {
        [self.delegate didClickEndTime:self];
    }
}

@end

//
//  PosterMultTableViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PosterMultTableViewCell.h"

#import "PosterSubView.h"

@interface PosterMultTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIView *subsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBgLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;

@property (strong, nonatomic) NSArray <KnowModeInfo *> *array;

@end

@implementation PosterMultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.containView.layer setMasksToBounds:YES];
    [self.containView.layer setCornerRadius:5.f];
    
    [self.dateLabel.layer setMasksToBounds:YES];
    [self.dateLabel.layer setCornerRadius:5.f];
    
    self.dateLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"00000" andAlpha:0].CGColor, (__bridge id)[UIColor colorWithHexString:@"00000" andAlpha:0.3].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, self.imageBgView.width, self.imageBgView.height);
    [self.imageBgView.layer addSublayer:gradientLayer];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithArray:(NSArray <KnowModeInfo *> *)array date:(NSString *)date {
    
    _array = array;
    if (array.count == 0) {
        return;
    }
    
    KnowModeInfo *firstInfo = array[0];
    
    NSDate *dateObj = [NSDate dateWithTimeIntervalSince1970:(firstInfo.knowctime/1000)];
    NSString *key = [NSString stringWithFormat:@" %02d-%02d %02d:%02d ", (int)dateObj.month, (int)dateObj.day, (int)dateObj.hour, (int)dateObj.minute];
    
    self.dateLabel.text = key;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:firstInfo.knowurlindex]];
    self.titleLabel.text = firstInfo.knowtitle;
    
    self.titleBgLayoutConstraint.constant = [self calculateLabelHeight:firstInfo.knowtitle fontSize:14.f width:self.titleLabel.frame.size.width] + 10;
    self.subLayoutConstraint.constant = (array.count - 1) * 70;
    
    NSArray <UIView *> *allSubView = self.subsView.subviews;
    for (UIView *view in allSubView) {
        [view removeFromSuperview];
    }
    
    CGFloat top = 0;
    for (int i = 1; i < array.count; i++) {
        PosterSubView *subView =  [[NSBundle mainBundle]loadNibNamed:@"PosterSubView" owner:nil options:nil].firstObject;
        [subView refreshWithKnowModeInfo:array[i]];
        subView.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
            [self actionSelectItem:knowModeInfo];
        };
        
        [self.subsView addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subsView).offset(top);
            make.left.equalTo(self.subsView);
            make.right.equalTo(self.subsView);
            make.height.equalTo(@(70));
        }];
        
        top += 70;
    }
    
}

- (CGFloat)calculateLabelHeight:(NSString *)content fontSize:(CGFloat)fontSize width:(CGFloat)width {
    // 展开后得高度 = 计算出文本内容的高度 + 固定控件的高度
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, 0) options:option attributes:attribute context:nil].size;
    
    return size.height;
}

+ (CGFloat)calculateHeight:(NSInteger)count {
    return 270 + 70 * (count - 1);
}

- (IBAction)actionFirstItem:(id)sender {
    [self actionSelectItem:self.array[0]];
}

- (void)actionSelectItem:(KnowModeInfo *)knowModeInfo {
    if (self.clickItemBlock) {
        self.clickItemBlock(knowModeInfo);
    }
}

@end

//
//  MineSettingsTableViewCell.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineSettingsTableViewCell.h"
#import "UnReadManager.h"

@implementation MineSettingsButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    
    frame = CGRectMake(0, 36, self.frame.size.width, kRKBHEIGHT(20));
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;

    frame = CGRectMake((self.frame.size.width - 20)/2.0, 10, kRKBHEIGHT(20), kRKBHEIGHT(20));

    return frame;
}

//- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    CGRect bounds = self.bounds;
//    bounds = CGRectInset(bounds, -20, -20);
//    return CGRectContainsPoint(bounds, point);
//}
@end


@implementation MineSettingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
        RAC(self, badgeValue) = [RACSignal combineLatest:@[RACObserve([UnReadManager shareManager], me_update_count)]
                                                               reduce:^id(NSNumber *me_update_count){
                                                                   NSString *badgeTip = @"";
                                                                   NSNumber *unreadCount = [NSNumber numberWithInteger:me_update_count.integerValue];
                                                                   if (unreadCount.integerValue > 0) {
                                                                       if (unreadCount.integerValue > 99) {
                                                                           badgeTip = @"99+";
                                                                       }else{
                                                                           badgeTip = unreadCount.stringValue;
                                                                       }
                                                                   }
                                                                   return badgeTip;
                                                               }];
    }
    return self;
}

- (void)addSubViews {
    
    NSArray *titlesArray = @[@"我的消息", @"通用设置", @"意见反馈"];
    NSArray *imagesArray = @[@"mine_news", @"mine_setting", @"mine_feedback"];
    
    CGFloat margin = (kScreen_Width - 300) / 4.0;
    
    for (NSInteger i = 0; i < 3; i++) {
        MineSettingsButton *button = [[MineSettingsButton alloc] init];
        [self.contentView addSubview:button];
        [button setTitle:titlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(15));
            make.width.equalTo(@100);
            make.left.equalTo(@(margin +  (margin + 100) * i));
            make.height.equalTo(@(kRKBHEIGHT(60)));
        }];
        button.tag = 10000 + i;
        button.titleLabel.font = ZISIZE(12);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:imagesArray[i]] forState:UIControlStateNormal];
    }
}

- (void)buttonClick:(UIButton *)sender {
    
    if (sender) {
        if([_delegate respondsToSelector:@selector(handleClick:)]) {
            [_delegate handleClick:sender.tag];
        }
    }
}

-(void)UnRead{
    UIButton *sender = [self.contentView viewWithTag:10000];
    UnReadManager * unread = [UnReadManager shareManager];
    if ([unread.me_update_count integerValue] > 0) {
        [sender addBadgeTip:[NSString stringWithFormat:@"%@",unread.me_update_count] withCenterPosition:CGPointMake(CGRectGetMaxX(sender.imageView.frame)+10, sender.imageView.y)];
    }else{
        [sender removeBadgeTips];
    }
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    UIButton *sender = [self.contentView viewWithTag:10000];
    if ([_badgeValue integerValue] > 0) {
        [sender addBadgeTip:[NSString stringWithFormat:@"%@",_badgeValue] withCenterPosition:CGPointMake(CGRectGetMaxX(sender.imageView.frame)+10, sender.imageView.y)];
    }else{
        [sender removeBadgeTips];
    }
}


@end

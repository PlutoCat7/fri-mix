//
//  TimerShaftTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//


#define kTreetCell_LinePadingLeft 18.0
#define kTreetMedia_MediaItem_Pading 5.0
#define kTreetMedia_Wtith kScreen_Width - kTreetCell_LinePadingLeft - 11 - 24
#define  kTreet_ContentFont [UIFont systemFontOfSize:15]
#define BOTTOMHEIGHT 30

#import "TimerShaftNoContentCell.h"
@interface TimerShaftNoContentCell()

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic ,retain) UIView *line;//时光轴的线
@property (nonatomic ,retain) UIImageView *imageBgView;
@property (nonatomic ,strong) UILabel *dateView;



@end

@implementation TimerShaftNoContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineStyle = CellLineStyleNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self topView];
        [self icon];
        [self line];
        [self dateView];
        [self imageBgView];
        
    }
    return self;
}



#pragma mark - getters and setters
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
        [self.contentView addSubview:_topView];
    }
    return _topView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
        [self.contentView addSubview:_bottomView];
    }
    return _bottomView;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(kTreetCell_LinePadingLeft, CGRectGetMaxY(_topView.frame), 11, 11)];
        _icon.image = [UIImage imageNamed:@"timerShaft_lock"];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(_icon.centerX, CGRectGetMaxY(_icon.frame), 1, self.contentView.height)];
        _line.backgroundColor = kLineColer;
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_icon.mas_centerX);
            make.top.equalTo(_icon.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(1));
        }];
    }
    return _line;
}

-(UILabel *)dateView{
    if (!_dateView) {
        _dateView = [[UILabel alloc]initWithFrame:CGRectMake(kTreetCell_LinePadingLeft + 17, _icon.y-3, 122, 20)];
        _dateView.textColor = XWColorFromHex(0x44444b);
        _dateView.text = @"今天";
        _dateView.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_dateView];
    }
    return _dateView;
}

-(UIImageView *)imageBgView{
    if (!_imageBgView) {
        _imageBgView = [[UIImageView alloc]init];
        _imageBgView.contentMode = UIViewContentModeScaleAspectFit;
        _imageBgView.image = [UIImage imageNamed:@"TweetNoC"];
        _imageBgView.userInteractionEnabled = YES;
        CGFloat H = _imageBgView.image.size.width / (kScreen_Width - 12- kTreetCell_LinePadingLeft-9-5);
        [self.contentView addSubview:_imageBgView];
        [_imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-12);
            make.top.equalTo(_icon.mas_bottom).offset(9);
            make.height.equalTo(@(_imageBgView.image.size.height / H));
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:XWColorFromHex(0xfec00c) forState:UIControlStateNormal];
        [btn setTitle:@"添加记录" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(lockBuggetClick) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.layer.cornerRadius = 25;
        [_imageBgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageBgView.mas_left).offset(58);
            make.right.equalTo(_imageBgView.mas_right).offset(-58);
            make.bottom.equalTo(_imageBgView.mas_bottom).offset(-15);
            make.height.equalTo(@(50));
        }];
        
    }
    return _imageBgView;
}


-(void)lockBuggetClick{
    XWLog(@"==========");
    if (self.CellBlockClick) {
        self.CellBlockClick();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

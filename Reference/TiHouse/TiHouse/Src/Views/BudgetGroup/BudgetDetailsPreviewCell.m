//
//  BudgetDetailsTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetDetailsPreviewCell.h"
#import "BudgetThreeClass.h"

@interface BudgetDetailsPreviewCell()

@property (nonatomic, retain) UIView *contentBgView;
@property (nonatomic, retain) UIImageView *buyIcon;
@property (nonatomic, retain) UIImageView *starIcon;
@property (nonatomic, retain) UIImageView *rightIcon;
@property (nonatomic, retain) UILabel *titleView;
@property (nonatomic, retain) UILabel *moneyView;
@property (nonatomic, retain) UILabel *proremarkView;
@property (nonatomic, retain) UIButton *deletebtn;
@property (nonatomic, retain) UIView *line;

@end

@implementation BudgetDetailsPreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.bottomLineStyle = CellLineStyleNone;
        _lineShow = YES;
        [self contentBgView];
        [self buyIcon];
        [self starIcon];
        [self titleView];
        [self proremarkView];
        [self moneyView];
        [self line];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_lineShow) {
        _line.hidden = YES;
    }else{
        _line.hidden = NO;
    }
    
    
    if (!_threeClass.protypexb) {
        [_buyIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentBgView).offset(0);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(0.1, 1));
        }];
    }else{
        [_buyIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentBgView).offset(0);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12.5f, 12.5f));
        }];
    }
    if (!_threeClass.protypeyg) {
        [_starIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_buyIcon.mas_right).offset(0);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(0.1, 1));
        }];
    }else{
        [_starIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_buyIcon.mas_right).offset(!_threeClass.protypexb ? 0 : 4);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12.5f, 12.5f));
        }];
    }
    
    
    _deletebtn.hidden = YES;
    if (!_threeClass.catethreestatus) {
        _deletebtn.hidden = NO;
    }
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_starIcon.mas_right).offset(!_threeClass.protypexb&&!_threeClass.protypeyg ? 0 : 4);
        make.centerY.equalTo(_contentBgView.mas_centerY);
        make.size.mas_equalTo(_titleView.size);
    }];
    [_proremarkView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleView.mas_right).offset(4);
        make.centerY.equalTo(_contentBgView.mas_centerY);
        make.size.mas_equalTo(_proremarkView.size);
    }];
    [_moneyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentBgView);
        make.centerY.equalTo(_contentBgView.mas_centerY);
        make.size.mas_equalTo(_moneyView.size);
    }];
    
}


#pragma mark - getters and setters
-(void)setThreeClass:(BudgetThreeClass *)threeClass{
    _threeClass = threeClass;
    _titleView.text = threeClass.proname;
    if (threeClass.proremark.length > 10) {
        _proremarkView.text = [NSString stringWithFormat:@"- %@...",[threeClass.proremark substringToIndex:9]];
    } else if (threeClass.proremark.length > 0) {
        _proremarkView.text = [NSString stringWithFormat:@"- %@",threeClass.proremark];
    } else {
        _proremarkView.text = @"";
    }
    [_titleView sizeToFit];
    [_proremarkView sizeToFit];
    _moneyView.text = [NSString stringWithFormat:@"¥ %@",[NSString strmethodComma:[NSString stringWithFormat:@"%.0f",threeClass.amountzj / 100.0f]]];
    [_moneyView sizeToFit];
    [self layoutSubviews];
}



-(UIView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc]init];
        _contentBgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_contentBgView];
        [_contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(0);
            make.left.equalTo(self.contentView).offset(12);
            make.right.equalTo(self.contentView).offset(-12);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return _contentBgView;
}


-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kScreen_Width-24, 1)];
        [_contentBgView addSubview:_line];
        [self drawDashLine:_line lineLength:1 lineSpacing:1 lineColor:kLineColer];
    }
    return _line;
}


-(UIImageView *)buyIcon{
    if (!_buyIcon) {
        UIImage *image =[UIImage imageNamed:@"buyIcon"];
        _buyIcon = [[UIImageView alloc]init];
        _buyIcon.image = image;
        _buyIcon.contentMode = UIViewContentModeScaleAspectFit;
        [_contentBgView addSubview:_buyIcon];
        [_buyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentBgView).offset(0);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(image.size);
        }];
    }
    return _buyIcon;
}

-(UIImageView *)starIcon{
    if (!_starIcon) {
        UIImage *image =[UIImage imageNamed:@"moey_icon"];
        _starIcon = [[UIImageView alloc]init];
        _starIcon.image = image;
        _starIcon.contentMode = UIViewContentModeScaleAspectFit;
        [_contentBgView addSubview:_starIcon];
        [_starIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_buyIcon.mas_right).offset(4);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(image.size);
        }];
    }
    return _starIcon;
}

-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]init];
        _titleView.textColor = XWColorFromHex(0x5186aa);
        _titleView.font = [UIFont systemFontOfSize:17];
        [_contentBgView addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_starIcon.mas_right).offset(4);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    return _titleView;
}

-(UILabel *)proremarkView{
    if (!_proremarkView) {
        _proremarkView = [[UILabel alloc]init];
        _proremarkView.textColor = kColor999;
        _proremarkView.font = [UIFont systemFontOfSize:15];
        [_contentBgView addSubview:_proremarkView];
        [_proremarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView.mas_right).offset(4);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    return _proremarkView;
}


-(UILabel *)moneyView{
    if (!_moneyView) {
        _moneyView = [[UILabel alloc]init];
        _moneyView.textColor = kColor999;
        _moneyView.font = [UIFont systemFontOfSize:16];
        [_contentBgView addSubview:_moneyView];
        [_moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_contentBgView);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    return _moneyView;
}



- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


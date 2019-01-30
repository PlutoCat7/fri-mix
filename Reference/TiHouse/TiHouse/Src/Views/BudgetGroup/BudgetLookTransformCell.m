//
//  BudgetDetailsTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetLookTransformCell.h"

@interface BudgetLookTransformCell()

@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UILabel *transformContentView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *proremarkView;
@property (nonatomic, retain) UILabel *moneyView;
@property (nonatomic, retain) UILabel *aa;
@property (nonatomic, retain) UIView *line;

@end

@implementation BudgetLookTransformCell

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
        [self icon];
        [self transformContentView];
        [self titleLabel];
        [self proremarkView];
        [self moneyView];
        [self line];
    }
    return self;
}


-(void)setLogbudgetope:(Logbudgetope *)logbudgetope{
    _logbudgetope = logbudgetope;
    
    NSString *transformStr;
    NSString *image;
    switch (_logbudgetope.budgetopetype) {
        case 1:
            transformStr = @"添加了：";
            image = @"jia_icon";
            break;
        case 2:
            transformStr = @"修改了：";
            image = @"cha_icon";
            break;
        case 3:
            transformStr = @"删除了：";
            image = @"shan_icon";
            break;
        case 4:
            transformStr = @"设置了星标项目：";
            image = @"buyIcon";
            break;
        case 5:
            transformStr = @"设置了已购项目：";
            image = @"moey_icon";
            
            break;
            
        default:
            break;
    }
    UIImage *imagea = [UIImage imageNamed:image];
    _icon.image = imagea;
    if ([_logbudgetope.catetwoname isEqualToString:@"无"]) {
        _transformContentView.text = [NSString stringWithFormat:@"%@%@",transformStr,_logbudgetope.cateonename];
    }else{
        _transformContentView.text = [NSString stringWithFormat:@"%@%@ · %@",transformStr,_logbudgetope.cateonename,_logbudgetope.catetwoname];
    }
    CGSize size = [_transformContentView sizeThatFits:CGSizeMake(20, 20)];
    [_transformContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_icon.mas_right).offset(4);
        make.centerY.equalTo(_icon.mas_centerY);
        make.size.mas_equalTo(size);
    }];
    
    _titleLabel.text = _logbudgetope.budgetopename;
    //    CGSize titlesize = [_titleLabel sizeThatFits:CGSizeMake(20, 20)];
    //    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(_icon.mas_left);
    //        make.top.equalTo(_icon.mas_bottom).offset(10);
    //        make.size.mas_equalTo(titlesize);
    //    }];
    
    if (_logbudgetope.proremark.length>0) {
        _proremarkView.text = [NSString stringWithFormat:@"备注：%@",_logbudgetope.proremark];
        CGSize proremarksize = [_proremarkView sizeThatFits:CGSizeMake(20, 20)];
        [_proremarkView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon);
            make.bottom.equalTo(self.contentView).offset(-8);
            make.size.mas_equalTo(proremarksize);
        }];
    }else{
        _proremarkView.text = @"";
        [_proremarkView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon);
            make.bottom.equalTo(self.contentView).offset(-8);
            make.size.mas_equalTo(CGSizeMake(1, 1));
        }];
    }
    
    _moneyView.text = [NSString stringWithFormat:@"¥%@",[NSString strmethodComma:[NSString stringWithFormat:@"%ld",_logbudgetope.amountzj / 100]]];
    //    CGSize moneysize = [_moneyView sizeThatFits:CGSizeMake(20, 20)];
    //    [_moneyView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_titleLabel.mas_top);
    //        make.right.equalTo(self.contentView).offset(-12);
    //        make.size.mas_equalTo(moneysize);
    //    }];
    
    
    [_line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self).offset(12);
    }];
}



-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_lineShow) {
        _line.hidden = YES;
    }else{
        _line.hidden = NO;
    }
    
}


#pragma mark - getters and setters

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(12, self.height-1, kScreen_Width-24, 1)];
        [self.contentView addSubview:_line];
        [self drawDashLine:_line lineLength:1 lineSpacing:1 lineColor:kLineColer];
    }
    return _line;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(16);
            make.left.equalTo(self.contentView).offset(13);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
    }
    return _icon;
}


-(UILabel *)transformContentView{
    if (!_transformContentView) {
        _transformContentView = [[UILabel alloc]init];
        _transformContentView.textColor = kTitleAddHouseTitleCOLOR;
        _transformContentView.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_transformContentView];
        [_transformContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon.mas_right).offset(4);
            make.centerY.equalTo(_icon.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _transformContentView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13);
            make.top.equalTo(_icon.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
    }
    return _titleLabel;
}



-(UILabel *)proremarkView{
    if (!_proremarkView) {
        _proremarkView = [[UILabel alloc]init];
        _proremarkView.textColor = kColor999;
        _proremarkView.font = [UIFont systemFontOfSize:11];

        [self.contentView addSubview:_proremarkView];
        [_proremarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon);
            make.bottom.equalTo(self.contentView).offset(-8);
            make.width.mas_equalTo(self.contentView).offset(-30);
        }];
    }
    return _proremarkView;
}


-(UILabel *)moneyView{
    if (!_moneyView) {
        _moneyView = [[UILabel alloc]init];
        _moneyView.textColor = XWColorFromHex(0xfec00c);
        _moneyView.font = [UIFont systemFontOfSize:18];
        _moneyView.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_moneyView];
        [_moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_top);
            make.right.equalTo(self.contentView).offset(-12);
            make.size.mas_equalTo(CGSizeMake(200, 20));
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


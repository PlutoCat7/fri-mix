//
//  BudgetListTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetListTableViewCell.h"
#import "Budget.h"
#import "NSDate+Extend.h"
@interface BudgetListTableViewCell()

@property (nonatomic, retain) UIButton *deletebtn;
@property (nonatomic, retain) UILabel *budgetName;
@property (nonatomic, retain) UILabel *houseInfo;
@property (nonatomic, retain) UILabel *houseAddress;
@property (nonatomic, retain) UILabel *upDate;
@property (nonatomic, retain) UIButton *lookBtn;
@property (nonatomic, retain) UIButton *changeBtn;
@property (nonatomic, retain) UIImageView *flag;
@property (nonatomic, retain) UIView *line;

@end

@implementation BudgetListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineStyle = CellLineStyleFill;
        self.topLineStyle = CellLineStyleFill;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setup];
        
    }
    return self;
}


-(void)setup{
    [self deletebtn];
    [self budgetName];
    [self houseInfo];
    [self houseAddress];
    [self upDate];
    [self lookBtn];
    [self changeBtn];
    [self flag];
    [_flag setHidden:YES];

    [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.left.equalTo(_lookBtn.mas_right);
        make.height.mas_equalTo(@(45));
        make.width.equalTo(_lookBtn);
    }];
    [_lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(_changeBtn.mas_left);
        make.height.mas_equalTo(@(45));
        make.width.equalTo(_changeBtn);
    }];
    
    [self line];
    [self drawDashLine:_line lineLength:1 lineSpacing:1 lineColor:kLineColer];

    [self layoutSubviews];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_deletebtn mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_isEdit) {
            make.size.mas_equalTo(CGSizeMake(_deletebtn.imageView.image.size.width-3, _deletebtn.imageView.image.size.height-3));
        }else{
            make.size.mas_equalTo(CGSizeMake(0, _deletebtn.imageView.image.size.height));
        }
    }];

    [_budgetName mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_isEdit) {
            make.left.equalTo(_deletebtn.mas_right).offset(10);
        }else{
            make.left.equalTo(_deletebtn.mas_right);
        }
        make.centerY.equalTo(_deletebtn.mas_centerY);
        make.size.mas_equalTo(_budgetName.size);
    }];
    [_upDate mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(_upDate.mas_centerY);
        make.size.mas_equalTo(_upDate.size);
    }];
    
    if (_isEdit) {
        _budgetName.textColor = XWColorFromHex(0xbfbfbf);
        _changeBtn.userInteractionEnabled = NO;
        _lookBtn.userInteractionEnabled = NO;
    }else{
        _budgetName.textColor = [UIColor blackColor];
        _changeBtn.userInteractionEnabled = YES;
        _lookBtn.userInteractionEnabled = YES;
    }
    
}



-(void)setBudget:(Budget *)budget{
    _budget = budget;
    
    _budgetName.text = [NSString emojizedStringWithString:budget.budgetname];
    [_budgetName sizeToFit];
//    _upDate.text = [NSString stringWithFormat:@"最近修改：%@",[NSDate stringWithDate:[NSDate dateWithTimeIntervalSince1970:budget.budgetupdatetime/1000] format:@"yyyy/MM/dd HH:ss"]];
//    [_upDate sizeToFit];
    NSString *houseType = [NSString stringWithFormat:@"%ld室%ld厅%ld厨%ld卫%ld阳台",(long)budget.numroom,(long)budget.numhall,(long)budget.numkichen,(long)budget.numtoilet,(long)budget.numbalcony];
    _houseInfo.text = [NSString stringWithFormat:@"装修面积：%@m² | 房屋户型：%@", @(budget.area), houseType];
    _houseAddress.text = [NSString stringWithFormat:@"所在地区：%@ %@ %@", budget.provname, budget.cityname, budget.regionname];
    if (budget.islatestedit) {
        [_flag setHidden:NO];
    }
    
}

-(void)Click:(UIButton *)btn{
    if ([self.delagate respondsToSelector:@selector(BudgetListCellBtnCkickRespondType: cellForRowAtIndexPath:)]) {
        [self.delagate BudgetListCellBtnCkickRespondType:btn.tag-10 cellForRowAtIndexPath:_indexPath];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(UIButton *)deletebtn{
    if (!_deletebtn) {
        UIImage *closeImage = [UIImage imageNamed:@"delete_icon"];
        _deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletebtn setImage:closeImage forState:UIControlStateNormal];
        _deletebtn.tag = 10;
        [_deletebtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deletebtn];
        [_deletebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, closeImage.size.height));
            make.left.equalTo(self.contentView).offset(12);
            make.top.equalTo(self.contentView).offset(17);
        }];
    }
    return _deletebtn;
}

-(UILabel *)budgetName{
    if (!_budgetName) {
        _budgetName = [[UILabel alloc]init];
        _budgetName.textColor = [UIColor blackColor];
        _budgetName.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_budgetName];
        [_budgetName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
            make.left.equalTo(_deletebtn.mas_right);
            make.centerY.equalTo(_deletebtn.mas_centerY);
        }];
    }
    return _budgetName;
}

-(UILabel *)houseInfo {
    if (!_houseInfo) {
        _houseInfo = [[UILabel alloc] init];
        _houseInfo.textColor = XWColorFromHex(0x999999);
        _houseInfo.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_houseInfo];
        [_houseInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(55);
            make.left.equalTo(_deletebtn.mas_right);
        }];
    }
    return _houseInfo;
}

-(UILabel *)houseAddress {
    if (!_houseAddress) {
        _houseAddress = [[UILabel alloc] init];
        _houseAddress.textColor = XWColorFromHex(0x999999);
        _houseAddress.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_houseAddress];
        [_houseAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(80);
            make.left.equalTo(_deletebtn.mas_right);
        }];
    }
    return _houseAddress;
}

-(UIImageView *)flag {
    if(!_flag) {
        _flag = [[UIImageView alloc] init];
        _flag.image = [UIImage imageNamed:@"account_topIcon"];
        [self.contentView addSubview:_flag];
        [_flag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self.contentView).offset(-11);
        }];
    }
    return _flag;
}

-(UILabel *)upDate{
    if (!_upDate) {
        _upDate = [[UILabel alloc]init];
        _upDate.textColor = kColor999;
        _upDate.textAlignment = NSTextAlignmentRight;
        _upDate.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_upDate];
        [_upDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
            make.right.equalTo(self).offset(-12);
            make.centerY.equalTo(_deletebtn.mas_centerY);
        }];
    }
    return _upDate;
}

-(UIButton *)lookBtn{
    if (!_lookBtn) {
        _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookBtn setTitle:@"查看预算" forState:UIControlStateNormal];
        _lookBtn.tag = 11;
        [_lookBtn setTitleColor:XWColorFromHex(0x5186aa) forState:UIControlStateNormal];
        [_lookBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_lookBtn];
    }
    return _lookBtn;
}

-(UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setTitle:@"查看修改" forState:UIControlStateNormal];
        _changeBtn.tag = 12;
        [_changeBtn setTitleColor:XWColorFromHex(0x5186aa) forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_changeBtn];
        
        UIView *line = [[UIView alloc]init];
        [line setBackgroundColor:kLineColer];
        [line setAlpha:1];
        [_changeBtn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(1));
            make.height.equalTo(@(25));
            make.centerY.equalTo(@(_changeBtn.height/2));
            make.left.equalTo(_changeBtn);
        }];
    }
    return _changeBtn;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(12, 115, kScreen_Width-24, 1)];
        [self.contentView addSubview:_line];
//        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(1));
//            make.left.equalTo(self.contentView).offset(12);
////            make.right.equalTo(self.contentView).offset(-12);
//            make.width.equalTo(@(self.contentView.width-24));
//            make.bottom.equalTo(_changeBtn.mas_top);
//        }];
    }
    return _line;
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

@end

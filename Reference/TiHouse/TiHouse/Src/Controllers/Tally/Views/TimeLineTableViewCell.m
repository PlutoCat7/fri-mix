//
//  TimeLineTableViewCell.m
//  TiHouse
//
//  Created by gaodong on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TimeLineTableViewCell.h"


@interface TimeLineTableViewCell()

@property (retain, nonatomic) UIView *maskView;

@property (retain, nonatomic) UILabel *Class1;
@property (retain, nonatomic) UILabel *Class2;
@property (retain, nonatomic) UILabel *Price;


@property (retain, nonatomic) UILabel *lblRemark;
@property (retain, nonatomic) UILabel *lblBrand;
@property (retain, nonatomic) UILabel *lblModel;
@property (retain, nonatomic) UILabel *lblAddress;
@property (retain, nonatomic) UILabel *lblPayway;

@end



@implementation TimeLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:kRKBViewControllerBgColor];//kRKBViewControllerBgColor
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.bottomLineStyle = CellLineStyleNone;
        self.showMoney = YES;
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setClass1];
    [self setClass2];
    [self setPrice];
    [self setImg];
    [self setContentList];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



#pragma mark - init subviews
- (void)addSubviews{
    
    //线条
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kLineColer;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(18));
        make.top.and.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1));
    }];
    
    
    //content约束view
    _maskView = [[UIView alloc] initWithFrame:CGRectZero];
    [_maskView setBackgroundColor:[UIColor whiteColor]];
    [_maskView setClipsToBounds:YES];
    [self.contentView addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(1);
        make.left.equalTo(line.mas_right).offset(8);
        make.right.equalTo(self).offset(-8);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    //大类
    if (!_Class1) {
        _Class1 = [[UILabel alloc] init];
        _Class1.text = @"-";
        [_Class1 setFont:[UIFont systemFontOfSize:14]];
        [_maskView addSubview:_Class1];
    }
    
    
    //小类
    if (!_Class2) {
        _Class2 = [[UILabel alloc] init];
        _Class2.text = @"-";
        [_Class2 setFont:[UIFont systemFontOfSize:12]];
        [_Class2 setTextColor:XWColorFromHex(0xbfbfbf)];
        [_maskView addSubview:_Class2];
    }
    
    
    //price
    if (!_Price) {
        
        _Price = [[UILabel alloc] init];
        _Price.text = @"￥6000";
        [_Price setFont:[UIFont systemFontOfSize:18.0f weight:UIFontWeightBold]];
        [_Price setTextColor:XWColorFromHex(0xF5A623)];
        [_maskView addSubview:_Price];
    }
    
    
    //pic
    if (!_Img) {
        _Img = [[UIImageView alloc] initWithFrame:CGRectZero];
        _Img.layer.cornerRadius = 5;
        _Img.contentMode = UIViewContentModeScaleAspectFill;
        [_Img setClipsToBounds:YES];
        [_maskView addSubview:_Img];
    }
    
    //细节list  后期替换成YYLabel
    if (!_lblRemark) {
        _lblRemark = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [_maskView addSubview:_lblRemark];
    }
    if (!_lblBrand) {
        _lblBrand = [[UILabel alloc] initWithFrame:CGRectZero];
        [_maskView addSubview:_lblBrand];
    }
    if (!_lblModel) {
        _lblModel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_maskView addSubview:_lblModel];
    }
    if (!_lblAddress) {
        _lblAddress = [[UILabel alloc] initWithFrame:CGRectZero];
        [_maskView addSubview:_lblAddress];
    }
    if (!_lblPayway) {
        _lblPayway = [[UILabel alloc] initWithFrame:CGRectZero];
        [_maskView addSubview:_lblPayway];
    }
    
}

#pragma mark - update views
- (void)setClass1{
    
    NSArray *textArr = [_tDetail.tallyprocatename componentsSeparatedByString:@"-"];
    
    _Class1.text = [textArr count] > 0 ? textArr[0]:@"无";
    
    CGSize size = [TallyHelper labelSize:_Class1.text font:[UIFont systemFontOfSize:14] height:20];
    [_Class1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_maskView.mas_top).offset(15);
        make.left.equalTo(_maskView.mas_left).offset(10);
        make.width.mas_equalTo(size.width+5);
        make.height.mas_equalTo(size.height);
    }];
    
}

- (void)setClass2{
    if ([_tDetail.catetwoname isEqualToString:@"无"]) {
        _Class2.text = [NSString stringWithFormat:@"-%@", _tDetail.cateonename];
    }else{
        _Class2.text = [NSString stringWithFormat:@"-%@·%@", _tDetail.catetwoname, _tDetail.cateonename];
    }
    
    CGSize size2 = [TallyHelper labelSize:_Class2.text font:[UIFont systemFontOfSize:12] height:20];
    [_Class2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_Class1.mas_bottom);
        make.left.equalTo(_Class1.mas_right);
        make.width.mas_equalTo(size2.width+5);
        make.height.mas_equalTo(size2.height);
    }];
}

- (void)setPrice{
    _Price.text = self.showMoney?[NSString stringWithFormat:@"￥%.0f", _tDetail.doubleamountzj]:@"****";
    
    if (_tDetail.tallyprotype == 1) {
        _Price.textColor = XWColorFromHex(0xfec00c);
    }else{
        _Price.textColor = XWColorFromHex(0x11c354);
    }
    
    CGSize size3 = [TallyHelper labelSize:_Price.text font:[UIFont systemFontOfSize:18.0f] height:30];
    [_Price mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_Class1.mas_bottom);
        make.right.equalTo(_maskView.mas_right).offset(-10);
        make.width.mas_equalTo(size3.width+10);
        make.height.mas_equalTo(size3.height);
    }];
}

- (void)setImg{
    
    [_Img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(33);
        make.right.equalTo(_maskView.mas_right).offset(-10);
        make.top.equalTo(_Price.mas_bottom).offset(10);
    }];
}
- (void)setContentList{
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    if ([_tDetail.tallyproremark length] > 0) {
        NSString *contentRemark = @"";
        if ([_tDetail.tallyproremark length] > 16) {
            contentRemark = [NSString stringWithFormat:@"%@...",[_tDetail.tallyproremark substringToIndex:16]];
        }else{
            contentRemark = _tDetail.tallyproremark;
        }
        NSAttributedString *commentAttr = [self creatAttrStringWithText:contentRemark image:[UIImage imageNamed:@"Tally_add_icon_remark"]];
        _lblRemark.attributedText = commentAttr;
        _lblRemark.lineBreakMode = NSLineBreakByClipping;
        [arr addObject:_lblRemark];
    }else{
        _lblRemark.text = @"";
    }
    if ([_tDetail.tallyprobrand length] > 0) {
        NSAttributedString *commentAttr = [self creatAttrStringWithText:_tDetail.tallyprobrand image:[UIImage imageNamed:@"Tally_add_icon_brand"]];
        _lblBrand.attributedText = commentAttr;
        [arr addObject:_lblBrand];
    }else{
        _lblBrand.text = @"";
    }
    if ([_tDetail.tallyproxh length] > 0) {
        NSAttributedString *commentAttr = [self creatAttrStringWithText:_tDetail.tallyproxh image:[UIImage imageNamed:@"Tally_add_icon_model"]];
        _lblModel.attributedText = commentAttr;
        [arr addObject:_lblModel];
    }else{
        _lblModel.text = @"";
    }
    if ([_tDetail.locationname length] > 0) {
        NSAttributedString *commentAttr = [self creatAttrStringWithText:_tDetail.locationname image:[UIImage imageNamed:@"Tally_add_icon_location"]];
        _lblAddress.attributedText = commentAttr;
        [arr addObject:_lblAddress];
    }else{
        _lblAddress.text = @"";
    }
    if ([_tDetail.paywayname length] > 0) {
        NSAttributedString *commentAttr = [self creatAttrStringWithText:_tDetail.paywayname image:[UIImage imageNamed:@"Tally_add_icon_wallet"]];
        _lblPayway.attributedText = commentAttr;
        [arr addObject:_lblPayway];
    }else{
        _lblPayway.text = @"";
    }
    
    if ([arr count] > 0) {
        float paddingTop = 40;
        for (UILabel *lbl in arr) {
            [lbl setTextColor:XWColorFromHex(0xbfbfbf)];
            [lbl mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(paddingTop);
                make.height.mas_equalTo(15);
                make.left.equalTo(_Class1.mas_left);
                make.right.mas_equalTo(_Img).offset(-30);
            }];
            
            paddingTop += 20;
        }
    }
}

#pragma mark - common
// 实现图文混排的方法
- (NSAttributedString *)creatAttrStringWithText:(NSString *)text image:(UIImage *)image{
    
    // 图片
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    //计算文字padding-top ，使图片垂直居中
    CGFloat textPaddingTop = (16 - 14) / 2;
    attachment.bounds = CGRectMake(0, -textPaddingTop , 12, 12);
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 文字
    NSAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSBaselineOffsetAttributeName:@(1)}];
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    // 将图片、文字拼接
    [mutableAttr appendAttributedString:imageAttr];
    [mutableAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [mutableAttr appendAttributedString:textAttr];
    
    
    return [mutableAttr copy];
}

+ (float)getCellHeightWithDetail:(TallyDetail *)tDetail{
    
    int detailList = 0;
    if ([tDetail.tallyproremark length] > 0) {
        detailList ++;
    }
    if ([tDetail.tallyprobrand length] > 0) {
        detailList ++;
    }
    if ([tDetail.tallyproxh length] > 0) {
        detailList ++;
    }
    if ([tDetail.locationname length] > 0) {
        detailList ++;
    }
    if ([tDetail.paywayname length] > 0) {
        detailList ++;
    }
    
    if ([tDetail.arrurlcert length] == 0) {
        if (detailList < 1){
            return 50;
        } else{
            return 50+20*detailList;
        }
    }else{
        if (detailList <= 2) {
            return 90;
        }else{
            return 50+20*detailList;
        }
    }
    
    
//    if (detailList <= 2 && [tDetail.arrurlcert length] == 0) {
//        return 80;
//    }else if(detailList <= 2 && [tDetail.arrurlcert length] > 0){
//        return 90;
//    }else if(detailList >= 2){
//        return 40+20*detailList+10;
//    }else{
//        return 95;
//    }
    
}

@end

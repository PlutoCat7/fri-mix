//
//  HouesInfoCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/20.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//


#define kHouesInfoCell_PadingTop 20.0
#define kHouesInfoCell_PadingLeft 18.0
#define kHouesInfoCell_PadingRight 10.0
#define kHouesInfoMediaItem_Pading 5.0
#define kHouesInfoMedia_Wtith kScreen_Width - kHouesInfoCell_PadingRight*2 - kHouesInfoCell_PadingLeft
#define kHouesInfo_ContentFont [UIFont systemFontOfSize:16]



#import "HouesInfoCell.h"
#import "UICustomCollectionView.h"
#import "HouerInfoMediaItemCCell.h"
#import "UITTTAttributedLabel.h"
#import "Journal.h"


@interface HouesInfoCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,SDPhotoBrowserDelegate,TTTAttributedLabelDelegate>

@property (nonatomic ,retain) UIView *icon;//时光轴间隔图标
@property (nonatomic ,strong) UILabel *date ,*name, *time;
@property (nonatomic ,retain) UIView *line, *contentV;//时光轴
@property (nonatomic, retain) UIButton *moreBtn;
@property (strong, nonatomic) UICustomCollectionView *mediaView;
@property (nonatomic, retain) UITTTAttributedLabel *contentLabel;
@property (nonatomic, retain) CAReplicatorLayer *replicatorLayer_Circle;




@end

@implementation HouesInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineStyle = CellLineStyleNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubviews];
        
    }
    return self;
}

-(void)addSubviews{
    
    
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = kLineColer;
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kHouesInfoCell_PadingLeft));
            make.top.and.bottom.equalTo(self.contentView);
            make.width.equalTo(@(1));
        }];
    }
    
    if (!_icon) {
        _icon = [[UIView alloc]init];
        _icon.backgroundColor = kRKBViewControllerBgColor;
        [_icon.layer addSublayer:[self replicatorLayer_Circle]];
        [self.contentView addSubview:_icon];
        CALayer *layer = [[CALayer alloc]init];
        layer.backgroundColor = [UIColor orangeColor].CGColor;
        layer.cornerRadius = 2.0;
        layer.frame = CGRectMake(6, 6, 4, 4);
        [_icon.layer addSublayer:layer];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_line.mas_centerX);
            make.top.equalTo(_line);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    
    if (!_date) {
        _date = [[UILabel alloc]init];
        _date.font = [UIFont fontWithName:@"Heiti SC" size:14];
        _date.textColor = kRKBNAVBLACK;
        _date.text = @"10月9日";
        _date.numberOfLines = 1;
        [self.contentView addSubview:_date];
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon.mas_right).offset(4);
            make.centerY.equalTo(_icon.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(160, 30));
        }];
    }
    
    
    if (!_mediaView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _mediaView = [[UICustomCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _mediaView.scrollEnabled = NO;
        [_mediaView setBackgroundView:nil];
        [_mediaView setBackgroundColor:[UIColor clearColor]];
        [_mediaView registerClass:[HouerInfoMediaItemCCell class] forCellWithReuseIdentifier:kCCellIdentifier_HouerInfoMediaItem];
        _mediaView.dataSource = self;
        _mediaView.delegate = self;
        [self.contentView addSubview:_mediaView];
        [_mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_icon.mas_bottom).offset(kHouesInfoCell_PadingRight);
            make.left.equalTo(_line).offset(kHouesInfoCell_PadingRight);
            make.right.equalTo(self.contentView.mas_right).offset(-kHouesInfoCell_PadingRight);
            make.height.equalTo(@(0));
        }];
    }
    
    if (!_contentV) {
        _contentV = [[UIView alloc]init];
        _contentV.backgroundColor = [UIColor whiteColor];
        
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor grayColor];
        _name.font = [UIFont systemFontOfSize:12];
        _name.text = @"Maggie";
        [_contentV addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentV).offset(12);
            make.height.equalTo(@(35));
            make.width.equalTo(@(50));
            make.bottom.equalTo(_contentV);
        }];
        
        _time = [[UILabel alloc]init];
        _time.textColor = [UIColor grayColor];
        _time.font = [UIFont systemFontOfSize:12];
        _time.text = @",5个小时";
        [_contentV addSubview:_time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_name.mas_right).offset(2);
            make.height.equalTo(@(35));
            make.width.equalTo(@(100));
            make.bottom.equalTo(_contentV).offset(1);
        }];
        
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"fa"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
        [_contentV addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_contentV).offset(-12);
            make.centerY.equalTo(_name.mas_centerY);
            make.width.equalTo(@(19));
            make.height.equalTo(@(14));
        }];
        
        [self.contentView addSubview:_contentV];
        [_contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.left.equalTo(_mediaView);
            make.top.equalTo(_mediaView.mas_bottom);
            make.height.equalTo(@(100));
            make.bottom.equalTo(_contentV);
        }];
    }
    
    if (!self.contentLabel) {
        _contentLabel = [[UITTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = kHouesInfo_ContentFont;
        _contentLabel.textColor = kColorDark3;
        _contentLabel.numberOfLines = 0;
        
        _contentLabel.linkAttributes = kLinkAttributes;
        _contentLabel.activeLinkAttributes = kLinkAttributesActive;
        _contentLabel.delegate = self;
        [_contentLabel addLongPressForCopy];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentV);
            make.left.equalTo(_name);
            make.right.equalTo(_moreBtn.mas_left).offset(-10);
            make.height.equalTo(@(0));
        }];
    }
    
}

- (void)setTweet:(Journal *)journal needTopView:(BOOL)needTopView{
    
    _journal = journal;
    
    if (needTopView) {
        [_line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
        }];
    }
    
    [_mediaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(journal.medias.count == 1 ? kScreen_Height*0.5 :
                            (ceilf((float)_journal.medias.count/3)*(kHouesInfoMedia_Wtith-kHouesInfoMediaItem_Pading*2)/3)));
    }];
    [_mediaView reloadData];
    
    [self.contentLabel setLongString:_journal.content withFitWidth:250 maxHeight:200];
    [_contentV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([HouesInfoCell contentLabelHeightWithTweet:journal]+50));
    }];
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([HouesInfoCell contentLabelHeightWithTweet:journal]));
    }];
    
}




+ (CGFloat)cellHeightWithObj:(Journal *)journal needTopView:(BOOL)needTopView{
    
    if (journal.cellHeight == 0) {
        
        CGFloat cellHeight = 0;
        cellHeight += needTopView ? kHouesInfoCell_PadingTop: 0;
        cellHeight += 16.0;
        cellHeight += journal.medias.count == 1 ? kScreen_Height*0.5 :
                                                   ceilf((float)journal.medias.count/3)*((kHouesInfoMedia_Wtith-kHouesInfoMediaItem_Pading*2)/3);
        cellHeight += [self contentLabelHeightWithTweet:journal];
        
        journal.cellHeight = ceilf(cellHeight+80);
        return ceilf(cellHeight+80);
    }
    return journal.cellHeight;
}

+ (CGFloat)contentLabelHeightWithTweet:(Journal *)_journal{
    CGFloat height = 0;
    if (_journal.content.length > 0) {
        height += MIN(200, [_journal.content getHeightWithFont:kHouesInfo_ContentFont constrainedToSize:CGSizeMake(250, CGFLOAT_MAX)]);
        height += 21;
    }
    return height;
}



#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger row = _journal.medias.count;
    return row;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    HouerInfoMediaItemCCell *curMediaItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_HouerInfoMediaItem forIndexPath:indexPath];
    
    return curMediaItem;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize itemSize;
    if (_journal.medias.count == 1) {
        itemSize = CGSizeMake(kHouesInfoMedia_Wtith, kScreen_Height*0.5);
    }else{
        itemSize = CGSizeMake((_mediaView.width-kHouesInfoMediaItem_Pading*2)/3, (_mediaView.width-kHouesInfoMediaItem_Pading*2)/3);
    }
    return itemSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insetForSection;
    insetForSection = UIEdgeInsetsMake(0, 0, 0, 0);
    return insetForSection;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return kHouesInfoMediaItem_Pading;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return kHouesInfoMediaItem_Pading;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = _journal.medias.count;
    photoBrowser.sourceImagesContainerView = _mediaView;
    
    [photoBrowser show];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
//    [_icon.layer addSublayer:[self replicatorLayer_Circle]];
    
}

#pragma mark - private methods 私有方法
-(void)clickMore{
    if (_click) {
        _click();
    }
}

#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    return [UIImage imageNamed:@"placeholderImage"];
    
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
 
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://src.hhz1.cn/pc_officialWeb/images/img_about_0%d.jpg",(arc4random()%6)+1]];
}

+ (CGFloat)cellHeightWithObj{
    
    CGFloat cellHeight = 0;
    cellHeight = [self contentMediaHeight];
    return ceilf(cellHeight + 100);
}

+ (CGFloat)contentMediaHeight{
    CGFloat contentMediaHeight = 16;
    contentMediaHeight = 6/3*((105.6)+5)-5;
    return contentMediaHeight+30;
}

// 圆圈动画 波纹
- (CALayer *)replicatorLayer_Circle{
    
    if (!_replicatorLayer_Circle) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = CGRectMake(0, 0, 16, 16);
        shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 16, 16)].CGPath;
        shapeLayer.fillColor = [UIColor orangeColor].CGColor;
        shapeLayer.opacity = 0.0;
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[[self alphaAnimation],[self scaleAnimation]];
        animationGroup.duration = 2.0;
        animationGroup.autoreverses = NO;
        animationGroup.repeatCount = HUGE;
        [shapeLayer addAnimation:animationGroup forKey:@"animationGroup"];
        
        _replicatorLayer_Circle = [CAReplicatorLayer layer];
        _replicatorLayer_Circle.frame = CGRectMake(0, 0, 16, 16);
        _replicatorLayer_Circle.instanceDelay = 0.5;
        _replicatorLayer_Circle.instanceCount = 4;
        [_replicatorLayer_Circle addSublayer:shapeLayer];
    }
    return _replicatorLayer_Circle;
}

- (CABasicAnimation *)alphaAnimation{
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @(1.0);
    alpha.toValue = @(0.0);
    return alpha;
}

- (CABasicAnimation *)scaleAnimation{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    return scale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

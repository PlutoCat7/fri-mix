//
//  HouesInfoCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/20.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//



#define kMoreTweetCell_DataHight 40.0
#define kMoreTweetCell_PadingLeft 12.0
#define kMoreTweetCell_ImageVPadingBottom 18.0
#define kMoreTweetCellContent_Wtith kScreen_Width - kMoreTweetCell_PadingLeft*2 - 40
#define kMoreTweetCell_ContentFont [UIFont fontWithName:@"Heiti SC" size:14]



#import "HouseMoreTweetTableViewCell.h"
#import "UICustomCollectionView.h"
#import "HouerInfoMediaItemCCell.h"
#import "UITTTAttributedLabel.h"
#import "NSString+Common.h"
#import "NSDate+Common.h"
#import "TOCropViewController.h"

#import "HUPhotoBrowser.h"
#import "UIImageView+HUWebImage.h"
#import "XWDatePhotoPreviewViewController.h"

@interface HouseMoreTweetTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,SDPhotoBrowserDelegate,TTTAttributedLabelDelegate,TOCropViewControllerDelegate>
{
    
    NSInteger row;
}
@property (nonatomic ,strong) UILabel *date ,*content;
@property (nonatomic, retain) UIImageView *icon;
@property (strong, nonatomic) UICustomCollectionView *mediaView;
@property (nonatomic, retain) UITTTAttributedLabel *contentLabel;

@end

@implementation HouseMoreTweetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineStyle = CellLineStyleFill;
        self.topLineStyle = CellLineStyleFill;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
        
    }
    return self;
}

-(void)addSubviews{
    
    if (!_date) {
        _date = [[UILabel alloc]init];
        _date.font = [UIFont fontWithName:@"Heiti SC" size:14];
        _date.textColor = kRKBNAVBLACK;
        _date.numberOfLines = 1;
        [self.contentView addSubview:_date];
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kMoreTweetCell_PadingLeft);
            make.right.equalTo(self.contentView).offset(-kMoreTweetCell_PadingLeft);
            make.top.equalTo(self.contentView);
            make.height.equalTo(@(kMoreTweetCell_DataHight));
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
            make.top.equalTo(_date.mas_bottom);
            make.left.equalTo(self.contentView).offset(kMoreTweetCell_PadingLeft);
            make.right.equalTo(self.contentView).offset(-kMoreTweetCell_PadingLeft);
            make.height.equalTo(@(0));
        }];
    }
    

    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.font = kMoreTweetCell_ContentFont;
        _content.textColor = kRKBNAVBLACK;
        _content.text = @"添加照片说明";
        _content.numberOfLines = 0;
        [self.contentView addSubview:_content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kMoreTweetCell_PadingLeft);
            make.top.equalTo(_mediaView.mas_bottom).offset(kMoreTweetCell_ImageVPadingBottom);
            make.height.equalTo(@(0));
            make.width.equalTo(@(kMoreTweetCellContent_Wtith));
        }];
    }
    
    if (!_icon) {
        UIImage *iamge = [UIImage imageNamed:@"HoseTweet_ instructions"];
        _icon = [[UIImageView alloc]init];
        _icon.image = iamge;
        [self.contentView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-kMoreTweetCell_PadingLeft);
            make.top.equalTo(_mediaView.mas_bottom).offset(kMoreTweetCell_ImageVPadingBottom);
            make.size.mas_equalTo(iamge.size);
        }];
    }

}

//- (void)setTweet:(HouseTweet *)tweet needTopView:(BOOL)needTopView{
//    
//    _tweet = tweet;
//    _date.text = tweet.createData;
//    [_mediaView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(tweet.images.count == 1 ? 235 :
//                            (ceilf((float)tweet.images.count/3)*(_mediaView.width-kMoreTweetCell_PadingLeft*2)/3)));
//    }];
//    [_mediaView reloadData];
//    
//    [_content setLongString:tweet.description withFitWidth:kMoreTweetCellContent_Wtith maxHeight:MAX_CANON];
//    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@([HouseMoreTweetTableViewCell contentLabelHeightWithTweet:tweet.description]));
//    }];
//    _content.text = tweet.description;
//    
//}

-(void)setTweet:(HouseTweet *)tweet{
    _tweet = tweet;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[tweet.createData integerValue] stringDisplay_MMdd];
    _date.text = [[NSDate dateWithTimeIntervalSince1970:[tweet.createData integerValue]/1000] stringDisplay_MMdd];
    [_mediaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(tweet.images.count == 1 ? 235 :
                            ceilf((float)tweet.images.count/3)*((kScreen_Width-kMoreTweetCell_PadingLeft*4)/3)));
    }];
    [_mediaView reloadData];
    
//    [_content setLongString:tweet.description withFitWidth:kMoreTweetCellContent_Wtith maxHeight:MAX_CANON];
    if (tweet.dairydesc.length > 0) {
        [_content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([HouseMoreTweetTableViewCell contentLabelHeightWithTweet:tweet.dairydesc]));
        }];
        _content.text = tweet.dairydesc;
        _content.textColor = [UIColor blackColor];
    }else{
        [_content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(18));
        }];
    }
    
}



+ (CGFloat)cellHeightWithObj:(HouseTweet *)tweet needTopView:(BOOL)needTopView{
    
    CGFloat cellHeight = 0;
    cellHeight += kMoreTweetCell_DataHight;
    cellHeight += tweet.images.count == 1 ? 235 :
                                               ceilf((float)tweet.images.count/3)*((kScreen_Width-kMoreTweetCell_PadingLeft*4)/3);
    cellHeight += kMoreTweetCell_ImageVPadingBottom;
    cellHeight += [self contentLabelHeightWithTweet:tweet.dairydesc];
    cellHeight += 18;
    
    return ceilf(cellHeight);
}

+ (CGFloat)contentLabelHeightWithTweet:(NSString *)journal{
    CGFloat height = 0;
    height += MIN(500, [journal getHeightWithFont:kMoreTweetCell_ContentFont constrainedToSize:CGSizeMake(kMoreTweetCellContent_Wtith, 500)]);
    return height < 18 ? 18 :height;
}



#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger row = _tweet.images.count;
    return row > 9 ? 9 : row;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    HouerInfoMediaItemCCell *curMediaItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_HouerInfoMediaItem forIndexPath:indexPath];
    TweetImage *imageModel = _tweet.images[indexPath.row];
    curMediaItem.imageV.image = imageModel.image;
    if (indexPath.row == 8 && _tweet.images.count > 9) {
        curMediaItem.shade.hidden = NO;
        [curMediaItem.UnImaCount setTitle:[NSString stringWithFormat:@"+%ld",_tweet.images.count - 9] forState:UIControlStateNormal];
    }
    curMediaItem.vidoImage.hidden = YES;
    
    return curMediaItem;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize itemSize;
    if (_tweet.images.count == 1) {
        itemSize = CGSizeMake(_mediaView.width, 235);
    }else{
        itemSize = CGSizeMake((_mediaView.width-kMoreTweetCell_PadingLeft*2)/3, (_mediaView.width-kMoreTweetCell_PadingLeft*2)/3);
    }
    return itemSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insetForSection;
    insetForSection = UIEdgeInsetsMake(0, 0, 0, 0);
    return insetForSection;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return kMoreTweetCell_PadingLeft;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return kMoreTweetCell_PadingLeft;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
  row = indexPath.row;
  HUPhotoBrowser* photo = [HUPhotoBrowser showCollectionView:collectionView withImages:_tweet.images placeholderImage:_tweet.images[indexPath.row] atIndex:indexPath.row Animation:YES dismiss:^(UIImage *image, NSInteger index) {

    }];
    photo.edit = ^(UIImage *image, NSInteger index) {
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:image];
        cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
        cropController.aspectRatioLockEnabled= YES;
        cropController.resetAspectRatioEnabled = NO;
        cropController.delegate = self;
        cropController.doneButtonTitle = @"完成";
        cropController.cancelButtonTitle = @"取消";
        [_controller.navigationController pushViewController:cropController animated:NO];
    };
    photo.dismiss = ^{
        [_mediaView reloadData];
        if (_deletePhotoCallback) {
            _deletePhotoCallback();
        }
    };

}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
    TweetImage *imagemodel = _tweet.images[row];
    imagemodel.image = image;
    [cropViewController.navigationController popViewControllerAnimated:NO];
    
    HUPhotoBrowser* photo = [HUPhotoBrowser showCollectionView:_mediaView withImages:_tweet.images placeholderImage:_tweet.images[row] atIndex:row Animation:NO dismiss:^(UIImage *image, NSInteger index) {
        
    }];
    photo.edit = ^(UIImage *image, NSInteger index) {
        
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:image];
        cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        //                    if (self.manager.configuration.movableCropBox) {
        //                        cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        //                    }else{
        //                        cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPreset3x2;
        //                    }
        
        cropController.aspectRatioLockEnabled= YES;
        cropController.resetAspectRatioEnabled = NO;
        cropController.delegate = self;
        cropController.doneButtonTitle = @"完成";
        cropController.cancelButtonTitle = @"取消";
        [_controller.navigationController pushViewController:cropController animated:NO];
    };
    
    return;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    
//    [_icon.layer addSublayer:[self replicatorLayer_Circle]];
    
}

#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    TweetImage * imageModel =_tweet.images[index];
    return imageModel.image;
}


// 返回高质量图片的url
//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
//{
//
//    return [NSURL URLWithString:[NSString stringWithFormat:@"http://src.hhz1.cn/pc_officialWeb/images/img_about_0%d.jpg",(arc4random()%6)+1]];
//}

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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

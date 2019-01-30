//
//  HouseChangeHeaderView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//
#define kCCellIdentifier_TweetSendImage @"TweetSendImageCCell"
#define ITEMWITH (kScreen_Width-kRKBWIDTH(10*5))/4

#import "HouseChangeHeaderView.h"
#import "HouseChangeImageCell.h"
#import "HXDatePhotoToolManager.h"
#import "HouseTweet.h"
#import "HXPhotoPicker.h"
#import "HUPhotoBrowser.h"
#import "TOCropViewController.h"

@interface HouseChangeHeaderView()<HXPhotoViewDelegate,HXAlbumListViewControllerDelegate,HXCustomCameraViewControllerDelegate,TOCropViewControllerDelegate,SDPhotoBrowserDelegate>
{
    
    NSInteger row;
}
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIView *bottomLine;

@end

@implementation HouseChangeHeaderView

-(instancetype)initWihtManager:(HXPhotoManager *)manager{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _manager = manager;
        [self TextView];
        [self mediaView];
//                HXPhotoView *photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(10, 135, kScreen_Width - 10 * 2, 0) manager:manager];
//                photoView.delegate = self;
//                photoView.backgroundColor = [UIColor whiteColor];
//                photoView.lineCount = 4;
//                photoView.spacing = 10;
//                [photoView refreshView];
//                [self addSubview:photoView];
//                self.photoView = photoView;
        self.layer.masksToBounds = YES;
        
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.height = 0.5f;
        [_bottomLine setBackgroundColor:kLineColer];
        [_bottomLine setAlpha:1];
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0.5));
            make.left.right.bottom.equalTo(self);
        }];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_manager.type == HXPhotoManagerSelectedTypeVideo) {
        return 1;
    }
    
    NSInteger num = _tweet.images.count;
    if (num < 20) {
//        return _isEditing ? num : num +1;
        return num +1;
    }
    return num;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (_isEditing) {
//        _TextView.editable = NO;
//        _TextView.textColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
//    }
    HouseChangeImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_TweetSendImage forIndexPath:indexPath];
    
    if (_manager.type == HXPhotoManagerSelectedTypeVideo) {
        TweetImage *image = _tweet.images[indexPath.row];
        if (image.image) {
            cell.imageV.image = image.image;
        } else {
            cell.imageV.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:[_tweet.dairy.dairy.fileJA[indexPath.row] fileurlsmall]];;
        }
        cell.vidoImage.hidden = NO;
        return cell;
    }
    
    cell.vidoImage.hidden = YES;
    if (indexPath.row < _tweet.images.count) {
        TweetImage *image = _tweet.images[indexPath.row];
        cell.imageV.image = image.image;
    }else if(indexPath.row == 20){
        TweetImage *image = _tweet.images[indexPath.row];
        cell.imageV.image = image.image;
    }else{
        cell.imageV.image = [UIImage imageNamed:@"pic_add@2x.png"];
    }
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ITEMWITH, ITEMWITH);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kRKBWIDTH(10), kRKBWIDTH(10), kRKBWIDTH(10));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kRKBWIDTH(10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kRKBWIDTH(10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _tweet.images.count) {
//        if (_isEditing) {
//            [NSObject showHudTipStr:@"编辑状态下不能增加图片"];
//            return;
//        }
        _manager.configuration.photoMaxNum = 20 - _tweet.images.count;
        [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
        return;
    }
    
    if (_manager.type == HXPhotoManagerSelectedTypeVideo) {
        if (_videoClick) {
            _videoClick();
        }
        return;
    }
    
    
    row = indexPath.row;
    HUPhotoBrowser* photo;
    
/*
    if (_isEditing) {
        photo = [HUPhotoBrowser showMoveCollectionView:collectionView withImages:_tweet.images placeholderImage:_tweet.images[indexPath.row] atIndex:indexPath.row Animation:YES dismiss:^(UIImage *image, NSInteger index) {
            
        }];
    } else {
        photo = [HUPhotoBrowser showCollectionView:collectionView withImages:_tweet.images placeholderImage:_tweet.images[indexPath.row] atIndex:indexPath.row Animation:YES dismiss:^(UIImage *image, NSInteger index) {
            
        }];
    }
 */
    photo = [HUPhotoBrowser showCollectionView:collectionView withImages:_tweet.images placeholderImage:_tweet.images[indexPath.row] atIndex:indexPath.row Animation:YES dismiss:^(UIImage *image, NSInteger index) {
        
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
        NSMutableArray *dateArray = [[NSMutableArray alloc] init];
        for (TweetImage *image in _tweet.images) {
            if (image.beforeModel.creationDate) {
                [dateArray addObject:image.beforeModel.creationDate];
            }
        }
        [dateArray sortUsingComparator:^NSComparisonResult(id dateObj1,id dateObj2) {
            NSDate *date1=dateObj1;
            NSDate *date2=dateObj2;
            return [date2 compare:date1];
        }];
        if (dateArray.count) {
//            self.tweet.createData = [NSString stringWithFormat:@"%ld", (long)([[dateArray[0] creationDate] timeIntervalSince1970]*1000)] ;
            self.tweet.createData = [NSString stringWithFormat:@"%ld", (long)([dateArray[0] timeIntervalSince1970]*1000)] ;
        } else {
            self.tweet.createData = nil;
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
#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    TweetImage * imageModel =_tweet.images[index];
    return imageModel.image;
}

-(void)setTweet:(HouseTweet *)tweet{
    _tweet = tweet;
    if (!_tweet.images) {
        _tweet.images = [NSMutableArray new];
    }
    _mediaView.height = (_tweet.images.count+1)/4*(ITEMWITH + kRKBHEIGHT(10)) + ((_tweet.images.count+1)%4?ITEMWITH : 0);
}

-(UITextView *)TextView{
    if (!_TextView) {
        _TextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 18, kScreen_Width-30, 110)];
        _TextView.delegate = self;
        _TextView.text = @"你的家今天有什么不一样......对家有了新想法？";
        _TextView.font = [UIFont systemFontOfSize:14];
        _TextView.textColor = kRKBNOTELABELCOLOR;
        [self addSubview:_TextView];
    }
    return _TextView;
}

#pragma mark - UITextFieldDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"你的家今天有什么不一样......对家有了新想法？"]) {
        textView.text = @"";
        textView.textColor = kRKBHomeBlackColor;
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if (_TextViewEditing) {
        _TextViewEditing(textView.text);
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    textView.textColor = [UIColor blackColor];
}

#pragma mark - UITextFieldDelegate
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    //    ceilf((float)_tweet.images.count/4)*(self.width-10*3)/4
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"你的家今天有什么不一样......对家有了新想法？";
        textView.textColor = kRKBNOTELABELCOLOR;
    }
}

-(void)setContent:(NSString *)content{
    _TextView.text = content;
    if (![content isEqualToString:@"你的家今天有什么不一样......对家有了新想法？"]) {
        _TextView.textColor = [UIColor blackColor];
    }
}

-(UICollectionView *)mediaView{
    if (!_mediaView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _mediaView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_TextView.frame), kScreen_Width, ITEMWITH + kRKBHEIGHT(10)) collectionViewLayout:layout];
        _mediaView.backgroundColor = [UIColor whiteColor];
        _mediaView.scrollEnabled = NO;
        [_mediaView setBackgroundView:nil];
        [_mediaView setBackgroundColor:[UIColor clearColor]];
        [_mediaView registerClass:[HouseChangeImageCell class] forCellWithReuseIdentifier:kCCellIdentifier_TweetSendImage];
        _mediaView.dataSource = self;
        _mediaView.delegate = self;
        [self addSubview:_mediaView];
    }
    return _mediaView;
}


- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original{
    WEAKSELF
    NSLog(@"original %i", original);
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    [photoList enumerateObjectsUsingBlock:^(HXPhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dateArray addObject:obj.creationDate];
        if (dateArray.count == photoList.count) {
            [dateArray sortUsingComparator:^NSComparisonResult(id dateObj1,id dateObj2) {
                NSDate *date1=dateObj1;
                NSDate *date2=dateObj2;
                return [date2 compare:date1];
            }];
        }
        PHAsset *asset = obj.asset;
        if (asset) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            // 同步获得图片, 只会返回1张图片
            options.synchronous = YES;
            CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                TweetImage *image = [TweetImage tweetImageWithAsset:obj.asset];
                image.image = original ? result : [result zipCompress:0.1];
                image.beforeModel = obj;
                image.creationDate = obj.creationDate;
                weakSelf.tweet.createData = [NSString stringWithFormat:@"%ld", (long)([dateArray[0] timeIntervalSince1970]*1000)];
                //                    [NSString stringWithFormat:@"%ld", (long)([lastDate timeIntervalSince1970]*1000)]
                [weakSelf.tweet.images addObject:image];
            }];
        }else{
            TweetImage *image = [TweetImage tweetImageWithAsset:obj.asset];
            image.image = obj.previewPhoto;
            image.beforeModel = obj;
            image.creationDate = obj.creationDate;
            weakSelf.tweet.createData = [NSString stringWithFormat:@"%ld", (long)([dateArray[0] timeIntervalSince1970]*1000)];
            [weakSelf.tweet.images addObject:image];
        }
//        TweetImage *image = [TweetImage tweetImageWithAsset:obj.asset];
////        image.image = obj.thumbPhoto;
//        image.beforeModel = obj;
//        [weakSelf.tweet.images addObject:image];
    }];
    
    _mediaView.height = (_tweet.images.count+1)/4*(ITEMWITH + kRKBHEIGHT(10)) + ((_tweet.images.count+1)%4?ITEMWITH : 0);
    [_mediaView reloadData];
    [self.manager clearSelectedList];
    if (self.UPHeaderViewHeight) {
        self.UPHeaderViewHeight(CGRectGetMaxY(_mediaView.frame));
    }
    if (self.SelectedImages) {
        self.SelectedImages(_tweet.images);
    }
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    //    NSSLog(@"%@",NSStringFromCGRect(frame));
    //    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    if (_HeightBlcok) {
        _HeightBlcok(self, CGRectGetMaxY(frame)+10);
    }
}

@end


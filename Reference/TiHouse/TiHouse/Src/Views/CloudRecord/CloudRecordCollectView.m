//
//  CloudRecordCollectView.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CloudRecordCollectView.h"
#import "CloudRecordCollectCell.h"
#import "CloudReFileListModel.h"
#import "CloudReListCountModel.h"
#import "Login.h"
#import "House.h"
#import "CloudReCollectItemModel.h"
#import "NSDate+Extend.h"
#import "HXPhotoPicker.h"
#import "PreviewVC.h"
#import "CloudRecordCollectHeadView.h"
#import "TweetDetailsViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "SDPhotoBrowser.h"
#import "SHValue.h"

static NSString * cellID = @"CloudRecordCollectCell";
static NSString * cellHeadID = @"CloudRecordCollectCellHead";

@interface CloudRecordCollectView ()<HXPhotoViewDelegate,HXDatePhotoPreviewViewControllerDelegate,PreviewVCDelegate, SDPhotoBrowserDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, SDPhotoBrowserDelegate> {
    
    long _houseID;
    long _folderID;
    CloudRecordType _type;
    NSString * _monthStr;
}
@property (weak, nonatomic) IBOutlet UICollectionView *colloctionView;

@property (strong, nonatomic) HXPhotoManager *manager;

//data
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) NSMutableArray * monthSectionArray;
@property (strong, nonatomic) NSMutableArray * rowArray;
@property (strong, nonatomic) NSMutableArray * HXPhotoModelArray;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray * tarray;

@property (nonatomic, strong) Dairy *dairy;
@property (strong, nonatomic) NSIndexPath *selectIndexPath;

@end

@implementation CloudRecordCollectView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel withHouseID:(long)houseID withFolderID:(long)folderID withType:(CloudRecordType )type withMonthStr:(NSString *)monthStr {
    CloudRecordCollectView * cloudRecordCollectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    cloudRecordCollectView->_houseID = houseID;
    cloudRecordCollectView->_folderID = folderID;
    cloudRecordCollectView->_type = type;
    cloudRecordCollectView->_monthStr = monthStr;
    
    [cloudRecordCollectView xl_setupViews];
    [cloudRecordCollectView xl_bindViewModel];
    
    return cloudRecordCollectView;
}

-(void)xl_setupViews {
    
    //cell register
    [self.colloctionView registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellID];
    [self.colloctionView registerClass:[CloudRecordCollectHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellHeadID];
    
    //self.colloctionView.backgroundColor = [UIColor redColor];
    if (@available(iOS 11.0, *)) {
        self.colloctionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //init
    self.monthSectionArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    self.rowArray = [[NSMutableArray alloc] init];
    self.HXPhotoModelArray = [[NSMutableArray alloc] init];
    self.index = 0;
    self.colloctionView.emptyDataSetSource = self;
    self.colloctionView.emptyDataSetDelegate = self;
    
    [self addFooterRefresh];
}

-(void)addFooterRefresh {
    
    WS(weakSelf);
    self.colloctionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakSelf.index += 20;
        [weakSelf xl_bindViewModel];
        
    }];
}

-(void)xl_bindViewModel {
    
    NSString * path = nil;
    NSDictionary * params = nil;
    User *user = [Login curLoginUser];
    if (_type == CloudRecordFolder) {
        //文件
        path = @"/api/inter/file/pageByHouseidFolder";
        params = @{@"start":@(self.index), @"limit":@(20), @"houseid":@(_houseID), @"uid":@(user.uid),@"folderid":@(_folderID)};
        
    } else if (_type == CloudRecordMonth) {
        //月份
        path = @"/api/inter/file/pageByHouseidMonth";
        params = @{@"start":@(self.index), @"limit":@(20), @"houseid":@(_houseID), @"uid":@(user.uid), @"month":_monthStr};
        
    } else {
        if (_type == CloudRecordPhoto) {
            //图片
            path = @"/api/inter/file/pageByHouseidPic";
            
        } else if (_type == CloudRecordVideo) {
            //视频
            path = @"/api/inter/file/pageByHouseidVideo";
            
        } else if (_type == CloudRecordCollect) {
            //收藏
            path = @"/api/inter/file/pageByHouseidCollect";
            
        } else if (_type == CloudRecordRecent) {
            //最近上传
            path = @"/api/inter/file/pageByHouseidOnemonth";
        }
        params = @{@"start":@(self.index), @"limit":@(20), @"houseid":@(_houseID), @"uid":@(user.uid)};
    }
    
    WEAKSELF;
    [self beginLoading];
    [[TiHouse_NetAPIManager sharedManager] request_cloudRecordCollectsWithPath:path withParams:params Block:^(id data, NSError *error) {
        
        NSArray * resModelArray = data;
        if (resModelArray) {
            
            if (weakSelf.index == 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            
            for (CloudReCollectItemModel * model in resModelArray) {
                model.time = [weakSelf getyyyy_mm_dd:model.dairytime];
                [weakSelf.dataArray addObject:model];
            }
            
            //倒叙展示
//            NSMutableArray * sortArray = [[NSMutableArray alloc] init];
//            for (NSInteger i = weakSelf.dataArray.count - 1; i >= 0; i--) {
//                [sortArray addObject:weakSelf.dataArray[i]];
//            }
//            [weakSelf.dataArray removeAllObjects];
//            [weakSelf.dataArray addObjectsFromArray:sortArray];
            
            //添加section 和 row
            [weakSelf.rowArray removeAllObjects];
            [weakSelf.HXPhotoModelArray removeAllObjects];
            [weakSelf.monthSectionArray removeAllObjects];
            
            //获取有多少个section
            for (int i = 0; i < weakSelf.dataArray.count; i++) {
                CloudReCollectItemModel * model = weakSelf.dataArray[i];
                if (i == 0) {
                    [weakSelf.monthSectionArray addObject:model.time];
                } else {
                    if (![weakSelf.monthSectionArray containsObject:model.time]) {
                        [weakSelf.monthSectionArray addObject:model.time];
                    }
                }
            }
            
            //将错误的时间进行正确的排序
            NSArray * sortSectionArray = [weakSelf.monthSectionArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSDate * date1 = [NSDate dateWithString:obj1 format:@"yyyy-MM-dd"];
                NSDate * date2 = [NSDate dateWithString:obj2 format:@"yyyy-MM-dd"];
                return [date2 compare:date1];
            }];
            [weakSelf.monthSectionArray removeAllObjects];
            [weakSelf.monthSectionArray addObjectsFromArray:sortSectionArray];

            //根据section添加row数组数据
            for (int i = 0; i < weakSelf.monthSectionArray.count; i++) {
                NSMutableArray * array = [[NSMutableArray alloc] init];
                NSMutableArray * hxArray = [[NSMutableArray alloc] init];
                NSString * time = weakSelf.monthSectionArray[i];
                
                for (int i = 0; i < weakSelf.dataArray.count; i++) {
                    CloudReCollectItemModel * model = weakSelf.dataArray[i];
                    if ([time isEqualToString:model.time]) {
                        [array addObject:model];
                        
                        if (model.typefile == 1) {
                            //图片
                            HXPhotoModel * HXModel = [[HXPhotoModel alloc] init];
                            HXModel.type = HXPhotoModelMediaTypePhoto;
                            HXModel.networkPhotoUrl = [NSURL URLWithString:model.urlfile];
                            HXModel.subType = HXPhotoModelMediaSubTypePhoto;
                            HXModel.thumbPhoto = [HXPhotoTools hx_imageNamed:@"qz_photolist_picture_fail@2x.png"];
                            HXModel.previewPhoto = HXModel.thumbPhoto;
                            HXModel.imageSize = HXModel.thumbPhoto.size;
                            [hxArray addObject:HXModel];
                            
                        } else {
                            //视频
                            HXPhotoModel * videoModel = [[HXPhotoModel alloc] init];
                            videoModel.type = HXPhotoModelMediaTypeVideo;
                            videoModel.videoURL = [NSURL URLWithString:model.urlfile];//[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.urlfile,@"?avvod/m3u8"]];
                            videoModel.networkPhotoUrl = [NSURL URLWithString:model.urlfilesmall];
                            videoModel.subType = HXPhotoModelMediaSubTypeVideo;
                            videoModel.thumbPhoto = [HXPhotoTools hx_imageNamed:@"qz_photolist_picture_fail@2x.png"];
                            videoModel.previewPhoto = videoModel.thumbPhoto;
                            videoModel.imageSize = videoModel.thumbPhoto.size;
                            [hxArray addObject:videoModel];
                        }
                    }
                }
                [weakSelf.rowArray addObject:array];
                [weakSelf.HXPhotoModelArray addObject:hxArray];
            }
            
            [weakSelf.colloctionView reloadData];
        }
        
        [weakSelf endLoading];
        [weakSelf.colloctionView.mj_footer endRefreshing];
        if (resModelArray.count < 20) {
            [weakSelf.colloctionView.mj_footer setHidden:YES];
            [weakSelf.colloctionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.colloctionView.mj_footer setHidden:NO];
            [weakSelf.colloctionView.mj_footer resetNoMoreData];
        }
    }];
}

-(NSString *)getyyyy_mm_dd:(long)time {
    NSDate * date = [NSDate dateFromTimestamp:(time / 1000)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString * reusltDate = [formatter stringFromDate:date];
    return reusltDate;
}

#pragma mark - refresh head and foot

#pragma mark - UICollectionView Delegate & datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.monthSectionArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray * array = self.rowArray[section];
    return array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CloudRecordCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    NSArray * array = self.rowArray[indexPath.section];
    CloudReCollectItemModel * model = array[indexPath.row];
    
    if (model.typefile == 1) {
        //图片
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.urlfile] placeholderImage:nil];
        [cell.backgroudView setHidden:YES];
        [cell.movieIconImg setHidden:YES];
        [cell.timeLabel setHidden:YES];
    } else {
        //视频
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.urlfilesmall] placeholderImage:nil];
        [cell.backgroudView setHidden:NO];
        [cell.movieIconImg setHidden:NO];
        [cell.timeLabel setHidden:NO];
        if (model.fileseconds < 60) {
                cell.timeLabel.text = [NSString stringWithFormat:@"0:%02ld", model.fileseconds];
        } else {
            cell.timeLabel.text = [NSString stringWithFormat:@"%ld:%02ld", model.fileseconds / 60, model.fileseconds % 60];
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((kScreen_Width - 25) / 4, (kScreen_Width - 25) / 4);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        CloudRecordCollectHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cellHeadID forIndexPath:indexPath];
        NSString * time = self.monthSectionArray[indexPath.section];
        headerView.titleLabel.text = time;
        
        return headerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreen_Width, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.HXPhotoModelArray.count <= 0 || self.rowArray.count <= 0) return;
    
    NSArray * array = self.rowArray[indexPath.section];
    CloudReCollectItemModel * selectModel = array[indexPath.row];
    if (selectModel.dairytype == 1) {
        TweetDetailsViewController *vc = [[TweetDetailsViewController alloc] init];
        vc.dairyid = selectModel.dairyid;
        House *house = [[House alloc] init];
        house.houseid = selectModel.houseid;
        house.housename = selectModel.housename;
        vc.house = house;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    self.selectIndexPath = indexPath;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = collectionView;
    browser.imageCount = [(NSArray *)(self.rowArray[indexPath.section]) count];
    browser.currentImageIndex = indexPath.row;
    browser.currentImageSection = indexPath.section;
    browser.showCommentButton = YES;
    browser.delegate = self;
    @weakify(browser)
    browser.showCommentBlock = ^(TweetDetailsViewController *detailVC) {
        [browser_weak_ setHidden:YES];
        [self.viewController.navigationController pushViewController:detailVC animated:YES];
    };
    CloudReCollectItemModel *model = [SHValue value:self.rowArray][indexPath.section][indexPath.row].value;
    browser.cloudReCollectItem = model;
    if (model.dairytype == 3) browser.isVideo = YES;
    [browser show];
    return;
    
    
    /* 旧浏览大图组件实现 */
    if (self.HXPhotoModelArray.count <= 0 || self.rowArray.count <= 0) {
        return;
    }

    NSInteger index = 0;
    NSMutableArray * hxArray = [[NSMutableArray alloc] init];
    NSMutableArray * itemArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.HXPhotoModelArray.count; i++) {
        NSArray * hxSubArray = self.HXPhotoModelArray[i];
        NSArray * itemSubArray = self.rowArray[i];
        
        for (int j = 0; j < hxSubArray.count; j ++) {
            HXPhotoModel * HXmodel = hxSubArray[j];
            CloudReCollectItemModel * itemModel = itemSubArray[j];
            
            if (selectModel.fileid == itemModel.fileid) {
                index = itemArray.count;
            }
            
            [hxArray addObject:HXmodel];
            [itemArray addObject:itemModel];
        }
    }
    
    
    PreviewVC *vc = [[PreviewVC alloc] init];
    vc.cloudReCollectItemArray = itemArray;
    vc.modelArray = hxArray;
    vc.manager = self.manager;
    vc.delegate = self;
    vc.currentModelIndex = index;
    WEAKSELF;
    vc.backRefreshBlock = ^{
        [weakSelf xl_bindViewModel];
    };
//    self.viewController.navigationController.delegate = vc;
//    [self.viewController presentViewController:vc animated:YES completion:nil];
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
//    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
//    if (selectModel.dairytype == 3) {
//        photoBrowser.isVideo = YES;
//    }
//    photoBrowser.delegate = self;
//    photoBrowser.browserType = PhotoBrowserTyoeTyoeTimerShaft;
//    photoBrowser.currentImageIndex = index;
//    photoBrowser.imageCount = itemArray.count;
//    photoBrowser.sourceImagesContainerView = _colloctionView;
////    photoBrowser.dairy = _dairy;
//    [photoBrowser show];
    
}

//// 返回临时占位图片（即原来的小图）
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
//{
//    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
//    CloudRecordCollectCell *curMediaItem = (CloudRecordCollectCell *)[_colloctionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//    return curMediaItem.imgView.image;
//
//}


// MARK: - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {

    // 现在使用原实现，待修改
    CloudRecordCollectCell *curMediaItem = (CloudRecordCollectCell *)[_colloctionView cellForItemAtIndexPath:self.selectIndexPath];
    return curMediaItem.imgView.image;
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    HXPhotoModel *model = [SHValue value:self.HXPhotoModelArray][self.selectIndexPath.section][index].value;
    if (model.type == HXPhotoModelMediaTypeVideo) return model.videoURL;
    return model.networkPhotoUrl;
}



- (HXDatePhotoViewCell *)currentPreviewCell:(HXPhotoModel *)model {
    
    NSInteger section = 0;
    NSInteger row = 0;
    BOOL isHave = NO;
    for (int i = 0; i < self.HXPhotoModelArray.count; i++) {
        NSArray * array = self.HXPhotoModelArray[i];
        
        if (model && [array containsObject:model]) {
            section = i;
            row = [array indexOfObject:model];
            isHave = YES;
        }
    }
    if (!isHave) {
        return nil;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
    return (HXDatePhotoViewCell *)[self.colloctionView cellForItemAtIndexPath:indexPath];
}

#pragma mark - HXAlbumListViewControllerDelegate

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    
}

#pragma mark - HXCustomCameraViewControllerDelegate

-(void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model {
    
}

#pragma mark - get fun

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.openCamera = YES;
//        _manager.configuration.photoMaxNum = 9;
//        _manager.configuration.videoMaxNum = 9;
//        _manager.configuration.maxNum = 18;
        
        _manager.configuration.photoMaxNum = 20;
        _manager.configuration.videoMaxNum = 9;
        _manager.configuration.maxNum = 29;
        
        _manager.configuration.statusBarStyle = UIStatusBarStyleBlackTranslucent;
    }
    return _manager;
}

#pragma mark - DZNEmptyDataSetSource

///是否显示没有数据界面
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"暂无相关内容";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:RGB(191, 191, 191),
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end

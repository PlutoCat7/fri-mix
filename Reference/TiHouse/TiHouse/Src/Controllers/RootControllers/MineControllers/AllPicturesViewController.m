    //
//  AllPicturesViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AllPicturesViewController.h"
#import "Login.h"
#import "AssemarcFile.h"
#import "PictureCollectionViewCell.h"
#import "AllPictureView.h"
#import "UIView+Common.h"
#import "MoveToSubSoulFolderController.h"
#import "PBViewController.h"

#define Item_Size (kScreen_Width-kRKBWIDTH(40))/3.0
#define K_Footer_Height 60 // 底部高度

@interface AllPicturesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, PictureCollectionViewCellDelegate, AllPictureViewDelegate, PBViewControllerDelegate, PBViewControllerDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) AllPictureView *allPicturesView;
@property (nonatomic, strong) NSMutableSet<AssemarcFile *> *selectedItems;
@property (nonatomic, strong) NSMutableArray *imageURLs;

@end

@implementation AllPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(choose:)];
    [self.collectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    _imageURLs = [[NSMutableArray alloc] init];
    [self getAllPhotos];
}

- (void)getAllPhotos {
    
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/assemarcfilecoll/listByUid" withParams:@{@"uid": [NSNumber numberWithLong:[[Login curLoginUser] uid]]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            for (NSDictionary *dic in data[@"data"]) {
                AssemarcFile *af = [AssemarcFile mj_objectWithKeyValues:dic];
                [self.dataArray addObject:af];
                [_imageURLs addObject:af.assemarcfileurl];
            }
            
            [self.collectionView reloadData];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = kRKBWIDTH(5);
        flowLayout.sectionInset = UIEdgeInsetsMake(kRKBHEIGHT(10), kRKBWIDTH(10), kRKBHEIGHT(50), kRKBWIDTH(10));
        flowLayout.itemSize = CGSizeMake(Item_Size, Item_Size);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(kNavigationBarHeight));
            make.left.right.bottom.equalTo(self.view);
        }];
        _collectionView.backgroundColor = kRKBViewControllerBgColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (AllPictureView *)allPicturesView {
    if (!_allPicturesView) {
        _allPicturesView = [[AllPictureView alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, K_Footer_Height)];
        [self.view addSubview:_allPicturesView];
        [_allPicturesView addLineUp:YES andDown:NO];
        _allPicturesView.delegate = self;
    }
    return _allPicturesView;
}

- (NSMutableSet<AssemarcFile *> *)selectedItems {
    if (!_selectedItems) {
        _selectedItems = [[NSMutableSet alloc] init];
    }
    return _selectedItems;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.assemarcFile = self.dataArray[indexPath.row];
    cell.delegate = self;
    [cell changeSelectStatus:[self.navigationItem.rightBarButtonItem.title isEqualToString:@"取消"]];
    cell.selectBtn.selected = [_selectedItems containsObject:self.dataArray[indexPath.row]];
    cell.selectMaskLayer.hidden = ![_selectedItems containsObject:self.dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.item inSection:0]];
    PBViewController *pbViewController = [PBViewController new];
    pbViewController.pb_delegate = self;
    pbViewController.pb_dataSource = self;
    pbViewController.startPage = indexPath.row;
    [self presentViewController:pbViewController animated:YES completion:nil];
}

#pragma mark - private method

- (void)choose:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"选择"]) {
        [sender setTitle:@"取消"];
        // 左边修改为全选
        [self showAllPicturesEditView:YES];
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(chooseAll:)];

    } else {
        [sender setTitle:@"选择"];
        [self showAllPicturesEditView:NO];
        [self cancelChoosedStatus]; // 取消所有的选中状态
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = NO;
    }
    [_collectionView reloadData];
}

- (void)chooseAll:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"全选"]) {
        for (NSInteger i = 0; i < _dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
            cell.selectBtn.selected = YES;
            cell.selectMaskLayer.hidden = NO;
        }
        [self.selectedItems addObjectsFromArray:self.dataArray];
        [self.allPicturesView reloadSelectedPictures:self.selectedItems.count];
        sender.title = @"取消全选";
    } else {
        sender.title = @"全选";
        [self cancelChoosedStatus];
    }
}

- (void)showAllPicturesEditView:(BOOL)b {
    if (b) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.allPicturesView.frame;
            frame.origin.y -= K_Footer_Height;
            self.allPicturesView.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.allPicturesView.frame;
            frame.origin.y += K_Footer_Height;
            self.allPicturesView.frame = frame;
        }];
    }
}

- (void)cancelChoosedStatus {
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        cell.selectBtn.selected = NO;
        cell.selectMaskLayer.hidden = YES;
    }
    [self.selectedItems removeAllObjects];
    [self.allPicturesView reloadSelectedPictures:self.selectedItems.count];
}

#pragma mark - PictureCollectionViewCellDelegate
- (void)datePhotoViewCell:(PictureCollectionViewCell *)cell didSelectBtn:(UIButton *)selectBtn {
    if (selectBtn.selected) {
        cell.selectMaskLayer.hidden = YES;
        selectBtn.selected = NO;
        [self.selectedItems removeObject:cell.assemarcFile];
    }else {
        cell.selectMaskLayer.hidden = NO;
        selectBtn.selected = YES;

        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        anim.duration = 0.25;
        anim.values = @[@(1.2),@(0.8),@(1.1),@(0.9),@(1.0)];
        [selectBtn.layer addAnimation:anim forKey:@""];
        [self.selectedItems addObject:cell.assemarcFile];
    }
    [self.allPicturesView reloadSelectedPictures:self.selectedItems.count];
}

#pragma mark - AllPictureViewDelegate
- (void)AddToSoulFolder {
    MoveToSubSoulFolderController *moveVC = [[MoveToSubSoulFolderController alloc] init];
    moveVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    moveVC.soulFoldersArray = _soulFolderList;
    moveVC.selectedItems = self.selectedItems;
    [self presentViewController:moveVC animated:YES completion:nil];
}

- (void)cancelCollection {
    NSString *message = @"确定要取消选中图片的收藏么?";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *moveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.selectedItems.count == 0) {
            [NSObject showHudTipStr:@"必须至少选中一张图片"];
            return;
        }
        
        NSMutableArray *idArray = [[NSMutableArray alloc] init];
        for (AssemarcFile *af in self.selectedItems) {
            [idArray addObject:[NSString stringWithFormat:@"%ld",af.assemarcfilecollid]];
        }
        
        [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/assemarcfilecoll/removeArr" withParams:@{@"assemarcfilecollids": [idArray componentsJoinedByString:@","]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
            if ([data[@"is"] intValue]) {
                for (AssemarcFile *a in self.selectedItems) {
                    [_dataArray removeObject:a];
                }
                [self.collectionView reloadData];
            } else {
                [NSObject showHudTipStr:data[@"msg"]];
            }
        }];

    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:cancel];
    [alert addAction:moveAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - PBViewControllerDelegate & PBViewControllerDataSource
- (NSInteger)numberOfPagesInViewController:(PBViewController *)viewController {
    return _imageURLs.count;
}

- (void)viewController:(PBViewController *)viewController presentImageView:(UIImageView *)imageView forPageAtIndex:(NSInteger)index progressHandler:(void (^)(NSInteger, NSInteger))progressHandler {
    
    NSString *url = _imageURLs[index];
    
    PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UIImage *placeholder = cell.imageView.image;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:placeholder
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        }];
}

- (UIView *)thumbViewForPageAtIndex:(NSInteger)index {
//    if (self.thumb) {
    PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];

        return cell.imageView;
//    }
//    return nil;
}



- (void)viewController:(PBViewController *)viewController didSingleTapedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

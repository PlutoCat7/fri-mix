//
//  FindCloudEditViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/7.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindCloudEditViewController.h"
#import "YAHMultiPhotoViewController.h"
#import "FindPhotoHandleViewController.h"
#import "FindPhotoPostViewController.h"
#import "FindCloudEditCollectionViewCell.h"
#import "TOCropViewController.h"

@interface FindCloudEditViewController () <
YAHMultiPhotoViewControllerDelegate,
TOCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collFlowLayout;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) UIButton *checkButton;

@property (nonatomic, strong) YAHMultiPhotoViewController *multiVC;

@property (strong, nonatomic) NSArray<FindCloudCellModel *> *photoList;
@property (strong, nonatomic) NSMutableArray<FindCloudCellModel *> *selectList;
@property (nonatomic, assign) NSInteger showIndex;

@end

@implementation FindCloudEditViewController

- (instancetype)initWithCloudPhotos:(NSArray<FindCloudCellModel *> *)photoList {
    if (self = [super init]) {
        _photoList = photoList;
        _selectList = [NSMutableArray arrayWithArray:photoList];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
}

#pragma mark - Action

- (void)actionBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionCheck {
    FindCloudCellModel *photoModel = _photoList[self.showIndex];
    if ([_selectList containsObject:photoModel]) {
        [_selectList removeObject:photoModel];
    } else {
        [_selectList addObject:photoModel];
    }
    [self updateSelectUI];
}

- (IBAction)actionEdit:(id)sender {
    
    FindCloudCellModel *model = self.photoList[self.showIndex];
    TOCropViewController *_cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.image];
    _cropController.aspectRatioLockEnabled= NO;
    _cropController.resetAspectRatioEnabled = NO;
    _cropController.delegate = self;
    _cropController.doneButtonTitle = @"完成";
    _cropController.cancelButtonTitle = @"取消";
    _cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetOriginal;
    
    [self.navigationController pushViewController:_cropController animated:NO];
}

- (IBAction)actionNext:(id)sender {
    
    NSMutableArray *photoList = [NSMutableArray arrayWithCapacity:1];
    for (FindCloudCellModel *cellModel in self.selectList) {
        HXPhotoModel *photoModel = [[HXPhotoModel alloc] init];
        photoModel.thumbPhoto = cellModel.image;
        photoModel.previewPhoto = cellModel.image;
        [photoList addObject:photoModel];
    }
    
    @weakify(self)
    FindPhotoHandleViewController *vc = [[FindPhotoHandleViewController alloc] initWithPhotoList:[photoList copy] doneBlock:^(NSArray<FindPhotoHandleModel *> *photoModelList) {
        
        @strongify(self)
        [self pushPhotoPostVCWith:photoModelList];
    }];
    [self.navigationController pushViewController:vc animated:NO];
    
}

- (void)pushPhotoPostVCWith:(NSArray<FindPhotoHandleModel *> *)photoModelList {
    
    FindPhotoPostViewController *postVC = [[FindPhotoPostViewController alloc] initWithWithPhotoModelList:photoModelList];
    NSMutableArray *vcList = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    while (1) {
        if ([vcList.lastObject isKindOfClass:[self class]]) {
            break;
        }
        [vcList removeLastObject];
    }
    [vcList addObject:postVC];
    [self.navigationController setViewControllers:[vcList copy] animated:YES];
}

#pragma mark - YAHMultiPhotoViewControllerDelegate

- (void)scrollMultiPhotoView:(YAHMultiPhotoViewController *)vc index:(NSInteger)index {
    
    self.showIndex = index;
    [self updateSelectUI];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - private
- (void)setupUI {
    [self.nextButton.layer setMasksToBounds:YES];
    [self.nextButton.layer setCornerRadius:6.f];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"find_back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kDevice_Is_iPhoneX?44:20);
        make.left.equalTo(self.view);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkButton setImage:[UIImage imageNamed:@"find_cloud_photp_select"] forState:UIControlStateNormal];
    [self.checkButton setImage:[UIImage imageNamed:@"find_cloud_photp_select"] forState:UIControlStateSelected];
    [self.checkButton addTarget:self action:@selector(actionCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkButton];
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kDevice_Is_iPhoneX?44:20);
        make.right.equalTo(self.view).offset(-10);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    
    [self setupPhotoView];
    [self setupCollectionView];
    [self updateSelectUI];
}

- (void)setupPhotoView {
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *thumbPhotos = [NSMutableArray arrayWithCapacity:1];
    for (FindCloudCellModel *photoModel in _photoList) {
        [photos addObject:[YAHMutiZoomPhoto photoWithImage:photoModel.image]];
        [thumbPhotos addObject:[YAHMutiZoomPhoto photoWithImage:photoModel.image]];
    }
    YAHMultiPhotoViewController *vc = [[YAHMultiPhotoViewController alloc] initWithImage:photos thumbImage:photos originFrame:nil selectIndex:self.showIndex];
    vc.autoClickToClose = NO;
    vc.delegate = self;
    vc.view.backgroundColor = [UIColor colorWithRGBHex:0xE5E5E5];
    [self.view insertSubview:vc.view atIndex:0];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [self addChildViewController:vc];
    
    _multiVC = vc;
    
}

- (void)setupCollectionView {
    [self.collFlowLayout setItemSize:CGSizeMake(50,50)];
    self.collFlowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.collFlowLayout.minimumInteritemSpacing = 10;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"FindCloudEditCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FindCloudEditCollectionViewCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
}

- (void)updateSelectUI {
    FindCloudCellModel *photoModel = _photoList[self.showIndex];
    if ([_selectList containsObject:photoModel]) {
        [self.checkButton setImage:[UIImage imageNamed:@"find_cloud_photp_select"] forState:UIControlStateNormal];
        [self.checkButton setImage:[UIImage imageNamed:@"find_cloud_photp_select"] forState:UIControlStateSelected];
    } else {
        [self.checkButton setImage:[UIImage imageNamed:@"find_cloud_photp_unselect"] forState:UIControlStateNormal];
        [self.checkButton setImage:[UIImage imageNamed:@"find_cloud_photp_unselect"] forState:UIControlStateSelected];
    }
    
    [self.nextButton setTitle:[NSString stringWithFormat:@"继续(%td)", self.selectList.count] forState:UIControlStateNormal];
    [self.nextButton setTitle:[NSString stringWithFormat:@"继续(%td)", self.selectList.count] forState:UIControlStateSelected];
    self.nextButton.enabled = self.selectList.count>0;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoList ? self.photoList.count : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FindCloudEditCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"FindCloudEditCollectionViewCell" forIndexPath:indexPath];
    FindCloudCellModel *model = self.photoList[indexPath.row];
    
    [item setShowImage:model.image];
    
    return item;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.multiVC selectWithIndex:indexPath.row];
    
    self.showIndex = indexPath.row;
    [self updateSelectUI];
}

#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    //图片满屏
    CGFloat imagWidth = kScreen_Width;
    CGFloat imageHeight = imagWidth*image.size.height/image.size.width;
    UIImage *fitImage = [image scaleToFitSize:CGSizeMake(imagWidth, imageHeight)];
    FindCloudCellModel *model = self.photoList[self.showIndex];
    model.image = fitImage;
    [self.collectionView reloadData];
    [self.multiVC refreshCurrentViewWithImage:fitImage];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

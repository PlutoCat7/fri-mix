//
//  GBGamePhotosViewController.m
//  GB_Football
//
//  Created by yahua on 2017/12/15.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGamePhotosViewController.h"
#import "YAHMultiPhotoViewController.h"

#import "GBGamePhotoCollectionViewCell.h"
#import "GBGamePhotoCollectionHeaderView.h"

#import "GBGamePhotosViewModel.h"

@interface GBGamePhotosViewController () <UICollectionViewDelegate,
UICollectionViewDataSource,
YAHMultiPhotoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) GBGamePhotosViewModel *viewModel;

@end

@implementation GBGamePhotosViewController

- (instancetype)initWithMatchId:(NSInteger)matchId {
    
    self = [super init];
    if (self) {
        _viewModel = [[GBGamePhotosViewModel alloc] initWithMatchId:matchId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initPageData {
    
    [self showLoadingToast];
    [self.viewModel requestNetworkData:^(NSError *error) {
        if (!error) {
            [self dismissToast];
            [self.collectionView reloadData];
        }else {
            [self showToastWithText:error.domain];
        }
    }];
}

- (UIImage *)getViewShareImage {
    
    UIScrollView *scrollView =  self.collectionView;
    if (!scrollView) {
        return nil;
    }
    
    CGFloat oldheight = scrollView.height;
    CGPoint oldContentOffset = scrollView.contentOffset;
    
    scrollView.height = fmaxf(scrollView.contentSize.height, oldheight);
    scrollView.contentOffset = CGPointMake(0, 0);
    UIImage *shareImage = [LogicManager getImageWithHeadImage:nil subviews:@[scrollView] backgroundImage:[UIImage imageWithColor:[UIColor blackColor]]];
    
    scrollView.height = oldheight;
    scrollView.contentOffset = oldContentOffset;
    
    return shareImage;
}

#pragma mark - Private

-(void)setupCollectionView
{

    [self.flowLayout setItemSize:CGSizeMake(75*kAppScale,75*kAppScale)];
    self.flowLayout.headerReferenceSize = CGSizeMake(kUIScreen_Width, 55*kAppScale);
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBGamePhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GBGamePhotoCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBGamePhotoCollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GBGamePhotoCollectionHeaderView"];
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _viewModel.sectionModels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _viewModel.sectionModels[section].cellModels.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GBGamePhotoCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBGamePhotoCollectionViewCell" forIndexPath:indexPath];
    GBGamePhotosCellModel *model = _viewModel.sectionModels[indexPath.section].cellModels[indexPath.row];
    [item refreshWithModel:model];
    
    return item;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        GBGamePhotoCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GBGamePhotoCollectionHeaderView" forIndexPath:indexPath];
        headerView.nameLabel.text = _viewModel.sectionModels[indexPath.section].sectionName;
        
        return headerView;
    }else {
        
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //查看大图
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *thumPhotos = [NSMutableArray arrayWithCapacity:1];
    for (GBGamePhotosSectionModel *sectionModel in _viewModel.sectionModels) {
        for (GBGamePhotosCellModel *cellModel in sectionModel.cellModels) {
            if (cellModel.state == 0) {
                YAHMutiZoomPhoto *photo = [YAHMutiZoomPhoto photoWithPhotoUrl:[NSURL URLWithString:cellModel.url]];
                photo.state = 0;
                
                YAHMutiZoomPhoto *thumPhoto = [YAHMutiZoomPhoto photoWithImage:cellModel.photoImage];
                thumPhoto.state = 0;
                
                [photos addObject:photo];
                [thumPhotos addObject:thumPhoto];
            }else { //视频
                YAHMutiZoomPhoto *photo = [YAHMutiZoomPhoto photoWithVideoUrl:[NSURL URLWithString:cellModel.url]];
                photo.state = 1;
                
                YAHMutiZoomPhoto *thumPhoto = [YAHMutiZoomPhoto photoWithImage:cellModel.videoImage];
                photo.state = 1;
                
                [photos addObject:photo];
                [thumPhotos addObject:thumPhoto];
            }
        }
    }
    NSInteger selectIndex = 0;
    for (NSInteger i=0; i<indexPath.section; i++) {
        selectIndex += _viewModel.sectionModels[i].cellModels.count;
    }
    selectIndex += indexPath.row;
    
    YAHMultiPhotoViewController *vc = [[YAHMultiPhotoViewController alloc] initWithImage:photos thumbImage:thumPhotos selectIndex:selectIndex];
    vc.delegate = self;
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark - YAHMultiPhotoViewControllerDelegate

- (void)willHideMultiPhotoView:(YAHMultiPhotoViewController *)vc currentIndex:(NSInteger)cuurentIndex {
    
    NSLog(@"willHideMultiPhotoView cuurentIndex: %td",cuurentIndex);
}

- (void)didHideMultiPhotoView:(YAHMultiPhotoViewController *)vc currentIndex:(NSInteger)cuurentIndex {
    
    [vc dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"didHideMultiPhotoView cuurentIndex: %td",cuurentIndex);
}


@end

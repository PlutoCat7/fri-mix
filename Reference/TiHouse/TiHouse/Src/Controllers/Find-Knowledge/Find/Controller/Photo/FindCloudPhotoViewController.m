//
//  FindCloudPhotoViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindCloudPhotoViewController.h"

#import "FindCloudPhotoCollectionViewCell.h"
#import "PhotoCloudListRequest.h"

@interface FindCloudPhotoViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray<FindCloudCellModel *> *dataList;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectIndexPathList;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic, strong) PhotoCloudListRequest *pageRequest;

@end

@implementation FindCloudPhotoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageRequest = [[PhotoCloudListRequest alloc] init];
        _selectIndexPathList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionClose {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDone:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(findCloudPhotoViewControllerDidDone:)]) {
        
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
        for (NSIndexPath *indexPath in self.selectIndexPathList) {
            FindCloudCellModel *model = self.dataList[indexPath.row];
            if (model.image) { //是否已下载图片了
                [result addObject:model];
            }
        }
        [_delegate findCloudPhotoViewControllerDidDone:[result copy]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"云记录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"find_back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(actionClose)];
    [self setupCollectionView];
}

- (void)setupCollectionView {
    
    CGFloat padding = 1.5;
    CGFloat col = 3;
    NSInteger width = (kScreen_Width-2*padding)/col;
    self.layout.minimumLineSpacing = padding;
    self.layout.minimumInteritemSpacing = padding;
    self.layout.itemSize = CGSizeMake(width, width);
    self.layout.sectionInset = UIEdgeInsetsMake(padding, 0, padding + kRKBWIDTH(50), 0);
    
    _collectionView.allowsMultipleSelection = YES;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FindCloudPhotoCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([FindCloudPhotoCollectionViewCell class])];
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.pageRequest reloadPageWithHandle:^(id result, NSError *error) {
            [self.collectionView.mj_header endRefreshing];
            if (!error) {
                [self parseNetworkData:self.pageRequest.responseInfo.items];
                [self.collectionView reloadData];
            }
        }];
    }];
    self.collectionView.mj_header = mj_header;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)refreshSelctedUI {
    
    NSArray *list = [self.selectIndexPathList copy];
    
    if (list.count>0) {
        self.doneButton.backgroundColor = [UIColor colorWithRGBHex:0xFBF086];
        self.doneButton.enabled = YES;
    }else {
        self.doneButton.backgroundColor = [UIColor lightGrayColor];
        self.doneButton.enabled = NO;
    }
    [self.doneButton setTitle:[NSString stringWithFormat:@"继续(%td/%td)", list.count, self.maxCount] forState:UIControlStateNormal];
}

- (void)parseNetworkData:(NSArray<FindPhotoCloudInfo *> *)list {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (FindPhotoCloudInfo *info in list) {
        FindCloudCellModel *cellModel = nil;
        for (FindCloudCellModel *hasCellModel in self.dataList) {
            if (hasCellModel.fileid == info.fileid) {
                cellModel = hasCellModel;
                break;
            }
        }
        if (!cellModel) {
            cellModel = [[FindCloudCellModel alloc] init];
            cellModel.fileid = info.fileid;
            cellModel.imageUrl = [NSURL URLWithString:info.urlfile];
        }
        [result addObject:cellModel];
    }
    self.dataList = [result copy];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FindCloudPhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FindCloudPhotoCollectionViewCell class]) forIndexPath:indexPath];
    [cell refreshWithModel:self.dataList[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    if (![self.pageRequest isLoadEnd] &&
        self.dataList.count-1 == indexPath.row) {
        [self.pageRequest loadNextPageWithHandle:^(id result, NSError *error) {
            if (!error) {
                [self parseNetworkData:self.pageRequest.responseInfo.items];
                [collectionView reloadData];
            }
        }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.selectIndexPathList addObject:indexPath];
    [self refreshSelctedUI];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.selectIndexPathList removeObject:indexPath];
    [self refreshSelctedUI];
}

@end

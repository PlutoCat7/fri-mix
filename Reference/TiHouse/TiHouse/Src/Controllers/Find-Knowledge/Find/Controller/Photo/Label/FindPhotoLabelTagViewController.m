//
//  FindPhotoLabelTagViewController.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoLabelTagViewController.h"

#import "FindPhotoStyleCollectionViewCell.h"
#import "FindPhotoStyleLayout.h"

#import "ModelLabelRequest.h"

@interface FindPhotoLabelTagViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<FindPhotoLabelInfo *> *showList;
@property (nonatomic, strong) NSArray<FindPhotoLabelInfo *> *selectList;
@property (nonatomic, copy) void(^doneBlock)(NSArray<FindPhotoLabelInfo *> *selectStyleList);

@end

@implementation FindPhotoLabelTagViewController

- (instancetype)initWithSelectStyleList:(NSArray<FindPhotoLabelInfo *> *)selectStyleList  doneBlock:(void(^)(NSArray<FindPhotoLabelInfo *> *selectStyleList))doneBlock {
    
    self = [super init];
    if (self) {
        _selectList = selectStyleList;
        _doneBlock = doneBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Action

- (void)doneAction {
    
    if (_doneBlock) {
        _doneBlock(_selectList);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)loadData {
    
    [NSObject showHUDQueryStr:nil];
    WEAKSELF
    [ModelLabelRequest getModelLabelListWithHandler:^(id result, NSError *error) {
        
        if (!error) {
            weakSelf.showList = result;
            [weakSelf.collectionView reloadData];
        }
        [NSObject hideHUDQuery];
    }];
}

- (void)setupUI {
    
    [self wr_setNavBarBarTintColor:XWColorFromHex(0xfcfcfc)];
    self.title = @"添加空间";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认选择" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    
    [self setupCollectionView];
}

- (void)setupCollectionView {
    
    FindPhotoStyleLayout *layout = [[FindPhotoStyleLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 15;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    _collectionView.collectionViewLayout = layout;
    _collectionView.allowsMultipleSelection = NO;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FindPhotoStyleCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([FindPhotoStyleCollectionViewCell class])];
}

- (FindPhotoLabelInfo *)findLabelInfoWithID:(long)labelId {
    
    FindPhotoLabelInfo *findInfo = nil;
    for (FindPhotoLabelInfo *info in self.selectList) {
        if (info.labelId == labelId) {
            findInfo = info;
        }
    }
    return findInfo;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.showList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FindPhotoStyleCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FindPhotoStyleCollectionViewCell class]) forIndexPath:indexPath];
    FindPhotoLabelInfo *info = self.showList[indexPath.row];
    [cell refreshWithName:info.labelName isSelect:[self findLabelInfoWithID:info.labelId]!=nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FindPhotoStyleCollectionViewCell *cell = (FindPhotoStyleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    FindPhotoLabelInfo *info = self.showList[indexPath.row];
    NSMutableArray *tmpList = [NSMutableArray array];
    [tmpList addObject:info];
    [cell refreshWithName:info.labelName isSelect:YES];
    self.selectList = [tmpList copy];
    
    [collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *testString = self.showList[indexPath.row].labelName;
    CGFloat width = [testString getWidthWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 200)];
    return CGSizeMake(width+30, kFindPhotoStyleCollectionViewCellHeight);
}


@end

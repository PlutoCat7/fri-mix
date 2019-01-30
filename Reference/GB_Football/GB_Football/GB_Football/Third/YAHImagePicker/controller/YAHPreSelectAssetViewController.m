//
//  YHPreSelectAssetViewController.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/6.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHPreSelectAssetViewController.h"
#import "YAHPreSelectAssetCell.h"
#import "YAHPanddingButton.h"
#import "UIView+YAHShake.h"

#import "YAHImagePeckerAssetsData.h"
#import "UIImage+YAHRoundCorner.h"
#import "YAHImagePickerDefines.h"
#import "NSObject+FBKVOController.h"

static NSString *const reuseIdentifier = @"PreSelectCell";

@interface YAHPreSelectAssetViewController () <
UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YAHPanddingButton *comfirmButton;

@end

@implementation YAHPreSelectAssetViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor clearColor];
    
    
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                     = CGSizeMake(YHPreSelectAssetCellWidth, YHPreSelectAssetCellWidth);
    layout.minimumInteritemSpacing      = 10.0;
    layout.minimumLineSpacing           = 10.0;
    layout.scrollDirection              = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView registerClass:[YAHPreSelectAssetCell class]
            forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.comfirmButton];
    //横线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    
    //监听
    [self addSelectAssetsArrayObserver];
}

#pragma mark - UIInterfaceOrientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfacOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[YAHImagePeckerAssetsData shareInstance].selectAssetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YAHPreSelectAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    YAHPhotoModel *asset = [YAHImagePeckerAssetsData shareInstance].selectAssetsArray[indexPath.row];
    cell.asset = asset;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    CGRect rc = self.view.frame;
    CGFloat padding = (CGRectGetHeight(rc)-YHPreSelectAssetCellWidth)/2;
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YAHPreSelectAssetCell *cell = (YAHPreSelectAssetCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        [[YAHImagePeckerAssetsData shareInstance] removeAsset:cell.asset];
    }
}

#pragma mark - Custom Accessors

- (UIButton *)comfirmButton {
    
    if (!_comfirmButton) {
        CGRect rc = self.view.frame;
        CGFloat width = PreSelectionsToolbarHeight - 10;
        CGFloat height = width;
        
        _comfirmButton = [[YAHPanddingButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(rc)-width, (CGRectGetHeight(rc)-height)/2, width, height)];
        [_comfirmButton addTarget:self action:@selector(onComfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _comfirmButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleWidth;
        _comfirmButton.backgroundImageInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _comfirmButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _comfirmButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _comfirmButton.enabled = [[YAHImagePeckerAssetsData shareInstance] isSelectOneMore];
        [_comfirmButton setTitle:[self confirmButtonTitle] forState:UIControlStateNormal];
        [_comfirmButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithRed:0 green:102/255.f blue:1 alpha:.8f] size:CGSizeMake(width, height)] roundedCornerImage:3 borderSize:0] forState:UIControlStateNormal];
        
        // collectionview frame
        rc = self.collectionView.frame;
        rc.size.width -= width;
        self.collectionView.frame = rc;
    }
    return _comfirmButton;
}

#pragma mark - Action

- (void)onComfirmButtonClick {
    
    if (self.doneBlock) {
        self.doneBlock();
    }
}

#pragma mark - Private

- (NSString *)confirmButtonTitle {
    
    return [NSString stringWithFormat:@"%@\n(%td/%td)", LS(@"game.complete.done"), [YAHImagePeckerAssetsData shareInstance].selectAssetsArray.count, [YAHImagePeckerAssetsData shareInstance].maximumNumberOfSelection];
}

- (void)addSelectAssetsArrayObserver {
    
    __weak __typeof(self)weakSelf = self;
    [self.KVOController observe:[YAHImagePeckerAssetsData shareInstance] keyPath:@"selectAssetsArray" options:NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[YAHImagePeckerAssetsData shareInstance].changeDic objectForKey:[@(YHSelectAssetsChangeAddOverFlow) stringValue]]) {
            [strongSelf.comfirmButton shake:10   // 10 times
                            withDelta:2    // 2 points wide
                             andSpeed:0.03 // 30ms per shake
             ];
        }else {
            [strongSelf.comfirmButton setTitle:[strongSelf confirmButtonTitle] forState:UIControlStateNormal];
            strongSelf.comfirmButton.enabled = [[YAHImagePeckerAssetsData shareInstance] isSelectOneMore];
            [strongSelf.collectionView reloadData];
            
            NSInteger totalItems = [strongSelf.collectionView numberOfItemsInSection:0];
            // Prevents crash if totalRows = 0 (when the album is empty).
            if (totalItems > 0) {
                [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:totalItems-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
        }
    }];
}

@end

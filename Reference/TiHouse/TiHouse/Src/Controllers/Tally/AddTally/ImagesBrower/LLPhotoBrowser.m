//
//  LLPhotoBrowser.m
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLPhotoBrowser.h"
#import "LLCollectionViewCell.h"
#import "LLImageCache.h"

@interface LLPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,
                            LLPhotoDelegate,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *_images;
    NSInteger _currentIndex;
    UICollectionView *_collectionView;
    UIView *_navigationBar;
    UILabel *_titleLabel;
    UIButton *_sendImageBtn;
    BOOL _navIsHidden;
}

@end

@implementation LLPhotoBrowser

- (instancetype)initWithImages:(NSArray<UIImage *> *)images currentIndex:(NSInteger)currentIndex {
    self = [super init];
    if (self) {
        _images = [NSMutableArray arrayWithArray:images];
        _currentIndex = currentIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createViews];
}

- (void)createViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[LLCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    if (_currentIndex < _images.count) {
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    }
    
    /******自定义界面******/
    _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 64)];
    _navigationBar.backgroundColor = [UIColor clearColor];
    _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_navigationBar];
    
//    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 21, 16, 22)];
//    backImageView.image = [UIImage imageNamed:@"back_white"];
//    [_navigationBar addSubview:backImageView];
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(20, 17, 40, 30);
//    [backBtn setTitle:@" X " forState:UIControlStateNormal];
//    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    [_navigationBar addSubview:backBtn];
    
    if (!_sendImageBtn) {
        _sendImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendImageBtn.frame = CGRectMake(self.view.bounds.size.width-50, 17, 40, 30);
        [_sendImageBtn setImage:[UIImage imageNamed:@"Tally_icon_trashwhite"] forState:UIControlStateNormal];
        [_sendImageBtn addTarget:self action:@selector(sendImage:) forControlEvents:UIControlEventTouchUpInside];
        _sendImageBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    [_navigationBar addSubview:_sendImageBtn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 17, self.view.bounds.size.width-160, 30)];
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,_images.count];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [_navigationBar addSubview:_titleLabel];

}

#pragma mark - UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell.photo.ll_delegate) {
        cell.photo.ll_delegate = self;
    }
    cell.photo.ll_image = _images[indexPath.item];
    cell.photo.zoomScale = 1.0;
    
    return cell;
}

#pragma mark - UICollectionViewDelagate 当图图片滑出屏幕外时，将图片比例重置为原始比例
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    LLCollectionViewCell *LLCell = (LLCollectionViewCell *)cell;
    LLCell.photo.zoomScale = 1.0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentIndex = (long)scrollView.contentOffset.x/self.view.bounds.size.width;
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,_images.count];
}

#pragma mark - LLPhotoDelegate 图片单击事件，显示/隐藏标题栏
- (void)singleClickWithPhoto:(LLPhoto *)photo {
//    [UIView animateWithDuration:.1 animations:^{
//        if (_navIsHidden) {
//            _navigationBar.transform = CGAffineTransformIdentity;
//        }
//        else {
//            _navigationBar.transform = CGAffineTransformMakeTranslation(0, -64);
//        }
//    } completion:^(BOOL finished) {
//        _navIsHidden = !_navIsHidden;
//    }];
    [self goBack];
}

#pragma mark - 返回按钮
- (void)goBack {
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didSelectImage:)]) {
        
        NSMutableArray *imgDataArr = [NSMutableArray array];
        for (id url in _images) {
            if ([url isKindOfClass:[NSString class]]) {

                NSData *data = [[LLImageCache imageCache] getDataWithUrl:[NSURL URLWithString:url]];
                [imgDataArr addObject:[UIImage imageWithData:data]];
            }else{
                [imgDataArr addObject:url];
            }

        }
        
        [self.delegate photoBrowser:self didSelectImage:imgDataArr];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 删除按钮
- (void)sendImage:(UIButton *)btn {


    
    [_images removeObjectAtIndex:_currentIndex];
    
    if ([_images count] <= 0) {
        [self goBack];
    }
    
    [_collectionView reloadData];
    
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_images.count==1?1:_currentIndex+1,_images.count];
    
}

#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _collectionView.frame = self.view.bounds;
    _collectionView.contentOffset = CGPointMake(self.view.bounds.size.width*_currentIndex, 0);
    [_collectionView reloadData];
}

@end

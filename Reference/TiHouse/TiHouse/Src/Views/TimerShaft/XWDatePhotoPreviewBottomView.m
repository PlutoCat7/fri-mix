//
//  XWDatePhotoPreviewBottomView.m
//  微博照片选择
//
//  Created by 洪欣 on 2017/10/16.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import "XWDatePhotoPreviewBottomView.h"
#import "HouseTweet.h"
@interface XWDatePhotoPreviewBottomView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (strong, nonatomic) UIButton *editBtn;

@property (strong, nonatomic) UIView *lineH;
@end

@implementation XWDatePhotoPreviewBottomView
- (instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)modelArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.modelArray = [NSMutableArray arrayWithArray:modelArray];
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.currentIndex = -1;
    [self addSubview:self.bgView];
    [self addSubview:self.collectionView];
    [self addSubview:self.doneBtn];
    [self addSubview:self.editBtn];
    [self changeDoneBtnFrame];
    
    // lineH
    [self addSubview: self.lineH];
}
- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.editBtn.enabled = enabled;
}
- (void)setHideEditBtn:(BOOL)hideEditBtn {
    _hideEditBtn = hideEditBtn;
    if (hideEditBtn) {
        [self.editBtn removeFromSuperview];
        [self layoutSubviews];
    }
}
- (void)setOutside:(BOOL)outside {
    _outside = outside;
    if (outside) {
        self.doneBtn.hidden = YES;
    }
}
- (void)insertModel:(TweetImage *)model currentModelIndex:(NSInteger)index{
    [self.modelArray insertObject:model atIndex:index];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}
- (void)deleteModel:(TweetImage *)model {
    if ([self.modelArray containsObject:model]) {
        NSInteger index = [self.modelArray indexOfObject:model];
        [self.modelArray removeObject:model];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    }
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (currentIndex < 0 || currentIndex > self.modelArray.count - 1) {
        return;
    }
    self.currentIndexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    [self.collectionView selectItemAtIndexPath:self.currentIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}
- (void)setSelectCount:(NSInteger)selectCount {
    _selectCount = selectCount;
//    if (selectCount <= 0) {
//        [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
//    }else {
//        if (!self.manager.configuration.selectTogether) {
//            if (self.manager.selectedPhotoCount > 0) {
//                [self.doneBtn setTitle:[NSString stringWithFormat:@"完成(%ld/%ld)",selectCount,self.manager.configuration.photoMaxNum] forState:UIControlStateNormal];
//            }else {
//                [self.doneBtn setTitle:[NSString stringWithFormat:@"完成(%ld/%ld)",selectCount,self.manager.configuration.videoMaxNum] forState:UIControlStateNormal];
//            }
//        }else {
//            [self.doneBtn setTitle:[NSString stringWithFormat:@"完成(%ld/%ld)",selectCount,self.manager.configuration.maxNum] forState:UIControlStateNormal];
//        }
//    }
    [self changeDoneBtnFrame];
}

- (void)reloadData {
    
    [self.collectionView reloadData];
}
#pragma mark - < UICollectionViewDataSource >
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.modelArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XWDatePhotoPreviewBottomViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatePreviewBottomViewCellId" forIndexPath:indexPath];
    cell.selectColor = kTiMainBgColor;//self.manager.configuration.themeColor;
    TweetImage *model = self.modelArray[indexPath.item];
    cell.model = model;
    return cell;
}
#pragma mark - < UICollectionViewDelegate >
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delagate respondsToSelector:@selector(datePhotoPreviewBottomViewDidItem:currentIndex:beforeIndex:)]) {
        [self.delagate datePhotoPreviewBottomViewDidItem:self.modelArray[indexPath.item] currentIndex:indexPath.item beforeIndex:self.currentIndex];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(XWDatePhotoPreviewBottomViewCell *)cell cancelRequest];
}
- (void)deselectedWithIndex:(NSInteger)index {
    if (index < 0 || index > self.modelArray.count - 1) {
        return;
    }
    [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:NO];
}

- (void)deselected {
    if (self.currentIndex < 0 || self.currentIndex > self.modelArray.count - 1) {
        return;
    }
    [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] animated:NO];
}

- (void)didDoneBtnClick {
    if ([self.delagate respondsToSelector:@selector(datePhotoPreviewBottomViewDidDone:)]) {
        [self.delagate datePhotoPreviewBottomViewDidDone:self];
    }
}
- (void)didEditBtnClick {
    if ([self.delagate respondsToSelector:@selector(datePhotoPreviewBottomViewDidEdit:)]) {
        [self.delagate datePhotoPreviewBottomViewDidEdit:self];
    }
}
- (void)changeDoneBtnFrame {
    CGFloat width = [_doneBtn.titleLabel.text getWidthWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 40)];
    self.doneBtn.width = width + 20;
    if (self.doneBtn.width < 50) {
        self.doneBtn.width= 50;
    }
    self.doneBtn.x = self.width - 15 - self.doneBtn.width;
    self.editBtn.x = 15;
    self.editBtn.y = self.height - 40;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    self.collectionView.frame = CGRectMake(0, 23,self.width, 50);
    self.doneBtn.frame = CGRectMake(0, self.height-40, 50, 30);
    [self changeDoneBtnFrame];
    
    self.lineH.frame = CGRectMake(0, 20+self.collectionView.y+self.collectionView.height, self.width, 10);
}
#pragma mark - < 懒加载 >
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _bgView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,self.width - 12 - 50, 50) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
            [_collectionView registerClass:[XWDatePhotoPreviewBottomViewCell class] forCellWithReuseIdentifier:@"DatePreviewBottomViewCellId"];
        }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = 50;
        _flowLayout.itemSize = CGSizeMake(itemWidth, 50);
        _flowLayout.sectionInset = UIEdgeInsetsMake(1, 12, 1, 0);
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
} 
- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_doneBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _doneBtn.layer.cornerRadius = 3;
        _doneBtn.backgroundColor = kTiMainBgColor;
        [_doneBtn addTarget:self action:@selector(didDoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}
- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_editBtn setTitleColor:[self.manager.configuration.themeColor colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_editBtn addTarget:self action:@selector(didEditBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.size = CGSizeMake(50, 30);
    }
    return _editBtn;
}
- (UIView *)lineH {
    if (!_lineH) {
        _lineH = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.height, self.width, 0.5)];
        _lineH.backgroundColor = [UIColor lightGrayColor];
        _lineH.backgroundColor = [UIColor redColor];
    }
    return _lineH;
}
@end

@interface XWDatePhotoPreviewBottomViewCell ()
@property (strong, nonatomic) UIImageView *imageView;
//@property (assign, nonatomic) PHImageRequestID requestID;
@end

@implementation XWDatePhotoPreviewBottomViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    [self.contentView addSubview:self.imageView];
}
- (void)setModel:(TweetImage *)model {
    _model = model;
    if (model.image) {
        self.imageView.image = model.image;
    }else {
//        __weak typeof(self) weakSelf = self;
//        self.requestID = [HXPhotoTools getImageWithModel:model completion:^(UIImage *image, HXPhotoModel *model) {
//            if (weakSelf.model == model) {
//                weakSelf.imageView.image = image;
//            }
//        }];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.frame = CGRectMake(0, 0, 50, 50);
    }
    return _imageView;
}
- (void)setSelectColor:(UIColor *)selectColor {
    if (!_selectColor) {
        self.layer.borderColor = self.selected ? [selectColor colorWithAlphaComponent:1.0].CGColor : nil;
    }
    _selectColor = selectColor;
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.layer.borderWidth = selected ? 2 : 0;
    self.layer.borderColor = selected ? [self.selectColor colorWithAlphaComponent:1.0].CGColor : nil;
}
- (void)cancelRequest {
//    if (self.requestID) {
//        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
//        self.requestID = -1;
//    }
}
- (void)dealloc {
    [self cancelRequest];
} 
@end

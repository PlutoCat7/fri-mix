//
//  TallyCategoryView.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TallyCategoryView.h"
#import "AJRelayoutButton.h"
#import "TallyCategoryFlowLayout.h"
#import "TallySubCategoryCell.h"
#import <SDWebImage/UIButton+WebCache.h>

#define kItemHeight 30
#define kMinimumLineSpacing 10
#define kMinimumInteritemSpacing 10

#define kSectionEdgeInsetsLeft 15
#define kSectionEdgeInsetsBottom 0
#define kSectionEdgeInsetsTop 15
#define kSectionEdgeInsetsRight 15


CGFloat categoryHeight = 90;
CGFloat secondCategoryHeight = 45;


@interface TallyCategoryView()<UICollectionViewDelegate, UICollectionViewDataSource, TallyCategoryFlowLayoutDelegate>

// 一级分类
@property (strong, nonatomic) NSArray<TallyCategory *> *categoryList;

// 二级分类
@property (strong, nonatomic) NSMutableArray<TallySecondCategoryModel *> *secondCategoryList;

// 三级分类
@property (strong, nonatomic) NSMutableArray<TallyThridCategoryModel *> *thridCategoryList;


@property (weak, nonatomic) UIView *categoryHeader;
@property (weak, nonatomic) UIView *secondCategoryView;

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UIImageView *indicatorView;
@property (strong, nonatomic) NSMutableArray *categoryButtonArray;
@property (assign, nonatomic) NSUInteger firstSelectedIndex;

// 二级分类
@property (assign, nonatomic) NSUInteger secondSelectedIndex;
@property (weak, nonatomic) UIImageView *secondIndicatorView;
@property (strong, nonatomic) NSMutableArray *secondCategoryButtonArray;

// 三级分类上一个选择btn
@property (assign, nonatomic) NSInteger preThirdSelectedIndex;

@property (assign, nonatomic) BOOL isShowSecondCategory; // 是否显示二级分类

@end

@implementation TallyCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XWColorFromHex(0xf8f8f8);
        
        // header height 90
        UIView *categoryHeader = [UIView new];
        categoryHeader.backgroundColor = [UIColor whiteColor];
        [self addSubview:categoryHeader];
        self.categoryHeader = categoryHeader;
        [categoryHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.and.top.equalTo(self);
            make.height.equalTo(@(categoryHeight));
        }];
        
        // line
        UIView *lineH = [UIView new];
        lineH.backgroundColor = XWColorFromHex(0xdbdbdb);
        [categoryHeader addSubview:lineH];
        [lineH mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.leading.and.trailing.and.bottom.equalTo(categoryHeader);
        }];
        
        // secondCategory (二级分类) height 45
        UIView *secondCategoryView = [UIView new];
        secondCategoryView.backgroundColor = XWColorFromHex(0xfcfcfc);
        [self addSubview:secondCategoryView];
        self.secondCategoryView = secondCategoryView;
        [secondCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.equalTo(self);
            make.height.equalTo(@(secondCategoryHeight));
            make.top.equalTo(categoryHeader.mas_bottom);
        }];
        UIColor *clr = [UIColor lightGrayColor];
        self.secondCategoryView.layer.shadowColor = clr.CGColor;
        self.secondCategoryView.layer.shadowOffset = CGSizeMake(0,2);
        self.secondCategoryView.layer.shadowOpacity = 0.3;
        
        // collectionView (三级分类)
        TallyCategoryFlowLayout *layout = [[TallyCategoryFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = kMinimumInteritemSpacing;
        layout.minimumLineSpacing = kMinimumLineSpacing;
        layout.sectionInset = UIEdgeInsetsMake(kSectionEdgeInsetsTop, kSectionEdgeInsetsLeft, kSectionEdgeInsetsBottom, kSectionEdgeInsetsRight);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [collectionView registerClass:[TallySubCategoryCell class] forCellWithReuseIdentifier:@"cell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(secondCategoryView.mas_bottom);
            make.leading.and.trailing.equalTo(self);
            make.height.equalTo(@100);
        }];
        
        // indicatorView
        UIImageView *indicatorView = [[UIImageView alloc] initWithFrame:CGRectZero];
        indicatorView.image = [UIImage imageNamed:@"Tally_add_arrow_up_clr"];
        [categoryHeader addSubview:indicatorView];
        self.indicatorView = indicatorView;
        
        // addBtn
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"Tally_add_selectType_addproj"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).mas_offset(-20);
            make.width.equalTo(@91);
            make.height.equalTo(@31);
            make.centerX.equalTo(self);
        }];

        _firstSelectedIndex = -1;
        _secondSelectedIndex = -1;
    }
    return self;
}

- (void)show:(NSArray<TallyCategory *> *)categoryList {
    self.categoryList = categoryList;
    
    for (UIButton *btn in self.categoryButtonArray) {
        [btn removeFromSuperview];
    }
    
    CGFloat w = 50, h = 65, space = (kScreen_Width - 5*w) / 6;
    CGFloat x = space, y = 10;
    NSInteger index = 0;
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *titleColor = XWColorFromHex(0x565656);
    for (TallyCategory *category in categoryList) {
        
        // 一级分类
        AJRelayoutButton *categoryBtn = [AJRelayoutButton buttonWithType:UIButtonTypeCustom];
        categoryBtn.tag = index;
        categoryBtn.space = 5;
        categoryBtn.fixedImageSize = CGSizeMake(50, 50);
        [categoryBtn setTitle:category.cateonename forState:UIControlStateNormal];
        [categoryBtn sd_setImageWithURL:[NSURL URLWithString:category.urlicon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Tally_add_selectType_1"]];
        categoryBtn.titleLabel.font = font;
        [categoryBtn setTitleColor:titleColor forState:UIControlStateNormal];
        categoryBtn.frame = CGRectMake(x, y, w, h);
        [categoryBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.categoryHeader addSubview:categoryBtn];
        [self.categoryButtonArray addObject:categoryBtn];
        
        x += w + space;
        index ++;
    }
    
    if (self.firstSelectedIndex == -1) {
        NSInteger indexFirst = 0;
        for (TallyCategory *category in self.categoryList) {
            if (category.cateoneid == self.cateoneid) {
                self.firstSelectedIndex = indexFirst;
                break;
            }
            indexFirst ++;
        }
        
        if (self.firstSelectedIndex == -1) {
            self.firstSelectedIndex = 0;// 默认选择
        }
    } else {
        self.firstSelectedIndex = self.firstSelectedIndex;
    }
    
}

//- (void)reloadData:(NSArray<TallyCategory *> *)categoryList {
//    _categoryList = categoryList;
//    
//    self.firstSelectedIndex = self
//}

- (void)refreshViewHeight {
    [self.collectionView layoutIfNeeded];
    
    CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondCategoryView.mas_bottom);
        make.leading.and.trailing.equalTo(self);
        make.height.equalTo(@(height));
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.delegate refreshCellHeight: [self viewHeight]];
    });
    
}


#pragma mark - Action
- (void)categoryBtnAction:(UIButton *)sender {
    
    self.catethreeid = 0;
    self.cateoneid = 0;
    self.catetwoid = 0;
    
    self.firstSelectedIndex = sender.tag;
    
//    // 第一级类别
//    [self didSelectedHandle:self.categoryList[_firstSelectedIndex]];
}

- (void)setFirstSelectedIndex:(NSUInteger)selectedIndex {
    
    // 取消上一个选中的字体
    if (_firstSelectedIndex != -1) {
        UIButton *preBtn = self.categoryButtonArray[_firstSelectedIndex];
        preBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    _firstSelectedIndex = selectedIndex;
    
    self.preThirdSelectedIndex = -1;
    
    [self.secondCategoryList removeAllObjects];
    [self.secondCategoryList addObjectsFromArray:self.categoryList[selectedIndex].catetwoList];
    
    // 检查是否有三级分类
    self.isShowSecondCategory = YES;
    for (TallySecondCategoryModel *secondCategory in self.secondCategoryList) {
        if (secondCategory.catetwostatus == 0) {
            // 不显示
            self.isShowSecondCategory = NO;
            break;
        }
    }
    
    // 先清理二级分类 的UI元素
    [self.secondCategoryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.secondCategoryButtonArray removeAllObjects];
    
    if (self.isShowSecondCategory) {
        
        // 调整二级分类高度
        [self.secondCategoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.equalTo(self);
            make.height.equalTo(@(secondCategoryHeight));
            make.top.equalTo(self.categoryHeader.mas_bottom);
        }];
        
        // 构建按钮
        CGFloat w = 40, h = 45, space = 10;
        CGFloat x = 20, y = 0;
        NSInteger index = 0;
        UIFont *font = [UIFont systemFontOfSize:14];
        for (TallySecondCategoryModel *secondCategory in self.secondCategoryList) {
            CGSize size = [TallyHelper labelSize:secondCategory.catetwoname font:font height:h];
            w = size.width > w ? size.width: w;
            
            UIButton *secondCategoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            secondCategoryBtn.tag = index;
            secondCategoryBtn.frame = CGRectMake(x, y, w, h);
            [secondCategoryBtn setTitle:secondCategory.catetwoname forState:UIControlStateNormal];
            secondCategoryBtn.titleLabel.font = font;
            [secondCategoryBtn setTitleColor:XWColorFromHex(0x565656) forState:UIControlStateNormal];
            [secondCategoryBtn addTarget:self action:@selector(secondCategoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.secondCategoryView addSubview:secondCategoryBtn];
            [self.secondCategoryButtonArray addObject:secondCategoryBtn];
            x += w + space;
            index ++;
        }
        
        // sencondIndicatorView
        UIImageView *sencondIndicatorView = [[UIImageView alloc] initWithFrame:CGRectZero];
        sencondIndicatorView.image = [UIImage imageNamed:@"Tally_add_second_indicator"];
        [self.secondCategoryView addSubview:sencondIndicatorView];
        self.secondIndicatorView = sencondIndicatorView;

        // 默认选中第一个
        if (self.secondSelectedIndex == -1) {
            NSInteger indexSecond = 0;
            for (TallySecondCategoryModel *secondCategory in self.secondCategoryList) {
                if (secondCategory.catetwoid == self.catetwoid) {
                    self.secondSelectedIndex = indexSecond;
                    break;
                }
                indexSecond ++;
            }
            if (self.secondSelectedIndex == -1) {
                self.secondSelectedIndex = 0;// 默认选择
            }
        } else {
            if (self.secondCategoryList.count <= self.secondSelectedIndex) {
                self.secondSelectedIndex = 0;
            }
            self.secondSelectedIndex = self.secondSelectedIndex;
        }
        
    } else {
        // 没有二级分类，调整高度
        [self.secondCategoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.equalTo(self);
            make.height.equalTo(@0);
            make.top.equalTo(self.categoryHeader.mas_bottom);
        }];
        
        // 将二级下的所有三级拼接
        [self.thridCategoryList removeAllObjects];
        for (TallySecondCategoryModel *secondCategory in self.secondCategoryList) {
            if (secondCategory.tallytempletList.count > 0) {
                [self.thridCategoryList addObjectsFromArray:secondCategory.tallytempletList];
            }
        }
        
        // 显示三级
        [self.collectionView reloadData];
    }
    
    // 刷新一次
    [self refreshViewHeight];

    // 选中的一级按钮
    UIButton *selectedButton = self.categoryButtonArray[selectedIndex];
    selectedButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    // indicatorView
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.indicatorView.frame = CGRectMake(selectedButton.centerX-3, categoryHeight-5, 9, 6);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)secondCategoryBtnAction:(UIButton *)sender {
    self.secondSelectedIndex = sender.tag;
    
    // 1
//    TallyCategory *category1 = self.categoryList[_firstSelectedIndex];
//
//    // 2
//    TallySecondCategoryModel *category2 = self.secondCategoryList[self.secondSelectedIndex];
//
//    [self didSelectedHandle:category1
//                     second:category2];
}

- (void)setSecondSelectedIndex:(NSUInteger)secondSelectedIndex {
    // 取消上一个选中的字体
    if (_secondSelectedIndex != -1 && self.secondCategoryButtonArray.count > _secondSelectedIndex) {
        UIButton *preBtn = self.secondCategoryButtonArray[_secondSelectedIndex];
        preBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    _secondSelectedIndex = secondSelectedIndex;
    
    UIButton *selectedButton = self.secondCategoryButtonArray[secondSelectedIndex];
    
//    NSLog(@"%s", __FUNCTION__);
    
    [self.thridCategoryList removeAllObjects];
    NSMutableArray<TallyThridCategoryModel *> *thridCategoryList = self.secondCategoryList[secondSelectedIndex].tallytempletList;
    
    [self.thridCategoryList addObjectsFromArray:thridCategoryList];
    [self.collectionView reloadData];
    
    [self refreshViewHeight];
    
    // secondIndicatorView
    [UIView animateWithDuration:self.secondIndicatorView.width==0 ? 0 : 0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.secondIndicatorView.frame = CGRectMake(selectedButton.centerX-15, secondCategoryHeight-4, 30, 4);
    } completion:^(BOOL finished) {
        
    }];
    selectedButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
}

- (void)addBtnAction:(UIButton *)sender {
    NSInteger index = self.secondSelectedIndex;
    if (self.secondCategoryList.count == 0 ) {
        [NSObject showHudTipStr:@"没有二级分类！"];
        return;
    } else if (self.secondCategoryList.count == 1) {
        index = 0;
    }
        
    NSInteger catetwoid = self.secondCategoryList[index].catetwoid;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tallyCategoryAddProjectAction:)]) {
        [self.delegate tallyCategoryAddProjectAction:catetwoid];
    }
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TallySubCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.backgroundColor = [UIColor whiteColor];
    TallyThridCategoryModel *subCategory = self.thridCategoryList[indexPath.item];
    cell.label.text = subCategory.catename;
    
    if (subCategory.catethreeid == self.catethreeid && self.catethreeid != -1) {
        cell.label.backgroundColor = XWColorFromHex(0xfdf186);
        self.preThirdSelectedIndex = indexPath.item;
        [self selectedInfo:indexPath collectionView:collectionView];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.thridCategoryList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TallyThridCategoryModel *subCategory = self.thridCategoryList[indexPath.item];
    NSString *subCategoryName = subCategory.catename;
    
    // 计算文字宽度
    CGFloat w = [subCategoryName getWidthWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, kItemHeight)];
    CGSize size = CGSizeMake(w, kItemHeight);
    size.width = floorf(size.width+30); // 文字居中后两边空白15
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self selectedInfo:indexPath collectionView:collectionView];
}

- (void)selectedInfo:(NSIndexPath *)indexPath collectionView:(nonnull UICollectionView *)collectionView {
    // 选中的子类别
    TallyThridCategoryModel *subCategory = self.thridCategoryList[indexPath.item];
    
    NSLog(@"%@", subCategory.catename);
    
    TallySubCategoryCell *cell = (TallySubCategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.label.backgroundColor = XWColorFromHex(0xfdf186);
    
    if (self.preThirdSelectedIndex != -1 && self.preThirdSelectedIndex != indexPath.item) {
        NSIndexPath *preIndexPath = [NSIndexPath indexPathForItem:self.preThirdSelectedIndex inSection:0];
        TallySubCategoryCell *cell = (TallySubCategoryCell *)[collectionView cellForItemAtIndexPath:preIndexPath];
        cell.label.backgroundColor = [UIColor whiteColor];
    }
    
    self.preThirdSelectedIndex = indexPath.item;
    
    
    /////
    // 1
    TallyCategory *category1 = self.categoryList[_firstSelectedIndex];
    
    // 3
    TallyThridCategoryModel *category3 = subCategory;
    
    // 判断是否显示二级
    if (self.isShowSecondCategory) {
        // 2
        TallySecondCategoryModel *category2 = self.secondCategoryList[self.secondSelectedIndex];
        
        [self didSelectedHandle:category1
                         second:category2
                          thrid:category3];
    } else {
        [self didSelectedHandle:category1
                         second:nil
                          thrid:category3];
    }
}

#pragma mark - 选择后的回调处理
- (void)didSelectedHandle:(TallyCategory *)category1 {
    if ([_delegate respondsToSelector:@selector(didSelected:secondCategory:thridCategory:)]) {
        [_delegate didSelected:category1 secondCategory:nil thridCategory:nil];
    }
}

- (void)didSelectedHandle:(TallyCategory *)category1 second:(TallySecondCategoryModel *)category2 {
    if ([_delegate respondsToSelector:@selector(didSelected:secondCategory:thridCategory:)]) {
        [_delegate didSelected:category1 secondCategory:category2 thridCategory:nil];
    }
}

- (void)didSelectedHandle:(TallyCategory *)category1 second:(TallySecondCategoryModel *)category2 thrid:(TallyThridCategoryModel *)category3 {
    if ([_delegate respondsToSelector:@selector(didSelected:secondCategory:thridCategory:)]) {
        [_delegate didSelected:category1 secondCategory:category2 thridCategory:category3];
    }
}

#pragma mark - getter/setter

- (NSMutableArray<TallySecondCategoryModel *>  *)secondCategoryList {
    if (_secondCategoryList == nil) {
        _secondCategoryList = [NSMutableArray array];
    }
    return _secondCategoryList;
}

- (NSMutableArray<TallyThridCategoryModel *>  *)thridCategoryList {
    if (_thridCategoryList == nil) {
        _thridCategoryList = [NSMutableArray array];
    }
    return _thridCategoryList;
}

- (NSMutableArray *)categoryButtonArray {
    if ( _categoryButtonArray == nil) {
        _categoryButtonArray = [NSMutableArray array];
    }
    return _categoryButtonArray;
}

- (NSMutableArray *)secondCategoryButtonArray {
    if (_secondCategoryButtonArray == nil) {
        _secondCategoryButtonArray = [NSMutableArray array];
    }
    return _secondCategoryButtonArray;
}

- (CGFloat)viewHeight {

    CGFloat height = categoryHeight;
    // 是否有二级分类
    if (self.isShowSecondCategory) {
        height += secondCategoryHeight;
    }
    
    height += self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    
    return height + 65;
}

@end

//
//  MenuItemBar.m
//  GB_Football
//
//  Created by Pizza on 2016/11/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MenuItemBar.h"
#import "MenuItem.h"
#import "XXNibBridge.h"

#import "NoRemindManager.h"

static const NSInteger itemWidth =  30;

@interface MenuItemBar()<XXNibBridge,
UICollectionViewDelegate,
UICollectionViewDataSource>
// 集合视图
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation MenuItemBar

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _selectIndex = 3;
    [self setupCollectionView];
}

-(void)setupCollectionView
{
    self.flowLayout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MenuItem" bundle:nil] forCellWithReuseIdentifier:@"MenuItem"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.collectionView.frame = self.bounds;
    });
}

#pragma mark - Public

- (void)refreshUI {
    
    [self.collectionView reloadData];
}

-(void)setIconNames:(NSArray *)iconNames
{
    _iconNames = [iconNames copy];
    [self sizeToFitScreen];
    [self.collectionView reloadData];
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    for (int i = 0 ; i < [_iconNames count] ;i++)
    {
        MenuItem *item = (MenuItem*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i == _selectIndex)
        {
            item.isSelect = YES;
        }
        else
        {
            item.isSelect = NO;
        }
    }
}


#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_iconNames count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuItem" forIndexPath:indexPath];
    if ([self.iconNames count] >0)
    {
        item.imageName = self.iconNames[indexPath.row];
        if (self.selectIndex == indexPath.row) {
            item.isSelect = YES;
        }else {
            item.isSelect = NO;
        }
        if (indexPath.row == 4) { //球队图标
            item.tipImageIcon.hidden = [NoRemindManager sharedInstance].tutorialNewTeamIcon;
        }else {
            item.tipImageIcon.hidden = YES;
        }
    }
    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuItemBar:index:)]) {
        [self.delegate menuItemBar:self index:indexPath.row];
    }
}

// 屏幕适配，特殊处理
-(void)sizeToFitScreen
{
    UICollectionViewFlowLayout *flowLayout = self.flowLayout;
    [flowLayout setItemSize:CGSizeMake(itemWidth,self.height)];
    CGFloat inSet = (self.width-itemWidth*self.iconNames.count)/(self.iconNames.count+1);
    flowLayout.minimumInteritemSpacing = inSet;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, (NSInteger)(inSet), 0, (NSInteger)(inSet));
}

@end

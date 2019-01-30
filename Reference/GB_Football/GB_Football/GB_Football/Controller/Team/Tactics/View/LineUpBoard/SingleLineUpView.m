//
//  SingleTracticsView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "SingleLineUpView.h"
#import "XXNibBridge.h"
#import "LineUpSinglePlayerCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#define ItemWidth (68*kAppScale)

@interface SingleLineUpView ()<XXNibBridge,
UICollectionViewDelegate,
UICollectionViewDataSource,
LineUpSinglePlayerCollectionViewCellDelegate>
// 集合视图
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation SingleLineUpView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectRow = -1;
    [self setupCollectionView];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.collectionView.frame = self.bounds;
    });
}


#pragma mark - Public

- (void)setData:(NSArray<LineUpPlayerModel *> *)data {
    
    NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:1];
    [data enumerateObjectsUsingBlock:^(LineUpPlayerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpList addObject:[obj copy]];
    }];
    _data = [tmpList copy];
    CGFloat inSet = 0;
    CGFloat spacing = 0;
    switch (data.count) {
        case 1:
            inSet = (self.width-ItemWidth)/2;
            break;
        case 2:
            inSet = (self.width-ItemWidth*2)/3;
            spacing = inSet;
            break;
        case 3:
            inSet = (self.width-ItemWidth*3)/4;
            spacing = inSet;
            break;
        case 4:
            inSet = (self.width-ItemWidth*4)/5;;
            spacing = inSet;
            break;
        case 5:
            inSet = 0;
            spacing = (self.width-ItemWidth*5)/4;
            break;
            
        default:
            break;
    }
    UICollectionViewFlowLayout *flowLayout = self.flowLayout;
    [flowLayout setItemSize:CGSizeMake(ItemWidth,self.height)];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, (NSInteger)(inSet), 0, (NSInteger)(inSet));
    flowLayout.minimumInteritemSpacing = spacing;
    [self.collectionView reloadData];
}

- (void)setSelectRow:(NSInteger)selectRow {
    
    _selectRow = selectRow;
    [self.collectionView reloadData];
}

- (void)setIsEdit:(BOOL)isEdit {
    
    _isEdit = isEdit;
    [self.collectionView reloadData];
}

#pragma mark - Private

-(void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(ItemWidth,83*kAppScale)];
    self.flowLayout = flowLayout;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LineUpSinglePlayerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LineUpSinglePlayerCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LineUpSinglePlayerCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"LineUpSinglePlayerCollectionViewCell" forIndexPath:indexPath];
    item.delegate = self;
    LineUpPlayerModel *model = self.data[indexPath.row];
    if (model.playerInfo) {
        [item.avatorView.avatorImageView sd_setImageWithURL:[NSURL URLWithString:model.playerInfo.image_url] placeholderImage:[UIImage imageNamed:@"portrait"]];
        item.nameLabel.text = model.playerInfo.nick_name;
        item.showDeleteIcon = self.isEdit?YES:NO;
    }else {
        item.avatorView.avatorImageView.image = [UIImage imageNamed:model.emptyImageName];
        item.nameLabel.text = model.posName;
        item.showDeleteIcon = NO;
    }
    item.hasSelected = self.selectRow==indexPath.row;
    
    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(singleTracticsView:didSelectAtIndex:)]) {
        [self.delegate singleTracticsView:self didSelectAtIndex:indexPath.row];
    }
}

- (void)didClickDeleteBtn:(LineUpSinglePlayerCollectionViewCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    self.data[indexPath.row].playerInfo = nil;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    if ([self.delegate respondsToSelector:@selector(singleTracticsView:didSelectAtIndex:)]) {
        [self.delegate singleTracticsView:self removeAtIndex:indexPath.row];
    }
}

@end

//
//  TracticsPlayerSelectView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "LineUpPlayerSelectView.h"
#import "LineUpPlayerSelectCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface LineUpPlayerSelectView ()<
UICollectionViewDelegate,
UICollectionViewDataSource>
// 集合视图
@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *nodataTipsView;

@end

@implementation LineUpPlayerSelectView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self localUI];
    [self setupCollectionView];
}

- (void)localUI {
    
    self.nodataTipsView.text = LS(@"team.tractics.no.choose");
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.collectionView.frame = self.bounds;
    });
}

#pragma mark - Public

- (void)setDataList:(NSArray<TeamPalyerInfo *> *)dataList {
    
    _dataList = dataList;
    self.nodataTipsView.hidden = !(dataList.count==0);
    [self.collectionView reloadData];
}

#pragma mark - Private

-(void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [flowLayout setItemSize:CGSizeMake(70,121*kAppScale)];
    flowLayout.minimumInteritemSpacing = 0;
    CGFloat inSet = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, (NSInteger)(inSet), 0, (NSInteger)(inSet));
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LineUpPlayerSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LineUpPlayerSelectCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self insertSubview:self.collectionView belowSubview:self.nodataTipsView];
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LineUpPlayerSelectCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"LineUpPlayerSelectCollectionViewCell" forIndexPath:indexPath];
    TeamPalyerInfo *model = self.dataList[indexPath.row];
    [item.avatorImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"portrait"]];
    item.nameLabel.text = model.nick_name;
    
    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tracticsPlayerSelectView:didSelectAtIndexPath:)]) {
        [self.delegate tracticsPlayerSelectView:self didSelectAtIndexPath:indexPath];
    }
}


@end

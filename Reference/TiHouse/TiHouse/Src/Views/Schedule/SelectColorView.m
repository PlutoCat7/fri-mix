//
//  SelectColorView.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SelectColorView.h"
#import "ColorModel.h"

@interface SelectColorView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentConstraintTop;
@property (weak, nonatomic) IBOutlet UIView *contentView;

//data
@property (strong, nonatomic) NSMutableArray * dataArray;

@end

@implementation SelectColorView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel
{
    SelectColorView * selectColorView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    
    [selectColorView xl_bindViewModel];
    
    return selectColorView;
}

-(void)xl_bindViewModel {
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    //set Constraint
    self.contentConstraintTop.constant = kScreen_Height;
    self.backgroundView.alpha = 0;
    [self layoutIfNeeded];
    
    //cell register
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SelectColorViewCell"];
    
    //request color list
    WEAKSELF;
    [[TiHouse_NetAPIManager sharedManager] request_scheduleColorSelectBlock:^(id data, NSError *error) {
        NSArray * array = data;
        [weakSelf.dataArray addObjectsFromArray:array];
        [weakSelf.collectionView reloadData];
    }];
}

#pragma mark - UICollectionView Delegate & datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDCell = @"SelectColorViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDCell forIndexPath:indexPath];
    
    ColorModel * colorModel = self.dataArray[indexPath.row];
    NSString * colorStr = [NSString stringWithFormat:@"0x%@",colorModel.colorvalue];
    unsigned long color = strtoul([colorStr UTF8String],0,16);
    cell.backgroundColor = XWColorFromHex(color);
    
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((kScreen_Width - 60) / 5, (kScreen_Width - 60) / 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectItemAtIndexPath");

    [self dismissSelectColorView];
    
    ColorModel * colorModel = self.dataArray[indexPath.row];
    if (_SelectColorBlock) {
        _SelectColorBlock(colorModel.colorvalue);
    }
}

/**
 * 视图出现设置
 */
-(void)showSelectColorView {
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.contentConstraintTop.constant = kScreen_Height - 220;
        self.backgroundView.alpha = 0.3;
        [self layoutIfNeeded];
    }];
}

-(void)dismissSelectColorView {
    
    self.contentConstraintTop.constant = kScreen_Height;
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [self removeFromSuperview];
    }];
}

/**
 * 背景点击事件
 */
- (IBAction)backgroundTapAction:(UITapGestureRecognizer *)sender {
    [self dismissSelectColorView];
    
    if (_DismissColorBlock) {
        _DismissColorBlock();
    }
}

@end

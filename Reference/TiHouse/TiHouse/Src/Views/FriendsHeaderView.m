//
//  FriendsHeaderView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/17.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FriendsHeaderView.h"
#import "HouseChangeImageCell.h"
#import "User.h"

@interface FriendsHeaderView()<UICollectionViewDataSource, UICollectionViewDelegate>


@end

@implementation FriendsHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self mediaView];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5f, self.width, 0.5f)];
        [bottomLine setBackgroundColor:kLineColer];
        [bottomLine setAlpha:1];
        [self addSubview:bottomLine];
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseChangeImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    User *user = _images[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:user.urlhead]];
    cell.vidoImage.hidden = YES;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.height-kRKBWIDTH(16), self.height-kRKBWIDTH(16));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kRKBWIDTH(10), kRKBWIDTH(10), kRKBWIDTH(10), kRKBWIDTH(10));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kRKBWIDTH(8);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kRKBWIDTH(8);
}



-(UICollectionView *)mediaView{
    if (!_mediaView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _mediaView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _mediaView.backgroundColor = [UIColor whiteColor];
        _mediaView.scrollEnabled = NO;
        [_mediaView setBackgroundView:nil];
        [_mediaView setBackgroundColor:[UIColor clearColor]];
        [_mediaView registerClass:[HouseChangeImageCell class] forCellWithReuseIdentifier:@"cell"];
        _mediaView.dataSource = self;
        _mediaView.delegate = self;
        [self addSubview:_mediaView];
    }
    return _mediaView;
}

@end

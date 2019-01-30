//
//  ArticleMoreViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ArticleMoreViewController.h"
#import "FindArticleDetailViewController.h"

#import "ArticleMoreCollectionViewCell.h"

#import "AssemArcMoreListRequest.h"

@interface ArticleMoreViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray<FindAssemarcInfo *> *dataList;
@property (nonatomic, strong) AssemArcMoreListRequest *pageRequest;

@end

@implementation ArticleMoreViewController

- (instancetype)initWithArcTitle:(NSString *)title assemarcid:(NSString *)assemarcid
{
    self = [super init];
    if (self) {
        _pageRequest = [[AssemArcMoreListRequest alloc] init];
        _pageRequest.assemarcid = assemarcid.length > 0 ? assemarcid: @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    [_pageRequest reloadPageWithHandle:^(id result, NSError *error) {
        
        if (!error) {
            self.dataList = self.pageRequest.responseInfo.items;
            [self.collectionView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setupUI {
    
    _layout.sectionInset = UIEdgeInsetsMake(kRKBWIDTH(14), kRKBWIDTH(12), 0, kRKBWIDTH(12));
    _layout.minimumLineSpacing = kRKBWIDTH(10);
    _layout.minimumLineSpacing = kRKBWIDTH(10);
    _layout.itemSize = CGSizeMake(kRKBWIDTH(290), kRKBWIDTH(205));
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ArticleMoreCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ArticleMoreCollectionViewCell class])];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleMoreCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ArticleMoreCollectionViewCell class]) forIndexPath:indexPath];
    FindAssemarcInfo *info = _dataList[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:info.urlindex]];
    cell.titleLabel.text = info.assemarctitle;
    [cell.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:info.urlhead]];
    cell.userName.text = info.username;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.pageRequest isLoadEnd] &&
        self.dataList.count-1 == indexPath.row) {
        [self.pageRequest loadNextPageWithHandle:^(id result, NSError *error) {
            
            if (!error) {
                self.dataList = self.pageRequest.responseInfo.items;
                [self.collectionView reloadData];
            }
        }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FindAssemarcInfo *info = _dataList[indexPath.row];
    FindArticleDetailViewController *vc = [[FindArticleDetailViewController alloc] initWithAssemarcInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

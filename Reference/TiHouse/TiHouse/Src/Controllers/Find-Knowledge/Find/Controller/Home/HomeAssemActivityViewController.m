//
//  HomeAssemActivityViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "HomeAssemActivityViewController.h"
#import "FindAssemListViewController.h"
#import "AssemDetailContainerViewController.h"

#import "HomeAssemCollectionViewCell.h"
#import "FindAssemActivityRequest.h"

@interface HomeAssemActivityViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray<FindAssemActivityInfo *> *dataList;

@end

@implementation HomeAssemActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Action

- (IBAction)actionAllAssem:(id)sender {
    
    FindAssemListViewController *vc = [[FindAssemListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)loadData {
    
    [FindAssemActivityRequest getActivityListFiveWithHandler:^(id result, NSError *error) {
        
        if (!error) {
            self.dataList = result;
            [self.collectionView reloadData];
        }
    }];
}

- (void)setupUI {
    
    _layout.sectionInset = UIEdgeInsetsMake(kRKBWIDTH(15), kRKBWIDTH(12), kRKBWIDTH(15), kRKBWIDTH(12));
    _layout.minimumLineSpacing = kRKBWIDTH(10);
    _layout.minimumLineSpacing = kRKBWIDTH(10);
    _layout.itemSize = CGSizeMake(kRKBWIDTH(200), kRKBWIDTH(100));
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeAssemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HomeAssemCollectionViewCell class])];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeAssemCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeAssemCollectionViewCell class]) forIndexPath:indexPath];
    [cell refreshWithInfo:_dataList[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FindAssemActivityInfo *info = _dataList[indexPath.row];
    AssemDetailContainerViewController *vc = [[AssemDetailContainerViewController alloc] initWithAssemInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

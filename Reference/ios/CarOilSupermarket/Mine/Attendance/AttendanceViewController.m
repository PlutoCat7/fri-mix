//
//  AttendanceViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/20.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "AttendanceViewController.h"

#import "GBView.h"
#import "AttendanceCollectionViewCell.h"
#import "AttendanceCollectionReusableView.h"

#import "AttendanceViewModel.h"

@interface AttendanceViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *attendanceCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allAttendanceDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionVIew;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) IBOutlet UILabel *withdrawInfoLbael;
@property (weak, nonatomic) IBOutlet GBView *todayView;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;

@property (nonatomic, strong) AttendanceViewModel *viewModel;

@end

@implementation AttendanceViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[AttendanceViewModel alloc] init];
        @weakify(self)
        [self.yah_KVOController observe:self keyPath:@"needRefreshView" block:^(id observer, id object, NSDictionary *change) {
            @strongify(self)
            [self.collectionVIew reloadData];
            [self refreshUI];
        }];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //及时刷新界面
    [self showLoadingToast];
    @weakify(self)
    [self.viewModel getAttendanceDataWithHandler:^(NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self.collectionVIew reloadData];
            [self refreshUI];
        }
    }];
}

#pragma mark - Action

- (IBAction)actionAttendance:(id)sender {
    
    [self showLoadingToast];
    @weakify(self)
    [_viewModel attendanceTodayWithHandler:^(NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self.collectionVIew reloadData];
            [self refreshUI];
        }
    }];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"签到";
    [self setupBackButtonWithBlock:nil];
    
    [self setupCollectionView];
}

- (void)setupCollectionView {
    
    [_flowLayout setItemSize:CGSizeMake(kAttendanceCollectionViewCellWidth,kAttendanceCollectionViewCellHeight)];
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10*kAppScale, 0, 10*kAppScale);
    _flowLayout.footerReferenceSize = CGSizeMake(kUIScreen_Width, 0.5);
    
    [self.collectionVIew registerNib:[UINib nibWithNibName:@"AttendanceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AttendanceCollectionViewCell"];
    [self.collectionVIew registerNib:[UINib nibWithNibName:@"AttendanceCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"AttendanceCollectionReusableView"];
}

- (void)refreshUI {
    
    self.attendanceCountLabel.attributedText = [_viewModel thisMonthTotalAttendanceCount];
    self.allAttendanceDaysLabel.text = [_viewModel allAttendanceDaysString];
    self.monthLabel.text = [_viewModel monthName];
    BOOL isTodayAttendance = [_viewModel isHasTodayAttendance];
    self.todayButton.enabled = !isTodayAttendance;
    self.todayView.backgroundColor =isTodayAttendance?[UIColor whiteColor]:[UIColor colorWithHex:0x14B0FF];
    self.withdrawInfoLbael.text = [_viewModel withdrawInfo];
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.viewModel.cellModels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.cellModels[section].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AttendanceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttendanceCollectionViewCell" forIndexPath:indexPath];
    AttendanceCellModel *cellModel = self.viewModel.cellModels[indexPath.section][indexPath.row];
    [cell refreshWithModel:cellModel];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        AttendanceCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"AttendanceCollectionReusableView" forIndexPath:indexPath];
        
        return view;
    }else {
        
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

@end

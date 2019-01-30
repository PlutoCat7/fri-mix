//
//  VouchersBuyViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "VouchersBuyViewController.h"
#import "VouchersPayViewController.h"

#import "VouchersBuyCollectionViewCell.h"
#import "VouchersDetailView.h"

#import "VouchersBuyViewModel.h"

@interface VouchersBuyViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
VouchersBuyCollectionViewCellDelegate,
VouchersDetailViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *makeButton;
@property (weak, nonatomic) IBOutlet UIView *diyView;
@property (weak, nonatomic) IBOutlet UITextField *diyTextField;

@property (nonatomic, strong) VouchersBuyViewModel *viewModel;

@end

@implementation VouchersBuyViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[VouchersBuyViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    if (notification.object == self.diyTextField) {
        if ([self.viewModel getWillBuyCellModel]) {
            [self.viewModel clearBuyCount];
            [self.collectionView reloadData];
        }
        [self refreshSettlementView];
    }
}

#pragma mark - Action

- (IBAction)actionBuy:(id)sender {
    
    VouchersBuyCellModel *cellModel = [_viewModel getWillBuyCellModel];
    NSInteger count = 0;
    CGFloat showPrice = 0;
    NSInteger payPrice = 0;
    if (cellModel) {
        count = cellModel.buyCount;
        payPrice = (NSInteger)cellModel.price;
        showPrice = cellModel.price * cellModel.ratio;
        self.makeButton.enabled = YES;
    }else if ([self.diyTextField.text integerValue]>0) {
        count = 1;
        CGFloat ratio = 1;
        if (_viewModel.cellModels.firstObject) {
            ratio = _viewModel.cellModels.firstObject.ratio;
        }
        payPrice = [self.diyTextField.text integerValue];
        showPrice = payPrice * ratio;
    }
    VouchersPayViewController *vc = [[VouchersPayViewController alloc] initWithNumber:count showPrice:showPrice payPrice:payPrice paymentOpt:[_viewModel getPaymentTypeInfoList]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)loadData {
    
    [self showLoadingToast];
    @weakify(self)
    [self.viewModel getVouchersDataWithHandler:^(NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self.collectionView reloadData];
            if ([self.viewModel getDiyEnabel]) {
                self.diyView.hidden = NO;
                _flowLayout.sectionInset = UIEdgeInsetsMake(25*kAppScale, 18*kAppScale, 78*kAppScale+self.diyView.height, 18*kAppScale);
            }else {
                self.diyView.hidden = YES;
                _flowLayout.sectionInset = UIEdgeInsetsMake(25*kAppScale, 18*kAppScale, (25+78)*kAppScale, 18*kAppScale);
            }
        }
    }];
}

- (void)setupUI {
    
    self.title = @"购买代金券";
    [self setupBackButtonWithBlock:nil];

    [self setupCollectionView];
    [self setupSettlementView];
}

- (void)setupCollectionView {
    
    [_flowLayout setItemSize:CGSizeMake(kVouchersBuyCollectionViewCellWidth,kVouchersBuyCollectionViewCellHeight)];
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.minimumLineSpacing = 25*kAppScale;
    _flowLayout.sectionInset = UIEdgeInsetsMake(25*kAppScale, 18*kAppScale, (25+78)*kAppScale, 18*kAppScale);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"VouchersBuyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VouchersBuyCollectionViewCell"];
}

- (void)setupSettlementView {
    
    self.makeButton.layer.cornerRadius = 5;
    [self.makeButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [self.makeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xFD6140]] forState:UIControlStateNormal];
}

- (void)refreshSettlementView {
    
    VouchersBuyCellModel *cellModel = [_viewModel getWillBuyCellModel];
    NSInteger count = 0;
    CGFloat totalPrice = 0;
    if (cellModel) {
        count = cellModel.buyCount;
        totalPrice = cellModel.price*cellModel.buyCount*cellModel.ratio;
        self.makeButton.enabled = YES;
    }else if ([self.diyTextField.text integerValue]>0) {
        count = 1;
        CGFloat ratio = 1;
        if (_viewModel.cellModels.firstObject) {
            ratio = _viewModel.cellModels.firstObject.ratio;
        }
        totalPrice = [self.diyTextField.text integerValue]*ratio;
        self.makeButton.enabled = [self.viewModel checkDiyPriceEnabel:[self.diyTextField.text floatValue]];
    }else {
        self.makeButton.enabled = NO;
    }
    self.countLabel.text = [NSString stringWithFormat:@"共 %td 张", count];
    NSString *worthString = [NSString stringWithFormat:@"¥ %.2f", totalPrice];
    NSMutableAttributedString *mutAttributedString = [[NSMutableAttributedString alloc] initWithString:worthString];
    [mutAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13*kAppScale] range:[worthString rangeOfString:@"¥"]];
    self.totalPriceLabel.attributedText = [mutAttributedString copy];
    self.diyTextField.placeholder = [_viewModel diyTextFieldPlaceholder];
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.cellModels.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VouchersBuyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VouchersBuyCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    VouchersBuyCellModel *cellModel = self.viewModel.cellModels[indexPath.row];
    [cell refreshWithModel:cellModel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VouchersBuyCellModel *cellModel = self.viewModel.cellModels[indexPath.row];
    [VouchersDetailView showWithModel:cellModel delegate:self];
}

#pragma mark - VouchersBuyCollectionViewCellDelegate

- (void)didDeleteButtonWithCell:(VouchersBuyCollectionViewCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    VouchersBuyCellModel *cellModel = _viewModel.cellModels[indexPath.row];
    NSInteger count = cellModel.buyCount-1;
    if (count<0) {
        return;
    }
    cellModel.buyCount = count;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [self refreshSettlementView];
}

- (void)didAddButtonWithCell:(VouchersBuyCollectionViewCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    VouchersBuyCellModel *cellModel = _viewModel.cellModels[indexPath.row];
    NSInteger count = cellModel.buyCount+1;
    if (count>cellModel.maxBuyCount) {
        return;
    }
    //清除旧的数据
    [self.viewModel clearBuyCount];
    self.diyTextField.text = @"";
    
    cellModel.buyCount = count;
    [self.collectionView reloadData];
    
    [self refreshSettlementView];
}

#pragma mark - VouchersDetailViewDelegate

- (void)vouchersDetailViewdidAdd:(VouchersBuyCellModel *)cellModel view:(VouchersDetailView *)vouchersDetailView{
    
    NSInteger count = cellModel.buyCount+1;
    if (count>cellModel.maxBuyCount) {
        return;
    }
    
    //清除旧的数据
    [self.viewModel clearBuyCount];
    self.diyTextField.text = @"";
    
    cellModel.buyCount = count;
    [vouchersDetailView refreshWithModel:cellModel];
    [self.collectionView reloadData];
    
    [self refreshSettlementView];
}

@end

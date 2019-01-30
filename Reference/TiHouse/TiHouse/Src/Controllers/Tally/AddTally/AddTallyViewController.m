//
//  MoneyRecordAddViewController.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddTallyViewController.h"
#import "CWNumberKeyboard.h"

#import "Login.h"

#import "TallyPaymentTypeView.h"
#import "AddTallySingleInputViewController.h"

#import "AddTallyViewCategoryCell.h"
#import "AddTallyViewTextCell.h"
#import "AddTallyViewDateSynchroCell.h"
#import "AddTallyViewGeneralCell.h"

#import "TallyDetail.h"
#import "Location.h"

#import "TallyBudgetView.h"

#import "HXPhotoPicker.h"
#import "TOCropViewController.h"
#import "AJLocationManager.h"
#import "AJRelayoutButton.h"

#import "AddTallyLocationViewController.h"
#import "TallyTimePickerView.h"

#import "LLPhotoBrowser.h"

#import <IQKeyboardManager.h>
#import "BudgetDetailsPreviewViewController.h"
#import "House.h"

#define DefaultCellHeight 50

@interface AddTallyViewController ()<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource,TOCropViewControllerDelegate,HXCustomCameraViewControllerDelegate,HXAlbumListViewControllerDelegate,AddTallyViewTextCellDelegate,AddTallyViewCategoryCellDelegate,AddTallyViewGeneralCellDelegate,AddTallyViewDateSynchroCellDelegate, LLPhotoBrowserDelegate>

@property (weak, nonatomic) UIView *headerView;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIImageView *arrowUpImageView;
@property (weak, nonatomic) UITextField *priceTextField;
@property (weak, nonatomic) UIView *bottomContainerView;
@property (weak, nonatomic) UIButton *categorySelectBtn;
@property (weak, nonatomic) UITextField *alertTextField;
@property (weak, nonatomic) UISegmentedControl *segmentedControl;

@property (strong, nonatomic) CWNumberKeyboard *numberKb;
@property (strong, nonatomic) TallyPaymentTypeView *addTallyPaymentTypeView;
@property (strong, nonatomic) TallyBudgetView *addTallyBudgetView;

@property (nonatomic) BOOL isExpanCategory; // 选择类别是否展开

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSMutableArray *uploadImgs;

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) NSMutableDictionary *cellHeightDic;

@property (strong, nonatomic) NSString *paymentTypeStr; // 支付途径
@property (assign, nonatomic) NSInteger paymentTypeIndex; // 支付途径index
@property (strong, nonatomic) NSString *budgetStr; // 预算名称
@property (assign, nonatomic) NSInteger budgetIndex; // 预算名称index
@property (assign, nonatomic) BOOL saveCompletion; // 保存完成
@property (assign, nonatomic) NSInteger saveCompletionCount; // 保存完成次数

@property (strong, nonatomic) NSMutableArray *tallyCategoryArray;
@property (strong, nonatomic) NSMutableArray *tallyBudgetArray;//已做预算数据

@end

@implementation AddTallyViewController

#pragma mark - init
+ (instancetype)initWithTallyId:(NSInteger)tallyId HouseId:(NSInteger)houseId House:(House*)house type:(AddTallyShowType)addTallyShowType {
    NSAssert(tallyId != 0, @"tallyId is 0");
    NSAssert(houseId != 0, @"houseId is 0");
    
    AddTallyViewController *vc = [[AddTallyViewController alloc] init];
    vc.tallyId = tallyId;
    vc.houseId = houseId;
    vc.house = house;
    vc.addTallyShowType = addTallyShowType;
    return vc;
}

#pragma mark- lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self setup];
    
    [self.tableView registerClass:[AddTallyViewGeneralCell class] forCellReuseIdentifier:@"cell_label"];
    [self.tableView registerClass:[AddTallyViewGeneralCell class] forCellReuseIdentifier:@"cell_images"];
    [self.tableView registerClass:[AddTallyViewDateSynchroCell class] forCellReuseIdentifier:@"cell_synchro"];
    [self.tableView registerClass:[AddTallyViewTextCell class] forCellReuseIdentifier:@"cell_text"];
    [self.tableView registerClass:[AddTallyViewCategoryCell class] forCellReuseIdentifier:@"cell_category"];
    
    [self loadTallyCategoryData:^{
        self.isExpanCategory = (self.addTallyShowType != AddTallyShowType_Show_Info);
    }];

    self.saveCompletionCount = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ((self.addTallyShowType == AddTallyShowType_Input_Text) && (!self.house || (self.house.uidcreater == [Login curLoginUser].uid))){
            [self showNumberPadAction:nil];
            [self.priceTextField becomeFirstResponder];
        }
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.completionBlock && self.saveCompletionCount) {
        self.completionBlock();
    }
}


- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)loadTallyCategoryData:(void(^)(void))block {
    // 获取记账类别
    [[TiHouse_NetAPIManager sharedManager] request_TallyTempletWithPath:@"api/inter/tallytemplet/listByTallyid" Params:@{@"tallyid":@(self.tallyId)} Block:^(id data, NSError *error) {
        [self.tallyCategoryArray removeAllObjects];
        [self.tallyCategoryArray addObjectsFromArray:data];
        
        if (block) {
            block();
        }
    }];
}

- (void)setup {
    [self addBasicView];
    
    [self prepareData];
    
    // 添加支出/退款
    [self addSegementControl];
    
    // bottomBtn
    if (!_house.uidcreater || (_house.uidcreater == [Login curLoginUser].uid)) {
        [self addBottomBtn];
    }
    
    // 删除按钮
    [self addTrashBtn];
    
    // close btn
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnAction)];
    
    [self prepareUI];
}

- (void)addBasicView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = YES;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavigationBarHeight);
        make.leading.trailing.equalTo(self.view);
    }];
    
    // header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 70)];
    [self.tableView setTableHeaderView:headerView];
    self.headerView = headerView;
    
    //
    UIImageView *arrowUpImageView = [UIImageView new];
    arrowUpImageView.image = [UIImage imageNamed:@"Tally_add_arrow_up_wh"];
    [self.headerView addSubview: arrowUpImageView];
    self.arrowUpImageView = arrowUpImageView;
    [arrowUpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerView).offset(10);
        make.width.and.height.equalTo(@10);
        make.centerY.equalTo(self.headerView);
    }];
    
    // Category Select Btn
    UIButton *categorySelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [categorySelectBtn setImage:[UIImage imageNamed:@"Tally_Add_SelectType"] forState:UIControlStateNormal];
    categorySelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [categorySelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [categorySelectBtn setTitle:@"选择类别和项目" forState:UIControlStateNormal];
    [categorySelectBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [categorySelectBtn addTarget:self action:@selector(typeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    categorySelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.headerView addSubview:categorySelectBtn];
    self.categorySelectBtn = categorySelectBtn;
    [categorySelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(arrowUpImageView.mas_trailing).offset(3);
        make.centerY.equalTo(self.headerView);
        make.trailing.equalTo(self.view.mas_centerX);
    }];
    [arrowUpImageView setContentHuggingPriority:UILayoutPriorityRequired
                              forAxis:UILayoutConstraintAxisHorizontal];
    [categorySelectBtn setContentHuggingPriority:UILayoutPriorityDefaultLow
                              forAxis:UILayoutConstraintAxisHorizontal];
    categorySelectBtn.titleLabel.lineBreakMode =  NSLineBreakByClipping;

    
    // textfeild
    UITextField *priceTextField = [UITextField new];
    priceTextField.font = [UIFont boldSystemFontOfSize:24];
    priceTextField.textColor = XWColorFromHex(0xF5A623);
    priceTextField.text = @"￥0";
    priceTextField.textAlignment = NSTextAlignmentRight;
    priceTextField.delegate = self;
    [self.headerView addSubview:priceTextField];
    self.priceTextField = priceTextField;
    [priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.headerView).offset(-13);
        make.centerY.equalTo(self.headerView);
        make.width.equalTo(@(kScreen_Width/2));
    }];

    // btn
    UIButton *btnMask = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMask.backgroundColor = [UIColor clearColor];
    if (!_house.uidcreater || (_house.uidcreater == [Login curLoginUser].uid)) {
        [btnMask addTarget:self action:@selector(showNumberPadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.headerView addSubview:btnMask];
    [btnMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self.priceTextField);
    }];
    
    // line
    UIView *line = [UIView new];
    line.backgroundColor = XWColorFromHex(0xDADADA);
    [self.headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.leading.trailing.bottom.equalTo(self.headerView);
    }];
    
    UIView *bottomContainerView = [UIView new];
    bottomContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomContainerView];
    self.bottomContainerView = bottomContainerView;
    [bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
    }];
    UIColor *clr = [UIColor lightGrayColor];
    self.bottomContainerView.layer.shadowColor = clr.CGColor;
    self.bottomContainerView.layer.shadowOffset = CGSizeMake(0,-2);
    self.bottomContainerView.layer.shadowOpacity = 0.3;
}

- (void)prepareData {
    // 数据
    if (self.tallyDetail == nil ) {
        self.tallyDetail = [TallyDetail new];
        self.tallyDetail.tallyprotype = 1;// 默认支出
    }
    
    if (self.addTallyShowType == AddTallyShowType_Show_Info) {
        // 编辑模式
        self.tallyDetail.isEdit = YES;
    } else {
        NSDate *date = [NSDate date];
        self.tallyDetail.tallyprotime = [NSDate timestampFromDate:date];
        self.tallyDetail.tallyid = self.tallyId;
    }

    // 支付途径
    self.paymentTypeIndex = -1;
    self.budgetIndex = -1;
    
    // init
    self.isExpanCategory = NO;
    
    // array
    _titleArray = @[@"time",
                    @"输入文字",
                    @"同步",
                    @"品牌(售后维修必要信息)",
                    @"型号(售后维修必要信息)",
                    @"上传图片或发票凭证",
                    @"显示地理位置",
                    @"记录支付途径",
                    @"查看已做预算"];
    
    // img
    [self.uploadImgs removeAllObjects];
    
    // 初始化cell 高度
    [self.cellHeightDic setObject:@(DefaultCellHeight) forKey:@"0_0"];
    for (int i = 0 ; i < _titleArray.count; i++) {
        NSString *key = [NSString stringWithFormat:@"1_%d",i]; // section_cellIndex
        if (i == 2) {
            // 同步日程默认不显示
            [self.cellHeightDic setObject:@(0) forKey:key];
        } else {
            [self.cellHeightDic setObject:@(DefaultCellHeight) forKey:key];
        }
        
    }
}

- (void)prepareUI {
    // 初始化显示
    self.priceTextField.text = [NSString stringWithFormat:@"￥%.f", self.tallyDetail.doubleamountzj];
    
    // 设置分类选择按钮信息
    [self categorySelectBtnInfo:self.tallyDetail.tallyprocatename cateoneid:self.tallyDetail.cateoneid];
    
    // 必要数据初始化
    self.segmentedControl.selectedSegmentIndex = (self.tallyDetail.tallyprotype-1);
    
    // 颜色
    self.priceTextField.textColor = self.segmentedControl.selectedSegmentIndex == 0?XWColorFromHex(0xF5A623):XWColorFromHex(0x04c85d);
    
    // 图片选择器
    [[self manager] clearSelectedList];
}

- (void)addTrashBtn {
    // 如果是查看，显示删除按钮
    if ((self.addTallyShowType == AddTallyShowType_Show_Info) && (_house.uidcreater == [Login curLoginUser].uid)) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Tally_icon_trash"] style:UIBarButtonItemStylePlain target:self action:@selector(trashBtnAction)];
    }
}

- (void)addBottomBtn {
    
    
    if (self.addTallyShowType == AddTallyShowType_Input_Text || self.addTallyShowType == AddTallyShowType_Input_Voice) {
        // 保存、再记一笔
        // 重录、保存
        NSString *leftBtnTitle = @"保存";
        NSString *rightBtnTitle = @"再记一笔";
        if (self.addTallyShowType == AddTallyShowType_Input_Voice) {
            leftBtnTitle = @"重录";
            rightBtnTitle = @"保存";
        }
        
        
        AJRelayoutButton *rightBtn = [AJRelayoutButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:[UIImage imageNamed:@"Tally_add_second_indicator"] forState:UIControlStateNormal];
        [rightBtn setTitle:rightBtnTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:XWColorFromHex(0x606060) forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnTallyDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomContainerView addSubview:rightBtn];
        rightBtn.style = AJButtonLayoutStyleBottom;
        rightBtn.space = 5;
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.top.and.bottom.equalTo(self.bottomContainerView);
        }];
        AJRelayoutButton *leftBtn = [AJRelayoutButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:@"Tally_add_second_indicator"] forState:UIControlStateNormal];
        [leftBtn setTitle:leftBtnTitle forState:UIControlStateNormal];
        [leftBtn setTitleColor:XWColorFromHex(0x606060) forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [leftBtn addTarget:self action:@selector(leftBtnTallyDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomContainerView addSubview:leftBtn];
        leftBtn.style = AJButtonLayoutStyleBottom;
        leftBtn.space = 5;
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.trailing.and.top.and.bottom.equalTo(self.bottomContainerView);
            make.leading.equalTo(rightBtn.mas_trailing);
            make.width.equalTo(rightBtn);
        }];
    } else if (self.addTallyShowType == AddTallyShowType_Show_Info || self.addTallyShowType == AddTallyShowType_Input_Word) {
        AJRelayoutButton *leftBtn = [AJRelayoutButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:@"Tally_add_second_indicator"] forState:UIControlStateNormal];
        [leftBtn setTitle:@"保存" forState:UIControlStateNormal];
        [leftBtn setTitleColor:XWColorFromHex(0x606060) forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnTallyDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomContainerView addSubview:leftBtn];
        leftBtn.style = AJButtonLayoutStyleBottom;
        leftBtn.space = 5;
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bottomContainerView);
        }];
    }
}


// addSegementControl
- (void)addSegementControl {
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"支出", @"退款"]];
    segment.frame = CGRectMake(0, 0, 111, 30);
    [segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = [UIColor whiteColor];
    UIColor *selectedColor = XWColorFromHex(0x434248);
    UIColor *normalColor = XWColorFromHex(0x9a98a1);
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:selectedColor}forState:UIControlStateSelected];
    self.navigationItem.titleView = segment;
    segment.selectedSegmentIndex = (self.tallyDetail.tallyprotype-1);
    if (_house.uidcreater && (_house.uidcreater != [Login curLoginUser].uid)) {
        segment.userInteractionEnabled = NO;
    }
    self.segmentedControl = segment;
}

#pragma mark - Action
- (void)leftBtnTallyDetailAction:(UIButton *)sender {
    if (self.addTallyShowType == AddTallyShowType_Input_Voice) {
        // 重录
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // 保存
        [self saveTallyDetail:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
}

- (void)rightBtnTallyDetailAction:(UIButton *)sender {
    if (self.addTallyShowType == AddTallyShowType_Input_Voice || self.addTallyShowType == AddTallyShowType_Input_Word) {
        // 保存
        [self saveTallyDetail:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    } else {
        // 再记一笔
        [self saveTallyDetail:^{
            // 清理数据
            self.tallyDetail = nil;
            
            [self prepareData];
            [self prepareUI];
            
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.isExpanCategory = YES;//展开分类选择
                
                [self showNumberPadAction:nil];//默认弹出数字输入部分
                [self.priceTextField becomeFirstResponder];
            });
            
        }];
    }
}

- (void)saveTallyDetail:(void(^)(void))block {
    
    NSString *str = self.priceTextField.text;
    if ([str containsString:@"￥"]) {
        NSRange ran = [str rangeOfString:@"￥"];
        str = [str substringFromIndex: (ran.location + ran.length)];
    }
    self.tallyDetail.amountzj = [str integerValue];
    
    // 校验必须值
    NSString *validStr = [self.tallyDetail validPostParams];
    if (validStr.length > 0) {
        [NSObject showHudTipStr:validStr];
        return;
    }
    
    // post
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[TiHouse_NetAPIManager sharedManager] request_AddTallyPro:self.tallyDetail Block:^(id data, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data intValue]) {
            [NSObject showHudTipStr:@"保存成功"];
            
            self.saveCompletionCount++;
            
            if (block) {
                block();
            }
        } else {
            NSLog(@"保存错误！");
        }
    }];
}

- (void)closeBtnAction {
    if (!self.saveCompletion && self.addTallyShowType != AddTallyShowType_Show_Info) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"记录尚未保存，确定退出？" message:nil preferredStyle:
                                      UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:action2];
        [alertVc addAction:action1];
        [action1 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
        [action2 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
        [self presentViewController:alertVc animated:YES completion:nil];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)trashBtnAction {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确定删除此项目吗？" message:nil preferredStyle:
                                  UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[TiHouse_NetAPIManager sharedManager] request_RemoveTallyProWithId:self.tallyDetail.tallyproid  tallyId:self.tallyDetail.tallyid Block:^(id data, NSError *error) {
            if ([data intValue] > 0) {
                [NSObject showHudTipStr:@"删除成功！"];
                self.saveCompletionCount++;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:action2];
    [alertVc addAction:action1];
    [action1 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    [action2 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

- (void)segmentChange:(UISegmentedControl *)sender {
    // 明细类型，1支出2退款
    self.tallyDetail.tallyprotype = sender.selectedSegmentIndex + 1;
    
    self.priceTextField.textColor = self.segmentedControl.selectedSegmentIndex == 0?XWColorFromHex(0xF5A623):XWColorFromHex(0x04c85d);
}

- (void)typeBtnAction:(id)sender {
    if (_house.uidcreater == [Login curLoginUser].uid) {
        self.isExpanCategory = !self.isExpanCategory;
        
        if (self.isExpanCategory) {
            [self.view endEditing:YES];
        }
    }
}

- (void)setIsExpanCategory:(BOOL)isExpanCategory {
    _isExpanCategory = isExpanCategory;
    CGFloat angle = 0;
    if (isExpanCategory) {
        angle = M_PI;
    }
    // 指示标记
    [UIView animateWithDuration:0.3 animations:^{
        self.arrowUpImageView.layer.affineTransform = CGAffineTransformMakeRotation(angle);
    }];
    
    // load
//    [self.tableView reloadData];
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)showNumberPadAction:(id)sender {
//    if (_house.uidcreater != [Login curLoginUser].uid) {
//        return;
//    }

    self.priceTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    if (!_numberKb) {
        _numberKb = [[CWNumberKeyboard alloc] init];
        [self.view addSubview:_numberKb];
    }
    [_numberKb setHidden:NO];
    [_numberKb showNumKeyboardViewAnimateWithTextField:self.priceTextField andBlock:^(NSString *priceString) {
        NSLog(@"%@", priceString);
    }];
}

// 设置类别选择按钮信息
- (void)categorySelectBtnInfo:(NSString *)categoryStr cateoneid:(NSInteger)cateoneid {
    if (categoryStr.length == 0) {
        [self.categorySelectBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"选择类别和项目"] forState:UIControlStateNormal];
        [self.categorySelectBtn setImage:[UIImage imageNamed:@"Tally_Add_SelectType"] forState:UIControlStateNormal];
        return;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:categoryStr];
    
    NSRange rang = [categoryStr rangeOfString:@"-"];
    if (rang.length > 0) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(rang.location, attrStr.length - rang.location)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(rang.location, attrStr.length - rang.location)];
    }
    [self.categorySelectBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    
    // 设置选中的图标
    if (cateoneid) {
        UIImage *icon = [self selectedCategoryIcon:[NSString stringWithFormat:@"%ld",cateoneid]];
        [self.categorySelectBtn setImage:icon forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!_house.uidcreater || (_house.uidcreater == [Login curLoginUser].uid)) {
        [self showNumberPadAction:nil];
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.alertTextField.text.length > 6){
        textField.text = [self.alertTextField.text substringWithRange:NSMakeRange(0, 6)];
    }
}

#pragma mark - AddTallyViewGeneralCellDelegate
- (void)showImagesBrower {
    NSMutableArray *urlArray = [NSMutableArray array];
    if (self.uploadImgs.count > 0) {
        urlArray = self.uploadImgs;
    } else if (self.tallyDetail.arrurlcert.length > 0) {
        [urlArray addObjectsFromArray:[self.tallyDetail.arrurlcert componentsSeparatedByString:@","]];
        for (id url in urlArray) {
            if ([(NSString *)url length] == 0) {
                [urlArray removeObject:url];
            }
        }
        
    }else{
        return;
    }
    
    LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc] initWithImages:urlArray currentIndex:0];
    photoBrowser.delegate = self;
    [self presentViewController:photoBrowser animated:YES completion:nil];

}

- (void)addImage {
    [self selectPhotoShow];
}

#pragma mark - LLPhotoBrowserDelegate
- (void)photoBrowser:(LLPhotoBrowser *)photoBrowser didSelectImage:(NSArray *)image {
    NSLog(@"编辑后的图片:%@",image);
    [self.uploadImgs removeAllObjects];
    
    if ([image count] == 0) {
        self.tallyDetail.arrurlcert = @"";
        
    }else{
        [self.uploadImgs addObjectsFromArray:image];
    }
    self.tallyDetail.imageArray = self.uploadImgs;
    [self.tableView reloadData];
    
}

#pragma mark - AddTallyViewCellProtocol
- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) {
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld_%ld", indexPath.section, indexPath.row];
    self.cellHeightDic[key] = @(height);
}

#pragma mark - AddTallyViewTextCellDelegate
- (void)addTallyViewTextCell:(UITableViewCell *)cell textViewDidChange:(NSString *)text {
    self.tallyDetail.tallyproremark = text;
}

#pragma mark - AddTallyViewCategoryCellDelegate
- (void)addTallyViewCategoryCellAddProjectAction:(UITableViewCell *)cell catetwoid:(NSInteger)catetwoid {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请输入名称" message:nil preferredStyle:
                                  UIAlertControllerStyleAlert];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"最多支持6个字";
        self.alertTextField = textField;
        [self.alertTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [[self.alertTextField superview] superview].layer.cornerRadius = 5;
        [[self.alertTextField superview] superview].layer.borderColor = XWColorFromHex(0xececec).CGColor;
        self.alertTextField.tag = 100;
        [self.alertTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        
        NSLayoutConstraint *h = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35];
        [textField addConstraint:h];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ok, %@", [[alertVc textFields] objectAtIndex:0].text);
        if ([[alertVc textFields] objectAtIndex:0].text.length > 6) {
            [MBProgressHUD showHudTipStr:@"最多支持6个字"];
            return ;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"tallyid"] = @(self.tallyId);
        params[@"catename"] = [[alertVc textFields] objectAtIndex:0].text;
        params[@"catetwoid"] = @(catetwoid);
        
        [[TiHouse_NetAPIManager sharedManager] request_AddTallyTempletWidthParams:params Block:^(id data, NSError *error) {
            if ([data intValue] > 0) {
                
                [MBProgressHUD showHudTipStr:@"添加成功"];
                
                // 添加成功后刷新
                [self loadTallyCategoryData:^{
                    [self.tableView reloadData];
                }];
            } else {
                
                [MBProgressHUD showHudTipStr:[error userInfo][@"msg"]];
            }
        }];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:action2];
    [alertVc addAction:action1];
    [action1 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    [action2 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)addTallyViewCategoryCellSelected:(AddTallyViewCategoryCell *)cell categoryStr:(NSString *)categoryStr {
    NSLog(@"%@", categoryStr);

    [self categorySelectBtnInfo:categoryStr cateoneid:cell.category1.cateoneid];
    
    NSString *tempStr = categoryStr;
    if ([categoryStr containsString:@"-"] && [categoryStr containsString:@"·"]) {
        tempStr = [[categoryStr componentsSeparatedByString:@"-"] objectAtIndex:0];
    }else{
        if ([categoryStr containsString:@"-"]){
            tempStr = [[categoryStr componentsSeparatedByString:@"-"] objectAtIndex:0];
        }else{
            tempStr = [[categoryStr componentsSeparatedByString:@"·"] objectAtIndex:0];
        }
    }
    
    self.tallyDetail.tallyprocatename = tempStr;
    self.tallyDetail.catetwoid = cell.category3.catetwoid;
    self.tallyDetail.catethreeid = cell.category3.catethreeid;
}

#pragma mark - AddTallyViewDateSynchroCellDelegate
- (void)addTallyViewDateSynchroCellTimeSynchro:(UITableViewCell *)cell {
    NSLog(@"同步到日程管理");
}

#pragma mark - HXAlbumListViewControllerDelegate
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    NSLog(@"%@", photoList);
    if (photoList) {

        [self.uploadImgs removeAllObjects];
        
        //重复添加已存在的图片进入
        AddTallyViewGeneralCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];
        for (UIImageView *img in [cell1.imgsContainer subviews]) {
            if (img != nil && img.tag == 56) {
                [self.uploadImgs addObject:img.image];
            }
        }

        //遍历照片判断是否是不同日期的
        [photoList enumerateObjectsUsingBlock:^(HXPhotoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = obj.asset;
            if (asset) {
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                // 同步获得图片, 只会返回1张图片
                options.synchronous = YES;
                CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    [self.uploadImgs addObject:result];
                }];
            }
        }];
//        //新选择的图片
//        for (HXPhotoModel *photoModel in photoList) {
//            if (!photoModel.previewPhoto) {
//                photoModel.previewPhoto = photoModel.thumbPhoto;
//            }
//            [self.uploadImgs addObject:photoModel.previewPhoto];
//        }

        self.tallyDetail.imageArray = self.uploadImgs;

        // load
        [self.tableView reloadData];
        
        [self.manager clearSelectedList];//清空图片选择器内已选过的，允许重复选择
    }
}

#pragma mark - TOCropViewControllerDelegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    [self.uploadImgs removeAllObjects];
    [self.uploadImgs addObject:image];
    [cropViewController.navigationController popViewControllerAnimated:YES];
    
    self.tallyDetail.imageArray = self.uploadImgs;
    
    // load
    [self.tableView reloadData];
}

#pragma mark - HXCustomCameraViewControllerDelegate
- (void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model {
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.previewPhoto];
    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
    cropController.aspectRatioLockEnabled = YES;
    cropController.resetAspectRatioEnabled = NO;
    cropController.delegate = self;
    cropController.doneButtonTitle = @"完成";
    cropController.cancelButtonTitle = @"取消";
    [self.navigationController pushViewController:cropController animated:NO];
}

#pragma mark - UITablViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return _titleArray.count;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        // 类别选择
        AddTallyViewCategoryCell *cell1 = [tableView addTallyViewCategoryCellWithId:@"cell_category"];
        cell1.delegate = self;
        cell1.indexPath = indexPath;
        [cell1 setCategoryId:self.tallyDetail.cateoneid catetwoid:self.tallyDetail.catetwoid catethreeid:self.tallyDetail.catethreeid];
        cell1.data = self.tallyCategoryArray;
        if ((_house.uidcreater != [Login curLoginUser].uid) && (self.addTallyShowType == AddTallyShowType_Show_Info)) {
            cell1.disabled = YES;
            cell1.userInteractionEnabled = NO;
        }
        cell = cell1;
    } else {
        if (row == 0) {
            // 时间
            AddTallyViewGeneralCell *cell1 = (AddTallyViewGeneralCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_label"];
            cell1.indexPath = indexPath;
            NSString *time = [NSDate timeStringFromTimestamp:self.tallyDetail.tallyprotime formatter:@"yyyy年MM月dd日 HH:mm"];
            [cell1 setCellTextInfo:@"Tally_add_icon_timer" title:time];
            cell1.activate = YES;
            cell1.editing = NO;
            if ((_house.uidcreater != [Login curLoginUser].uid) && (self.addTallyShowType == AddTallyShowType_Show_Info)) {
                cell1.disabled = YES;
                cell1.userInteractionEnabled = NO;
            }
            cell = cell1;
        } else if (row == 1) {
            // 备注
            AddTallyViewTextCell *cell1 = [tableView addTallyViewTextCellWithId:@"cell_text"];
            cell1.indexPath = indexPath;
            cell1.delegate = self;
            cell1.iconImageView.image = [UIImage imageNamed:@"Tally_add_icon_remark"];
            cell1.text = self.tallyDetail.tallyproremark;
            if ((_house.uidcreater != [Login curLoginUser].uid) && (self.addTallyShowType == AddTallyShowType_Show_Info)) {
                cell1.disabled = YES;
            }
            //cell1.isFromVoice = (self.addTallyShowType == AddTallyShowType_Input_Voice);
            cell = cell1;
        } else if (row == 2) {
            // 日程同步
            AddTallyViewDateSynchroCell *cell1 = [tableView addTallyViewDateSynchroCellWithId:@"cell_synchro"];
            cell1.delegate = self;
            cell1.indexPath = indexPath;
            [cell1 setCellInfo:self.tallyDetail.isSynchronDate];
            if ((_house.uidcreater != [Login curLoginUser].uid) && (self.addTallyShowType == AddTallyShowType_Show_Info)) {
                cell1.disabled = YES;
                cell1.userInteractionEnabled = NO;
            }
            cell = cell1;
        } else if (row == 3) {
            // 品牌
            AddTallyViewGeneralCell *cell1 = (AddTallyViewGeneralCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_label"];
            cell1.indexPath = indexPath;
            [cell1 setCellTextInfo:@"Tally_add_icon_brand" title:self.tallyDetail.tallyprobrand.length > 0?self.tallyDetail.tallyprobrand:_titleArray[row]];
            cell1.activate = self.tallyDetail.tallyprobrand.length > 0;
            if ((_house.uidcreater != [Login curLoginUser].uid) && (self.addTallyShowType == AddTallyShowType_Show_Info)) {
                cell1.disabled = YES;
                cell1.userInteractionEnabled = NO;
            }
            cell = cell1;
        } else if (row == 4) {
            // 型号
            AddTallyViewGeneralCell *cell1 = (AddTallyViewGeneralCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_label"];
            cell1.indexPath = indexPath;
            [cell1 setCellTextInfo:@"Tally_add_icon_model" title:self.tallyDetail.tallyproxh.length > 0?self.tallyDetail.tallyproxh:_titleArray[row]];
            cell1.activate = self.tallyDetail.tallyproxh.length > 0;
            if ((_house.uidcreater != [Login curLoginUser].uid) && (self.addTallyShowType == AddTallyShowType_Show_Info)) {
                cell1.disabled = YES;
                cell1.userInteractionEnabled = NO;
            }
            cell = cell1;
        } else if (row == 5) {
            // 图片
            AddTallyViewGeneralCell *cell1 = [tableView addTallyViewGeneralCellWithId:@"cell_images"];
            cell1.delegate = self;
            cell1.indexPath = indexPath;
            cell1.iconImageView.image = [UIImage imageNamed:@"Tally_add_icon_camera"];
            BOOL show = YES;
            if ((_house.uidcreater && (_house.uidcreater != [Login curLoginUser].uid)) && (self.addTallyShowType == AddTallyShowType_Show_Info)) {
                show = NO;
            }
            if (self.uploadImgs.count > 0) {
                [cell1 setCellImagesInfo:self.uploadImgs showAdd:show];
            } else if (self.tallyDetail.arrurlcert.length > 0) {
                NSArray *urlArray = [self.tallyDetail.arrurlcert componentsSeparatedByString:@","];
                [cell1 setCellImagesInfo:urlArray showAdd:show];
            } else {
                [cell1 setCellTextInfo:@"Tally_add_icon_camera" title:_titleArray[row]];
            }
            if ((_house.uidcreater && (_house.uidcreater != [Login curLoginUser].uid)) && (self.addTallyShowType == AddTallyShowType_Show_Info)) {
                cell1.disabled = YES;
            }
            cell = cell1;
        } else if (row == 6) {
            // 显示地理位置
            AddTallyViewGeneralCell *cell1 = (AddTallyViewGeneralCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_label"];
            cell1.indexPath = indexPath;
            [cell1 setCellTextInfo:@"Tally_add_icon_location" title:self.tallyDetail.locationname.length>0?self.tallyDetail.locationname:_titleArray[row]];
            cell1.activate = self.tallyDetail.locationname.length > 0;
            if ((_house.uidcreater != [Login curLoginUser].uid) && (self.addTallyShowType == AddTallyShowType_Show_Info)) {
                cell1.disabled = YES;
                cell1.userInteractionEnabled = NO;
            }
            cell = cell1;
        } else if (row == 7) {
            // 支付途径
            AddTallyViewGeneralCell *cell1 = (AddTallyViewGeneralCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_label"];
            cell1.indexPath = indexPath;
            [cell1 setCellTextInfo:@"Tally_add_icon_wallet" title:self.tallyDetail.paywayname.length > 0?self.tallyDetail.paywayname:_titleArray[row]];
            cell1.activate = self.tallyDetail.paywayname.length > 0;
            if ((_house.uidcreater != [Login curLoginUser].uid) && (self.addTallyShowType == AddTallyShowType_Show_Info)) {
                cell1.disabled = YES;
                cell1.userInteractionEnabled = NO;
            }
            cell = cell1;
        } else if (row == 8) {
            // 查看已做预算
            AddTallyViewGeneralCell *cell1 = (AddTallyViewGeneralCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_label"];
            cell1.indexPath = indexPath;
            [cell1 setCellTextInfo:@"Tally_add_icon_budget" title:_titleArray[row]];
            if ((_house.uidcreater != [Login curLoginUser].uid) && (self.addTallyShowType == AddTallyShowType_Show_Info)) {
                cell1.disabled = YES;
                cell1.userInteractionEnabled = NO;
            }
            cell = cell1;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_label"];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil ) {
        return DefaultCellHeight;
    }
    NSString *key = [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, indexPath.row];
    CGFloat height = [[self.cellHeightDic objectForKey:key] floatValue];
    NSLog(@"%@:%f",key,height);
    
    if (indexPath.section == 0) {
        return self.isExpanCategory?height:0;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    
    NSInteger index = indexPath.row;
    
    if (index == 0) {
        WEAKSELF
        TallyTimePickerView *t = [[TallyTimePickerView alloc] initWithFrame:CGRectZero];
        [t show:^(NSString *timeString, NSDate *date) {
            weakSelf.tallyDetail.tallyprotime = [NSDate timestampFromDate:date];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    if (index == 3 || index == 4 ) {
        WEAKSELF
        AddTallySingleInputViewController *inputVC = [AddTallySingleInputViewController new];
        inputVC.inputType = index == 3?Input_Brand:Input_Model;
        inputVC.text = index == 3? self.tallyDetail.tallyprobrand : self.tallyDetail.tallyproxh;
        inputVC.saveCompletionBlock = ^(NSString *textString) {
            
            if (inputVC.inputType == Input_Brand) {
                weakSelf.tallyDetail.tallyprobrand = textString;
            } else {
                weakSelf.tallyDetail.tallyproxh = textString;
            }

            [weakSelf.tableView reloadData];
        };
        
        [self.navigationController pushViewController:inputVC animated:YES];
    }
    
    if (index == 5) {
        if (!_house || (_house.uidcreater == [Login curLoginUser].uid)) {
            [self selectPhotoShow];
        }
    }
    
    if (index == 7) {
        if (!_addTallyPaymentTypeView) {
            WEAKSELF
            _addTallyPaymentTypeView = [[TallyPaymentTypeView alloc] init];
            _addTallyPaymentTypeView.selectedBlock = ^(NSInteger index, NSString *paymentType) {
                weakSelf.paymentTypeStr = paymentType;
                weakSelf.tallyDetail.paywayname = paymentType;
                weakSelf.paymentTypeIndex = index;
                // 刷新
                [weakSelf.tableView reloadData];
            };
            [self.navigationController.view addSubview:_addTallyPaymentTypeView];
        }
        [_addTallyPaymentTypeView setHidden:NO];
        _addTallyPaymentTypeView.selectedIndex = self.paymentTypeIndex;
        [_addTallyPaymentTypeView show];
    }
    if (index == 6) {
        // 地理位置
        WEAKSELF
        AddTallyLocationViewController *vc = [[AddTallyLocationViewController alloc] init];
        vc.block = ^(Location *location) {
            if (location) {
                weakSelf.tallyDetail.locationlat = [location.lat floatValue];
                weakSelf.tallyDetail.locationlng = [location.lng floatValue];
                weakSelf.tallyDetail.locationname = location.name;
                
            } else {
                weakSelf.tallyDetail.locationlat = 0;
                weakSelf.tallyDetail.locationlng = 0;
                weakSelf.tallyDetail.locationname = nil;
            }
            // 刷新
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 8){
        WEAKSELF
        // 获取记账类别
        [[TiHouse_NetAPIManager sharedManager] requestBudgetlist:self.houseId Block:^(id data, NSError *error) {
            
            if ([data count] > 0) {
                if (!_addTallyBudgetView) {
                    
                    _addTallyBudgetView = [[TallyBudgetView alloc] init];

                    [_addTallyBudgetView setSelectedBlock:^(Budget *budget) {
                        
                        [weakSelf.addTallyBudgetView bgViewTapAction];
                        
                        BudgetDetailsPreviewViewController *newBudgetVC = [[BudgetDetailsPreviewViewController alloc]init];
                        newBudgetVC.budget = budget;
                        House *house = [[House alloc] init];
                        house.houseid = weakSelf.houseId;
                        newBudgetVC.house = house;
                        [weakSelf.navigationController pushViewController:newBudgetVC animated:YES];
                    }];

                    [weakSelf.navigationController.view addSubview:_addTallyBudgetView];
                }
                [_addTallyBudgetView setHidden:NO];
                _addTallyBudgetView.selectedIndex = weakSelf.budgetIndex;
                _addTallyBudgetView.budgetArray = data;
                [_addTallyBudgetView show];
            }else{
                [NSObject showHudTipStr:@"没有预算数据！"];
            }
        }];
        
        
        
    }
}

- (void)selectPhotoShow {
    
//    if (self.isExpanCategory) {
//        self.isExpanCategory = !self.isExpanCategory;
//    }
    
//    WEAKSELF
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"从手机相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf hx_presentAlbumListViewControllerWithManager:weakSelf.manager delegate:weakSelf];
//    }];
//    [action setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf hx_presentCustomCameraViewControllerWithManager:weakSelf.manager delegate:weakSelf];
//    }];
//    [action1 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
//    [action2 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
//
//    [alert addAction:action1];
//    [alert addAction:action];
//    [alert addAction:action2];
//    [self presentViewController:alert animated:YES completion:nil];
    
    [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
}

#pragma mark - getter
- (HXPhotoManager *)manager {
    
    NSInteger uploadPhotoMaxNum = 4;
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.deleteTemporaryPhoto = NO;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.openCamera = YES;

        //        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.singleSelected = NO;//是否单选
        _manager.configuration.supportRotation = NO;
        
        _manager.configuration.cameraCellShowPreview = NO;
        _manager.configuration.themeColor = kRKBNAVBLACK;
        _manager.configuration.navigationBar = ^(UINavigationBar *navigationBar) {
            navigationBar.barTintColor = kRKBNAVBLACK;
        };
        _manager.configuration.sectionHeaderTranslucent = NO;
        _manager.configuration.sectionHeaderSuspensionBgColor = kRKBViewControllerBgColor;
        _manager.configuration.sectionHeaderSuspensionTitleColor = XWColorFromHex(0x999999);
        _manager.configuration.statusBarStyle = UIStatusBarStyleDefault;
        _manager.configuration.selectedTitleColor = kRKBNAVBLACK;
        
        _manager.configuration.hideOriginalBtn = YES;
        _manager.configuration.photoListBottomView = ^(HXDatePhotoBottomView *bottomView) {
            bottomView.editBtn.hidden = YES;
        };
        
        _manager.configuration.previewBottomView = ^(HXDatePhotoPreviewBottomView *bottomView) {
            bottomView.doneBtn.backgroundColor = kTiMainBgColor;
        };
        
    }
    
    if (self.uploadImgs.count > 0) {
        uploadPhotoMaxNum -= self.uploadImgs.count;
    } else if (self.tallyDetail.arrurlcert.length > 0) {
        NSArray *urlArray = [self.tallyDetail.arrurlcert componentsSeparatedByString:@","];
        uploadPhotoMaxNum -= urlArray.count;
    }
    
    _manager.configuration.photoMaxNum = uploadPhotoMaxNum;
    
    return _manager;
}

- (NSMutableArray *)uploadImgs {
    if (!_uploadImgs) {
        _uploadImgs = [NSMutableArray array];
    }
    return _uploadImgs;
}

- (NSMutableDictionary *)cellHeightDic {
    if (!_cellHeightDic) {
        _cellHeightDic = [NSMutableDictionary dictionary];
    }
    return _cellHeightDic;
}

- (NSMutableArray *)tallyCategoryArray {
    if (!_tallyCategoryArray) {
        _tallyCategoryArray = [NSMutableArray array];
    }
    return _tallyCategoryArray;
}

- (NSMutableArray *)tallyBudgetArray {
    if (!_tallyBudgetArray) {
        _tallyBudgetArray = [NSMutableArray array];
    }
    return _tallyBudgetArray;
}

- (UIImage *)selectedCategoryIcon:(NSString *)categoryId {
    NSDictionary *iconDic = @{@"1":@"Tally_add_icon_selectType1",
                                 @"2":@"Tally_add_icon_selectType2",
                                 @"3":@"Tally_add_icon_selectType3",
                                 @"4":@"Tally_add_icon_selectType4",
                                 @"5":@"Tally_add_icon_selectType5"
                                 };
    NSString *imgName = [iconDic objectForKey:categoryId];
    if (imgName == nil) {
        imgName = @"Tally_add_selectType";
    }
    
    return [UIImage imageNamed:imgName];
    
}

- (BOOL)saveCompletion {
    if (self.tallyDetail.tallyprocatename.length > 0
        || self.tallyDetail.tallyproremark.length > 0
        || self.tallyDetail.tallyprobrand.length > 0
        || self.tallyDetail.tallyproxh.length > 0
        || self.tallyDetail.imageArray.count > 0
        || self.tallyDetail.paywayname.length > 0
        || self.tallyDetail.amountzj > 0) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    NSInteger kMaxLength = 6;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}


@end

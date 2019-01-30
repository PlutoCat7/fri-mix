//
//  AccountBooksSearchViewController.m
//  TiHouse
//
//  Created by gaodong on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AccountBooksSearchViewController.h"
#import "TimeLineHeadView.h"
#import "TimeLineTableViewCell.h"

#import "TallyDetail.h"
#import "NSDate+Extend.h"
#import <IQKeyboardManager.h>

static NSString *kCell = @"cell";
static NSString *kHeadview = @"headview";

@interface AccountBooksSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSMutableArray *dayArr;

@property (weak, nonatomic) IBOutlet UITextField *textKeyword;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;


@end

@implementation AccountBooksSearchViewController

#pragma mark - init
+ (instancetype)initWithStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountBooks" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"AccountBooksSearchViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账本搜索";
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dayArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.listData = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.listView registerClass:[TimeLineTableViewCell class] forCellReuseIdentifier:kCell];
    self.textKeyword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    self.textKeyword.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_textKeyword becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TimeLineHeadView *headView = [[TimeLineHeadView alloc] initWithFrame:CGRectZero];
    
    NSDate *d = [NSDate dateWithString:[self.dayArr objectAtIndex:section] format:@"yyyy-MM-dd"];
    
    headView.day.text = [NSString stringWithFormat:@"%lu月%lu日", d.month, d.day];
    headView.week.text = [NSString stringWithFormat:@"·%@", [NSDate dayFromWeekday:d]];
    [headView setFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    
    return headView;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell];
    if (!cell) {
        cell = [[TimeLineTableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    }
    
    NSDictionary *dic = [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    TallyDetail *tDetail = [TallyDetail mj_objectWithKeyValues:dic];
    cell.tDetail = tDetail;
    cell.showMoney = YES;
    if ([tDetail.arrurlcert length] > 0) {
        NSArray *imgArr = [tDetail.arrurlcert componentsSeparatedByString:@","];
        if ([imgArr count] > 0) {
            [cell.Img sd_setImageWithURL:[NSURL URLWithString:imgArr[0]]];
        }
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSDictionary *dic = [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    TallyDetail *tDetail = [TallyDetail mj_objectWithKeyValues:dic];
    return [TimeLineTableViewCell getCellHeightWithDetail:tDetail];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dayArr count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.listData objectAtIndex:section] count];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textKeyword resignFirstResponder];
    if ([self.tallyproArr count] > 0 && [self.textKeyword.text length] > 0) {
        [self.dayArr removeAllObjects];
        [self.listData removeAllObjects];
        [self sortListData:self.tallyproArr];
        [self.listView reloadData];
    }
    
    return YES;
}

#pragma mark - action
- (IBAction)cancelAction:(UIButton *)sender {
    self.textKeyword.text = @"";
    [self.textKeyword resignFirstResponder];
    [self.dayArr removeAllObjects];
    [self.listData removeAllObjects];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - data
- (void)sortListData:(NSArray *)data{
    
    NSMutableArray *resultArray = [NSMutableArray array];

    for (NSDictionary *dic in data) {

        if ([[dic valueForKey:@"tallyprocatename"] rangeOfString:self.textKeyword.text].location != NSNotFound || [[dic valueForKey:@"tallyproremark"] rangeOfString:self.textKeyword.text].location != NSNotFound ) {
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSString *day = [NSDate timeStringFromTimestamp:[[dic valueForKey:@"tallyprotime"] integerValue] formatter:@"yyyy-MM-dd"];
            [tempDic addEntriesFromDictionary:@{@"tallyproday":day}];
            
            [resultArray addObject:tempDic];
        }
        
    }
    
    if ([resultArray count] > 0) {
        NSArray *indexArray = [resultArray valueForKey:@"tallyproday"];
        NSSet *indexSet = [NSSet setWithArray:indexArray];//去重
        
        NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]];
        NSArray *sortSetArray = [indexSet sortedArrayUsingDescriptors:sortDesc];//排序
        
        [self.dayArr addObjectsFromArray:sortSetArray];
        
        [[[NSSet setWithArray:sortSetArray] allObjects]
         enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.dayArr count])]
         options:NSEnumerationConcurrent
         usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                  
              //获取array
              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tallyproday == %@", [self.dayArr objectAtIndex:idx]];
              NSArray *indexArray = [resultArray filteredArrayUsingPredicate:predicate];
              //倒序 排列
              NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"tallyproid" ascending:NO]];
              NSArray *sortArray = [indexArray sortedArrayUsingDescriptors:sortDesc];
             
              [self.listData addObject:sortArray];
                                              }];
    }else{
        
        [NSObject showHudTipStr:@"没有搜索到内容！"];
    }
    
}


@end

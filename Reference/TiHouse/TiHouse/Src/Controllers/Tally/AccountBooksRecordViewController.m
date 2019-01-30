//
//  AccountBooksRecordViewController.m
//  TiHouse
//
//  Created by gaodong on 2018/2/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AccountBooksRecordViewController.h"
#import <MJRefresh.h>
#import "Tally_NetAPIManager.h"

@interface AccountBooksRecordViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *listView;

@property (strong, nonatomic) NSMutableArray *regionListData;//账本明细 原始数据
@property (strong, nonatomic) NSMutableArray *listData;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger pageLimit;

@property (strong, nonatomic) NSMutableArray *dayArr;//分组日期


@end

@implementation AccountBooksRecordViewController

#pragma mark - init
+ (instancetype)initWithStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountBooks" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"AccountBooksRecordXib"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"装修账本修改记录";
    
    self.regionListData = [[NSMutableArray alloc] initWithCapacity:0];
    self.listData = [[NSMutableArray alloc] initWithCapacity:0];
    self.dayArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.pageNum = 1;
    self.pageLimit = 10;
    
    
    WEAKSELF
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;//第一页开始
        [weakSelf updateList];
    }];
    _listView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([weakSelf.listData count] <= 0) {
            [weakSelf.listView.mj_footer endRefreshing];
        }
        weakSelf.pageNum += 1;//下一页
        [weakSelf updateList];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_listView.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectZero];
    [headView setBackgroundColor:XWColorFromHex(0xF8F8F8)];
    
    NSDate *d = [NSDate dateWithString:[self.dayArr objectAtIndex:section] format:@"yyyy-MM-dd"];
    
    UILabel *dayView = [[UILabel alloc]init];
    dayView.font = [UIFont fontWithName:@"Heiti SC" size:12];
    dayView.textColor = kRKBNAVBLACK;
    dayView.text = [NSString stringWithFormat:@"%lu月%lu日", d.month, d.day];
    dayView.numberOfLines = 1;
    [headView addSubview:dayView];
    [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(20);
        make.centerY.equalTo(headView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    [headView setFrame:CGRectMake(0, 0, kScreen_Width, 24)];
    
    return headView;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *dic = [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    UIImageView *img = [cell viewWithTag:1];
    UILabel *t1 = [cell viewWithTag:2];
    UILabel *t2 = [cell viewWithTag:3];
    UILabel *t3 = [cell viewWithTag:4];
    UILabel *t4 = [cell viewWithTag:5];
    
    //1添加2修改3删除
    
    NSString *icon = @"";
    NSString *sub = @"";
    switch ([dic[@"tallyopetype"] intValue]) {
        case 1:
            icon = @"account_record_add";
            sub = @"添加了：";
            break;
        case 2:
            icon = @"account_record_edit";
            sub = @"修改了：";
            break;
        case 3:
            icon = @"account_record_del";
            sub = @"删除了：";
            break;
            
        default:
            break;
    }
    
    [img setImage:[UIImage imageNamed:icon]];
    
    if ([dic[@"catetwoname"] isEqualToString:@"无"]) {
        t1.text = [NSString stringWithFormat:@"%@%@",sub, dic[@"cateonename"]];
    }else{
        t1.text = [NSString stringWithFormat:@"%@%@·%@",sub, dic[@"cateonename"], dic[@"catetwoname"]];
    }
    NSString *content = [dic[@"tallyprocatename"] componentsSeparatedByString:@"-"][0];
    t2.text = content;
    t3.text = [NSString stringWithFormat:@"备注：%@", dic[@"tallyproremark"]];
    
    NSInteger price = [[dic objectForKey:@"amountzj"] integerValue]/100;
    t4.text = [NSString stringWithFormat:@"￥%lu",price];;
    t4.textColor = [[dic valueForKey:@"tallyprotype"] intValue] == 1? XWColorFromHex(0xfec00c):XWColorFromHex(0x11c354);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    return 78;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dayArr count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.listData objectAtIndex:section] count];
}


#pragma mark - data
//获取数据部分
- (void)updateList{
    
    WEAKSELF
    [[Tally_NetAPIManager sharedManager] request_TallyRecordsWithStartNum:weakSelf.pageNum
            Limit:weakSelf.pageLimit Tallyid:self.Tallyid
            Block:^(id data, NSError *error) {
               if ([data count] > 0) {

                   [weakSelf.dayArr removeAllObjects];
                   [weakSelf.listData removeAllObjects];
                   if (weakSelf.pageNum == 1)  [weakSelf.regionListData removeAllObjects];
                   
                   [weakSelf.regionListData addObjectsFromArray:data];
                   
                   [weakSelf sortListData:weakSelf.regionListData];
                   [weakSelf.listView reloadData];
                   
               }else{
                   
                   if (weakSelf.pageNum > 1) weakSelf.pageNum -= 1;
               }
               if (weakSelf.listView.mj_header.isRefreshing) [weakSelf.listView.mj_header endRefreshing];
               if (weakSelf.listView.mj_footer.isRefreshing) [weakSelf.listView.mj_footer endRefreshing];

           }];
}


//排序
- (void)sortListData:(NSArray *)data{
    
    NSMutableArray *resultArray = [NSMutableArray array];

    for (NSDictionary *dic in data) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSInteger t = (NSInteger)([[dic valueForKey:@"tallyopetime"] integerValue] / 1000);
        NSString *day = [NSDate timeStringFromTimestamp:t formatter:@"yyyy-MM-dd"];
        [tempDic addEntriesFromDictionary:@{@"tallyopeday":day}];//添加一个转换日期格式字段，用于排序识别
        
        [resultArray addObject:tempDic];
        
    }

    NSArray *indexArray = [resultArray valueForKey:@"tallyopeday"];
    NSSet *indexSet = [NSSet setWithArray:indexArray];//去重
    
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]];
    NSArray *sortSetArray = [indexSet sortedArrayUsingDescriptors:sortDesc];//排序
    
    [self.dayArr addObjectsFromArray:sortSetArray];
    NSLog(@"dayArr: %@", self.dayArr);
    
    [[[NSSet setWithArray:sortSetArray] allObjects] enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.dayArr count])]
                    options:NSEnumerationConcurrent
                    usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                              
                      //获取array
                      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tallyopeday == %@", [self.dayArr objectAtIndex:idx]];
                      NSArray *tempArr = [resultArray filteredArrayUsingPredicate:predicate];
                      //倒序 排列
                      NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"tallyopetime" ascending:NO]];
                      NSArray *sortArray = [tempArr sortedArrayUsingDescriptors:sortDesc];
                      
                        NSLog(@"day:%@, count: %lu, idx:%lu", obj, [tempArr count], idx);
                        
                      [self.listData addObject:sortArray];
                  }];
    
}


@end

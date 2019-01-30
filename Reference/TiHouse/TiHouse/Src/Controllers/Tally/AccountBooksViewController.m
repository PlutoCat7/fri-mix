//
//  AccountBooksViewController.m
//  TiHouse
//
//  Created by gaodong on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AccountBooksViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "AccountBooksAddViewController.h"
#import "AccountBooksTimeLineViewController.h"
#import <MJRefresh.h>
#import "Login.h"
#import "Tally_NetAPIManager.h"
#import "Tally.h"
#import "PieView.h"
#import "AddTallyLocationViewController.h"

#define kTallyID @"traceTallyID"
static NSString *noAuthorizationString = @"您没有权限查看此房屋";

@interface AccountBooksViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UICollectionView *listView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger pageLimit;

@property (weak, nonatomic) IBOutlet UIButton *btnNODataAdd;


@end

@implementation AccountBooksViewController

#pragma mark - init
+ (instancetype)initWithStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountBooks" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"AccountBooksViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账本列表";
    
    self.listData = [[NSMutableArray alloc] initWithCapacity:0];
    self.pageNum = 1;
    self.pageLimit = 10;
    
    [self initCollectionView];
    
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
    
    NSNumber *tallyid = [[NSUserDefaults standardUserDefaults] objectForKey:kTallyID];
    if (([tallyid longValue] > 0) && !_stopRedirect) {
        AccountBooksTimeLineViewController *vc = [AccountBooksTimeLineViewController initWithStoryboard];
        vc.Tallyid = [tallyid longValue];
        vc.house = _house;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.listData removeAllObjects];
    self.pageNum = 1;
    [_listView.mj_header beginRefreshing];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection
- (void)initCollectionView{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    CGFloat kMagin = 15.f;//cell 间距
    CGFloat itemWidth = (kScreen_Width - 3 * kMagin)/2;
    
    //设置单元格大小
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth / 0.8);
    flowLayout.sectionInset = UIEdgeInsetsMake(kMagin, kMagin, kMagin, kMagin);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [_listView setCollectionViewLayout:flowLayout];
    
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == [collectionView numberOfItemsInSection:indexPath.section]-1) {
        
        
        UIButton *btn = [cell viewWithTag:100];
        [btn setHidden:NO];
        [btn setImage:[UIImage imageNamed:@"account_addbook"] forState:UIControlStateNormal];
        [btn setTitle:@"添加账本" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setUserInteractionEnabled:NO];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.mas_equalTo(0);
            make.width.and.height.mas_equalTo(cell.contentView);
        }];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:30];
        
        UIImageView *bg = [cell viewWithTag:10];
        [bg setHidden:YES];
        UILabel *title = [cell viewWithTag:11];
        [title setHidden:YES];
        UIImageView *icon = [cell viewWithTag:12];
        [icon setHidden:YES];
        
    }else{
        UIButton *btn = [cell viewWithTag:100];
        [btn setHidden:YES];
        UIImageView *bg = [cell viewWithTag:10];
        [bg setHidden:NO];
        UILabel *title = [cell viewWithTag:11];
        [title setHidden:NO];
        UIImageView *icon = [cell viewWithTag:12];
        [icon setHidden:YES];
        
        Tally *info = [self.listData objectAtIndex:indexPath.row];
        title.text = info.tallyname;
        
        
        
        if (info.tallyislatestedit == 1) {
            UIImageView *icon = [cell viewWithTag:12];
            [icon setHidden:NO];
        }
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.listData count]==0 ? 0:[self.listData count]+1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    if (indexPath.row == [collectionView numberOfItemsInSection:indexPath.section]-1) {
        if (_house.uidcreater != [Login curLoginUser].uid) {
            [NSObject showHudTipStr:@"亲友不能创建账本"];
            return;
        }
        AccountBooksAddViewController *vc = [AccountBooksAddViewController initWithStoryboard];
        vc.Houseid = self.Houseid;
        vc.house = self.house;
        vc.completionBlock = ^(long tallyid) {
//            NSLog(@"%@", data);
//            AccountBooksTimeLineViewController *v = [AccountBooksTimeLineViewController initWithStoryboard];
//            v.Tallyid = tallyid;
//            v.house = _house;
//            [weakSelf.navigationController pushViewController:v animated:NO];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        //设置自动进入账本记录
        Tally *info = [self.listData objectAtIndex:indexPath.row];
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[NSNumber numberWithLong:info.tallyid] forKey:kTallyID];
        [userDefault synchronize];
        
        AccountBooksTimeLineViewController *vc = [AccountBooksTimeLineViewController initWithStoryboard];
        vc.Tallyid = info.tallyid;
        vc.house = _house;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - action

- (IBAction)clickNoDataAdd:(UIButton *)sender {
    if (_house.uidcreater != [[Login curLoginUser] uid]) {
        [NSObject showHudTipStr:@"亲友不能创建账本"];
        return;
    }

    WEAKSELF
    AccountBooksAddViewController *vc = [AccountBooksAddViewController initWithStoryboard];
    vc.Houseid = self.Houseid;
    vc.completionBlock = ^(long tallyid) {
        AccountBooksTimeLineViewController *v = [AccountBooksTimeLineViewController initWithStoryboard];
        v.Tallyid = tallyid;
        v.house = _house;
        [weakSelf.navigationController pushViewController:v animated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - data
//获取数据部分
- (void)updateList{
    
    WEAKSELF
    [[Tally_NetAPIManager sharedManager] request_TallyHousesListWithStartNum:weakSelf.pageNum
                                                                       Limit:weakSelf.pageLimit
                                                                     Houseid:self.Houseid
                                                                       Block:^(id data, NSError *error) {
                                                                           
       if ([data isKindOfClass:[NSString class]] && [data isEqualToString:noAuthorizationString]) {
           [weakSelf.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
           return;
       }

        if ([data count] > 0) {
            if (weakSelf.pageNum == 1) {
                [weakSelf.listData removeAllObjects];
                [weakSelf.listData addObjectsFromArray:data];
            }else{
                [weakSelf.listData addObjectsFromArray:data];
            }
            
            
        }else{
            
            if (weakSelf.pageNum > 1) weakSelf.pageNum -= 1;
        }
        [weakSelf.listView reloadData];
                                                                           
        if (weakSelf.listView.mj_header.isRefreshing) [weakSelf.listView.mj_header endRefreshing];
        if (weakSelf.listView.mj_footer.isRefreshing) [weakSelf.listView.mj_footer endRefreshing];
                                                                           
        [self.btnNODataAdd setHidden: [weakSelf.listData count]>0? YES:NO];
    }];
}


@end

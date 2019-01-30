//
//  MenuViewController.m
//  MagicBean
//
//  Created by yahua on 16/3/4.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "GBWebBrowserViewController.h"

#import "LeftMenuTableViewCell.h"

#import "HomeRequest.h"

@interface LeftMenuViewController () <
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ArticleInfo *articleInfo;

@end

@implementation LeftMenuViewController

- (void)dealloc
{

}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //加载缓存
    self.articleInfo = [ArticleInfo loadCache];
    
    [HomeRequest getArticleDataWithHandler:^(id result, NSError *error) {
        if (!error) {
            self.articleInfo = result;
            [self.tableView reloadData];
        }
    }];
    
    // Do any additional setup after loading the view.
    [self setupTableView];
}

#pragma mark - Private

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeftMenuTableViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Delegate

#pragma mark UITableViewDelegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.articleInfo.articles.count;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleItemInfo *info = self.articleInfo.articles[indexPath.row];
        LeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftMenuTableViewCell"];
        cell.titleLabel.text = info.title;

        return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60*kAppScale;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] postNotificationName: YHDeckLeftSideCloseNotification object:nil];
    
    ArticleItemInfo *info = self.articleInfo.articles[indexPath.row];
    GBWebBrowserViewController *vc = [[GBWebBrowserViewController alloc] initWithTitle:info.title url:info.url];
    vc.hidesBottomBarWhenPushed = YES;
    [self.nav pushViewController:vc animated:YES];
}


@end

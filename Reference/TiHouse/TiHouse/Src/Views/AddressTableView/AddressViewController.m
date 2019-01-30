//
//  AddressViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/17.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "AddressViewController.h"
#import "GroupItemTableViewController.h"
#import "TitleBarView.h"
#import "AddresManager.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) TitleBarView *TitleBar;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self wr_setNavBarBarTintColor:kTiMainBgColor];
    [self wr_setNavBarTitleColor:kRKBNAVBLACK];
    [self wr_setNavBarTintColor:kRKBNAVBLACK];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _addres = [[AddresManager alloc]init];
    _addres.GoToAddres = GoToPathTypeProvince;
//    if (_addres) {
//        [self.tableView reloadData];
//        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_addres.address.count-1 inSection:0] atScrollPosition:(UITableViewScrollPositionNone) animated:YES];
//    }else{
//
//    }
    [self.view addSubview:self.contentView];
    
    //按钮菊花
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    _activityIndicator.color = [UIColor blackColor];
    _activityIndicator.backgroundColor = [UIColor clearColor];
    _activityIndicator.hidden = YES;
    [_contentView addSubview:_activityIndicator];
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
        make.centerX.equalTo(_contentView.mas_centerX);
        make.centerY.equalTo(_contentView.mas_centerY);
    }];
    
    [self showContent];
    
    [self getProvince];
    
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _addres.address.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    GroupItemTableViewController *controller = [GroupItemTableViewController new];
    [self addChildViewController:controller];
    controller.Addres = _addres;
    controller.item = indexPath.row;
    WEAKSELF
    controller.SelectedItem = ^(NSInteger item) {
        weakSelf.addres.GoToAddres = item+2;
        weakSelf.addres.address = [NSMutableArray arrayWithArray:[weakSelf.addres.address subarrayWithRange:NSMakeRange(0, item+1)]];
        [weakSelf.tableView reloadData];
        [weakSelf getProvince];
        [weakSelf.TitleBar addMuneBtn:item];
    };
    controller.tableView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:controller.tableView];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kScreen_Width;
}

-(void)showContent{
    [UIView animateWithDuration:0.4 animations:^{
        _contentView.bottom = kScreen_Height;
    }];
}

-(void)hiddenContent{
    [UIView animateWithDuration:0.4 animations:^{
        _contentView.top = kScreen_Height;
    } completion:^(BOOL finished) {
        [_contentView removeFromSuperview];
        _contentView = nil;
        [self.view removeFromSuperview];
        self.view = nil;
    }];
}


#pragma mark - private methods 私有方法

-(void)getProvince{

    _tableView.userInteractionEnabled = NO;
    if (self.addres.GoToAddres == GoToPathTypeRests && self.finishAddres) {
        self.TitleBar.selectBtn.hidden = YES;
        self.finishAddres(self.addres);
        [self hiddenContent];
        return;
    }
//    [_tableView beginLoading];
    [_activityIndicator startAnimating];
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_AddresWith:_addres Block:^(id data, NSError *error) {
//        [weakSelf.tableView endLoading];
        [weakSelf.activityIndicator stopAnimating];
        weakSelf.tableView.userInteractionEnabled = YES;
        if (!data) {
            _finishAddres(_addres);
            [weakSelf hiddenContent];
            return ;
        }
//        weakSelf.addres.address = weakSelf.GroupDatas;
        [weakSelf.addres.address addObject:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.addres.address.count-1 inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    }];
    
}



#pragma mark - getters and setters
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 415);
        
        //标题Bar
        [_contentView addSubview:self.TitleBar];
        _TitleBar.frame = CGRectMake(0, 0, _contentView.width, 90);

        //列表
        [_contentView addSubview:self.tableView];
        _tableView.frame = CGRectMake(0, 90, _contentView.width, 415 - 90);

        
    }
    return _contentView;
}

-(TitleBarView *)TitleBar{
    if (!_TitleBar) {
        _TitleBar = [[TitleBarView alloc]init];
        _TitleBar.Addres = _addres;
        __weak typeof(self) weakself = self;
        _TitleBar.CloseBlock = ^{
            [weakself hiddenContent];
        };
        _TitleBar.SelectBtnBlock = ^(NSInteger tag) {
            NSInteger row = tag == 99 ? _addres.address.count-1 : tag-1;
            [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:(UITableViewScrollPositionNone) animated:YES];
        };
    }
    return _TitleBar;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = kScreen_Width;
        _tableView.scrollEnabled = NO;
        _tableView.scrollsToTop = NO;
        _tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.pagingEnabled = YES;
//        _tableView.backgroundColor = [UIColor purpleColor];
        _tableView.bounces = NO;
        
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

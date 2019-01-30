//
//  RelationViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PerfectRelationViewController.h"
#import "RelationView.h"
#import "BaseNavigationController.h"
#import "AddHouseTableViewCell.h"
#import "RelationViewController.h"
#import "House.h"
#import "Houseperson.h"
#import "Login.h"

@interface PerfectRelationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *UIModels;
@property (nonatomic, assign) NSInteger relation;

@end

@implementation PerfectRelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self wr_setNavBarBarTintColor:XWColorFromHex(0xfcfcfc)];
    self.title = @"完善您与房屋的关系";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    if (_house) {
        self.UIModels = [UIHelp getRelationUIWithHousename:_house.housename];
    }else{
        self.UIModels = [UIHelp getRelationUIWithHousename:_houseperson.housename];
    }
    
    [self tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [(BaseNavigationController *)self.navigationController  showNavBottomLine];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_UIModels count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIModel *uimodel = _UIModels[indexPath.row];
    cell.TextField.placeholder = uimodel.TextFieldPlaceholder;
    cell.Title.text = uimodel.Title;
    if (indexPath.row ==  0) {
        cell.topLineStyle = CellLineStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.TextField.userInteractionEnabled = NO;
    }
    if (indexPath.row ==  1) {
         User *user = [Login curLoginUser];
        cell.bottomLineStyle = CellLineStyleFill;
        cell.TextField.text = user.username;
        [cell.TextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kRKBHEIGHT(50);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        RelationViewController *relation = [[RelationViewController alloc]init];
        relation.selectedBtn = _relation;
        relation.house = _house;
        WEAKSELF
        relation.finishBolck = ^(NSString *ValueStr, NSInteger item) {
            AddHouseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.TextField.text = ValueStr;
            weakSelf.relation = item;
        };
        [self.navigationController pushViewController:relation animated:YES];
    }
}

#pragma mark - event response
//点击完成
-(void)finish{
    AddHouseTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *nickname = [cell.TextField.text stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)];
//    NSString *nickname = [cell.TextField.text aliasedString];
    NSString *houseid = _house ? [NSString stringWithFormat:@"%ld",_house.houseid] : [NSString stringWithFormat:@"%ld",_houseperson.houseid];
    NSString *typerelation = [NSString stringWithFormat:@"%ld",_relation];
    
    if (!_relation) {
        [NSObject showHudTipStr:@"请完善您与房屋的关系"];
        return;
    }
    
    [NSObject showHUDQueryStr:@"加载数据"];
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager]request_WithPath:@"api/inter/houseperson/edit" Params:@{@"houseid":houseid,@"nickname":nickname,@"typerelation":typerelation} Block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            weakSelf.house.typerelation = (NSInteger)weakSelf.relation;
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AttentionHouse" object:nil userInfo:@{@"houseid":@(_houseperson.houseid ? _houseperson.houseid : _house.houseid),
                                                                                                               @"typerelation": @(weakSelf.relation)
                                                                                                               }];
        }
    }];
}


#pragma mark - getters and setters
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[AddHouseTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.estimatedRowHeight = 50;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.automaticallyAdjustsScrollViewInsets = YES;
            _tableView.estimatedRowHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
        }];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    NSInteger kMaxLength = 10;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

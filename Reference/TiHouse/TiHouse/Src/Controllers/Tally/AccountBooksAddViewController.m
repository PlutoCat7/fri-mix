//
//  AccountBooksAddViewController.m
//  TiHouse
//
//  Created by gaodong on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AccountBooksAddViewController.h"
#import "AccountBooksTimeLineViewController.h"
#import "Tally_NetAPIManager.h"
#import <IQKeyboardManager.h>

@interface AccountBooksAddViewController ()<UITextFieldDelegate ,UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) NSMutableArray *listTemplet;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UITextField *tallyTextField;

@end

@implementation AccountBooksAddViewController

#pragma mark - init
+ (instancetype)initWithStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountBooks" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"AccountBooksAddViewController"];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加账本";
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    self.selectedIndex = 0;
    self.listTemplet = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.saveBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.saveBtn.layer.shadowOffset = CGSizeMake(0,-1.5);
    self.saveBtn.layer.shadowOpacity = 0.3;
    
    [self getTempletData];
    
    [self.tallyTextField becomeFirstResponder];
    self.tallyTextField.delegate = self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textfeild delegate
//完成
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - tableview
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UIButton *btn = (UIButton *)[cell.contentView viewWithTag:10];
    if (self.selectedIndex == 0 && indexPath.section == 0 && indexPath.row == 0) {
        [btn setSelected:YES];
    }else if(indexPath.section == 1 && self.selectedIndex - 1 == indexPath.row ){
        [btn setSelected:YES];
    }else{
        [btn setSelected:NO];
    }
    
    UILabel *title = [cell.contentView viewWithTag:11];
    if (indexPath.section == 0) {
        title.text = @"使用默认记账模板";
    }else{
        title.text = [[self.listTemplet objectAtIndex:indexPath.row] objectForKey:@"budgetname"];
    }
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreen_Width, 15.0)];
        customView.backgroundColor = kRKBViewControllerBgColor;
        return customView;
    }else{
        // create the parent view that will hold header Label
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreen_Width, 40.0)];
        customView.backgroundColor = kRKBViewControllerBgColor;
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = [UIColor darkGrayColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:12];
        headerLabel.frame = CGRectMake(10.0, 15.0, 300.0, 20.0);
        headerLabel.text = @"使用预算模板中的项目";
        [customView addSubview:headerLabel];
        return customView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.selectedIndex = 0;
    }else{
        
        self.selectedIndex = indexPath.row +1;
    }
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 15;
    }else{
        return 44;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.listTemplet count]>0?2:1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return [self.listTemplet count];
    }
}

#pragma mark - action
//保存
- (IBAction)clickSaveAction:(UIButton *)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *tallyName = [self.tallyTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([tallyName length] == 0 || [tallyName length] > 6) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = [NSString stringWithFormat:[tallyName length]==0 ? @"请输入账本名称":@"账本名称不得超过6个字"];
        [hud hideAnimated:YES afterDelay:2];
        return;
    }
    
    int templetID = 0;
    if (_selectedIndex > 0) {
        templetID = [[[self.listTemplet objectAtIndex:_selectedIndex-1] objectForKey:@"budgetid"] intValue];
    }
    
    WEAKSELF
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"保存数据...";
    [[Tally_NetAPIManager sharedManager] request_TallyAddWithName:tallyName Houseid:self.Houseid Budgetid:templetID Block:^(id data, NSError *error) {
        if (data) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"保存成功"];
            [hud hideAnimated:YES afterDelay:1];
            
//            [hud setCompletionBlock:^{
//
//                [weakSelf.navigationController popViewControllerAnimated:NO];
//                weakSelf.completionBlock([[data objectForKey:@"tallyid"] longValue]);
//            }];
            AccountBooksTimeLineViewController *v = [AccountBooksTimeLineViewController initWithStoryboard];
            v.Tallyid = [[data objectForKey:@"tallyid"] longValue];
            v.house = _house;
            [weakSelf.navigationController pushViewController:v animated:YES];
        }else{
            
            [hud hideAnimated:YES];
        }
    }];
    
}

#pragma mark - data
//获取模板数据
- (void)getTempletData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"获取模板数据...";
    
    WEAKSELF
    [[Tally_NetAPIManager sharedManager]  request_TallyTempletWithHouseID:self.Houseid Block:^(id data, NSError *error) {
        if (data) {
            [hud hideAnimated:YES];
            [weakSelf.listTemplet addObjectsFromArray:data];
            [weakSelf.listView reloadData];
        }else{
            
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"未获取到模板数据。"];
            [hud hideAnimated:YES afterDelay:2];
        }
    }];
}


@end

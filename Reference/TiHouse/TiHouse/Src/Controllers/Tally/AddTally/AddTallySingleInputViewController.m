//
//  AddTallySingleInputViewController.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddTallySingleInputViewController.h"
#import "BrandModel.h"

@interface AddTallySingleInputViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) UITextField *inputTextFeild;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *brandList;
@end

@implementation AddTallySingleInputViewController


#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = (self.inputType == Input_Model ? @"输入型号":@"输入品牌");
    self.view.backgroundColor = XWColorFromHex(0xf8f8f8);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
    [self setup];
    
    self.inputTextFeild.text = self.text;
    [self.inputTextFeild addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.inputTextFeild becomeFirstResponder];
}

- (void)setup {
    UIView *container = [UIView new];
    container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(self.view);
        make.height.equalTo(@55);
        make.top.equalTo(self.view).offset(kNavigationBarHeight);
    }];
    
    // add textFeild
    UITextField *textField = [UITextField new];
    textField.returnKeyType = UIReturnKeyDone;
    textField.backgroundColor = [UIColor whiteColor];
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    [container addSubview:textField];
    self.inputTextFeild = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container).offset(15);
        make.trailing.equalTo(container).offset(-15);
        make.top.and.bottom.equalTo(container);
    }];
    
    
    if (self.inputType == Input_Brand) {
        textField.delegate = self;
        
        // add tableView
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textField.mas_bottom);
            make.leading.trailing.bottom.equalTo(self.view);
        }];
        self.tableView.hidden = YES;
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(textField.mas_bottom);
    }];
}


- (void)saveAction {
    
    if (self.saveCompletionBlock) {
        self.saveCompletionBlock(self.inputTextFeild.text);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBrand {
    self.tableView.hidden = NO;
    [[TiHouse_NetAPIManager sharedManager] requestBrand:self.inputTextFeild.text Block:^(id data, NSError *error) {
        [self.brandList removeAllObjects];
        [self.brandList addObjectsFromArray:data];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITextFieldDelegate
/*
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
 //    if ([string isEqualToString:@"\n"]) {
 //        [textField resignFirstResponder];
 //        self.tableView.hidden = YES;
 //        return NO;
 //    }
 
 [self searchBrand];
 return YES;
 }
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self searchBrand];
    return YES;
}

- (void)textDidChange:(UITextField *)textField {
    
    [self searchBrand];
}

#pragma mark - uitableviewDelegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 40)];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor orangeColor];
        title.tag = 1;
        [cell.contentView addSubview: title];
    }
    
    UILabel *title = [cell.contentView viewWithTag:1];
    
    BrandModel *model = self.brandList[indexPath.row];
    title.text = model.shortname;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.brandList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BrandModel *model = self.brandList[indexPath.row];
    self.inputTextFeild.text = model.shortname;
    self.tableView.hidden = YES;
    
}


#pragma mark - getter
- (NSMutableArray *)brandList {
    if (_brandList == nil) {
        _brandList = [NSMutableArray array];
    }
    return _brandList;
}

@end

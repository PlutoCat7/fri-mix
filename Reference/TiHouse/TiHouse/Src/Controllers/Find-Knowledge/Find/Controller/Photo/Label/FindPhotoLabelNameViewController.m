//
//  FindPhotoLabelDesc2ViewController.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoLabelNameViewController.h"

#import "FIndPhotoLabelContactCell.h"

#import "ModelLabelRequest.h"

#define kLimitNameStringLength 15
#define kLimitBrandStringLength 10

@interface FindPhotoLabelNameViewController () <
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightLayoutConstraint;

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *oldText;
@property (nonatomic, copy) void(^doneBlock)(NSString *inputName);
@property (nonatomic, assign) BOOL isBrand;

@property (nonatomic, strong) NSArray<FindPhotoThingInfo *> *allThingList;
@property (nonatomic, strong) NSArray<FindPhotoThingInfo *> *showThingList;

@end

@implementation FindPhotoLabelNameViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder text:(NSString *)text isBrand:(BOOL)isBrand doneBlock:(void(^)(NSString *inputName))doneBlock {
    
    self = [super init];
    if (self) {
        _oldText = text;
        _placeholder = placeholder;
        _doneBlock = doneBlock;
        _isBrand = isBrand;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    self.tableViewHeightLayoutConstraint.constant = kFIndPhotoLabelContactCellHeight *4;
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    NSInteger limitLength = self.isBrand?kLimitBrandStringLength: kLimitNameStringLength;
    NSInteger kMaxLength = limitLength;
    
    UITextField *textField = self.textField;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            
            if (toBeString.length > kMaxLength) {
                
                textField.text = [toBeString substringToIndex:kMaxLength];
                
            }
            [self updateLimitUI];
            if (self.isBrand) {
                [self loadData];
            } else {
                [self filterThing];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
        
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > kMaxLength) {
            
            textField.text = [toBeString substringToIndex:kMaxLength];
            
        }
        [self updateLimitUI];
        if (self.isBrand) {
            [self loadData];
        } else {
            [self filterThing];
        }
    }
    
}

#pragma mark - Action

- (void)doneAction {
    
    if (_doneBlock) {
        _doneBlock(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionClose:(id)sender {
    
    self.textField.text = @"";
    [self updateLimitUI];
}

#pragma mark - Private

- (void)loadData {
    
    if (self.isBrand) {
        NSString *key = self.textField.text;
        if (key == nil || key.length == 0) {
            self.allThingList = nil;
            [self filterThing];
            return;
        }
        WEAKSELF
        [ModelLabelRequest getModelBrandListWithHandler:key handler:^(id result, NSError *error) {
            if (!error) {
                weakSelf.allThingList = result;
                [self filterThing];
            }
        }];
    } else {
        WEAKSELF
        [ModelLabelRequest getModelThingListWithHandler:^(id result, NSError *error) {
            
            if (!error) {
                weakSelf.allThingList = result;
                [self filterThing];
            }
        }];
    }
    
}

- (void)setupUI {
    
    [self wr_setNavBarBarTintColor:XWColorFromHex(0xfcfcfc)];
    self.title = @"添加物品";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.textField.placeholder = _placeholder;
    self.textField.text = _oldText;
    [self.textField becomeFirstResponder];
    [self updateLimitUI];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.contactTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FIndPhotoLabelContactCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FIndPhotoLabelContactCell class])];
    self.contactTableView.rowHeight = kFIndPhotoLabelContactCellHeight;
}

- (void)updateLimitUI {
    
    self.limitLabel.text = [NSString stringWithFormat:@"%td/%d", _textField.text.length, self.isBrand?kLimitBrandStringLength:kLimitNameStringLength];
}

- (void)filterThing {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (FindPhotoThingInfo *info in _allThingList) {
        NSString *thingName = self.isBrand?info.allname:info.thingname;
        if ([thingName containsString:self.textField.text]) {
            [result addObject:info];
        }
    }
    self.showThingList = [result copy];
    [self.contactTableView reloadData];
}

#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    
    if ([text isEqualToString:@""]) { //删除操作
        return YES;
    }
    return YES;
}

#pragma mark - UITableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _showThingList.count;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FIndPhotoLabelContactCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FIndPhotoLabelContactCell class])];
    [cell refreshWithName:self.isBrand?_showThingList[indexPath.row].allname:_showThingList[indexPath.row].thingname];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.textField.text = self.isBrand?_showThingList[indexPath.row].allname:_showThingList[indexPath.row].thingname;
    [self updateLimitUI];
    [self filterThing];
}

@end

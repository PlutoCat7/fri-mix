//
//  FindDraftViewController.m
//  TiHouse
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindDraftViewController.h"
#import "FindArticleEditViewController.h"

#import "FindDraftTipsView.h"
#import "FindDraftCell.h"

#import "FindDraftStore.h"
#import "YAHKVOController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface FindDraftViewController () <
UITableViewDelegate,
UITableViewDataSource,
FindDraftTipsViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayoutConstraint;
@property (strong, nonatomic) NSIndexPath* editingIndexPath;  //当前左滑cell的index，在代理方法中设置

@property (nonatomic, strong) FindDraftStore *store;

@end


@implementation FindDraftViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _store = [[FindDraftStore alloc] init];
        WEAKSELF
        [self.yah_KVOController observe:self.store keyPath:@"cellModels" block:^(id observer, id object, NSDictionary *change) {
            
            [weakSelf.tableView reloadData];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.editingIndexPath)
    {
        [self configSwipeButtons];
    }
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"草稿箱";
    
    [self setupTipsView];
    [self setupTableView];
}

- (void)setupTipsView {
    
    BOOL isShow = YES;
    if (isShow) {
        FindDraftTipsView *tipsView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FindDraftTipsView class]) owner:self options:nil].firstObject;
        tipsView.delegate = self;
        tipsView.frame = CGRectMake(0, 0, kScreen_Width, kFindDraftTipsViewHeight);
        tipsView.autoresizingMask = UIViewAutoresizingNone;
        [self.containerView addSubview:tipsView];
        
        self.tableViewTopLayoutConstraint.constant = tipsView.height;
    }
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindDraftCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FindDraftCell class])];
    self.tableView.rowHeight = kFindDraftCellHeight;
}

- (void)configSwipeButtons
{
    // 获取选项按钮的reference
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0"))
    {
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.tableView.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subview.subviews count] >= 2)
            {
                // 和iOS 10的按钮顺序相反
                UIButton *deleteButton = subview.subviews[1];
                UIButton *readButton = subview.subviews[0];
                
                [self configDeleteButton:deleteButton];
                [self configReadButton:readButton];
            }
        }
    }
    else
    {
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in tableCell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subview.subviews count] >= 2)
            {
                UIButton *deleteButton = subview.subviews[0];
                UIButton *readButton = subview.subviews[1];
                
                [self configDeleteButton:deleteButton];
                [self configReadButton:readButton];
            }
        }
    }
}

- (void)configDeleteButton:(UIButton*)deleteButton
{
    if (deleteButton)
    {
        [deleteButton setImage:[UIImage imageNamed:@"find_dratf_delete"] forState:UIControlStateNormal];
    }
}

- (void)configReadButton:(UIButton*)readButton
{
    if (readButton)
    {
        [readButton setImage:[UIImage imageNamed:@"find_draft_edit"] forState:UIControlStateNormal];
        [readButton setContentMode:UIViewContentModeCenter];
    }
}

#pragma mark - FindDraftTipsViewDelegate

- (void)FindDraftTipsView_ClickClose:(FindDraftTipsView *)tipsView {
    
    [tipsView removeFromSuperview];
    self.tableViewTopLayoutConstraint.constant = 0;
}

#pragma mark - UITableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _store.cellModels.count;
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
    FindDraftCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindDraftCell class])];
    [cell refreshWithModel:_store.cellModels[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindDraftSaveModel *model = [self.store findDraftSaveModelWithIndexPath:indexPath];
    FindArticleEditViewController *vc = [[FindArticleEditViewController alloc] initWithSaveDraftInfo:model];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    WEAKSELF
    // 创建action
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                        {
                                            [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
                                            FindDraftSaveModel *model = [weakSelf.store findDraftSaveModelWithIndexPath:indexPath];
                                            FindArticleEditViewController *vc = [[FindArticleEditViewController alloc] initWithSaveDraftInfo:model];
                                            [weakSelf.navigationController pushViewController:vc animated:YES];
                                        }];
    editAction.backgroundColor = [UIColor colorWithRGBHex:0xF1F1F1];
    // delete action
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                          {
                                              [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
                                              [weakSelf.store deleteCellWithIndexPath:indexPath];
                                              
                                          }];
    deleteAction.backgroundColor = [UIColor colorWithRGBHex:0xF1F1F1];
    
    return @[deleteAction, editAction];
}
 

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos){
    WEAKSELF
    UIContextualAction *editAction = [UIContextualAction
                                        contextualActionWithStyle:UIContextualActionStyleDestructive
                                        title:@""
                                        handler:^(UIContextualAction * _Nonnull action,
                                                  __kindof UIView * _Nonnull sourceView,
                                                  void (^ _Nonnull completionHandler)(BOOL))
                                        {
                                            
                                            [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
                                            FindDraftSaveModel *model = [weakSelf.store findDraftSaveModelWithIndexPath:indexPath];
                                            FindArticleEditViewController *vc = [[FindArticleEditViewController alloc] initWithSaveDraftInfo:model];
                                            [weakSelf.navigationController pushViewController:vc animated:YES];
                                            
                                        }];
    editAction.backgroundColor = [UIColor colorWithRGBHex:0xF1F1F1];
    [editAction setImage:[UIImage imageNamed:@"find_draft_edit"]];
    // delete action
    UIContextualAction *deleteAction = [UIContextualAction
                                        contextualActionWithStyle:UIContextualActionStyleDestructive
                                        title:@""
                                        handler:^(UIContextualAction * _Nonnull action,
                                                  __kindof UIView * _Nonnull sourceView,
                                                  void (^ _Nonnull completionHandler)(BOOL))
                                        {
                                            
                                            [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
                                            [weakSelf.store deleteCellWithIndexPath:indexPath];
                                            
                                        }];
    deleteAction.backgroundColor = [UIColor colorWithRGBHex:0xF1F1F1];
    [deleteAction setImage:[UIImage imageNamed:@"find_dratf_delete"]];
    
    
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction, editAction]];
    actions.performsFirstActionWithFullSwipe = NO;
    
    return actions;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self setEditing:false animated:true];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = nil;
}

@end

//
//  YHImagePickerViewController.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "YAHImagePickerViewController.h"
#import "YAHImagePickerCollectionViewController.h"
#import "YAHImagePickerGroupCell.h"
#import "YAHPreSelectAssetViewController.h"

#import "YAHImagePeckerAssetsData.h"
#import "NSObject+FBKVOController.h"
#import "YAHImagePickerDefines.h"

@interface YAHImagePickerViewController () <
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YAHPreSelectAssetViewController *preSelectCollectionViewController;

@property (nonatomic, copy) NSArray<YAHAlbumModel *> *groups;

@end

@implementation YAHImagePickerViewController

#pragma mark - View Lifecycle

- (void)dealloc
{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBarView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.contentInset = UIEdgeInsetsMake(16, 0, 0, 0);
    self.tableView.rowHeight = YHImagePickerGroupCellHeight;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    
    [self addChildViewController:self.preSelectCollectionViewController];
    [self.view addSubview:self.preSelectCollectionViewController.view];
    
    [self loadGroupAssets];
    [self addSelectAssetsArrayObserver];
}

#pragma mark - Custom Accessors

- (YAHPreSelectAssetViewController *)preSelectCollectionViewController {
    
    if (!_preSelectCollectionViewController) {
        
        _preSelectCollectionViewController = [[YAHPreSelectAssetViewController alloc] init];
        CGRect rc = self.view.frame;
        _preSelectCollectionViewController.view.frame = CGRectMake(0, CGRectGetHeight(rc) -PreSelectionsToolbarHeight, CGRectGetWidth(rc), PreSelectionsToolbarHeight);
        __weak __typeof(self)weakSelf = self;
        _preSelectCollectionViewController.doneBlock = ^() {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf done:nil];
        };
        rc = self.tableView.frame;
        rc.size.height -= PreSelectionsToolbarHeight;
        self.tableView.frame = rc;
    }
    return _preSelectCollectionViewController;
}

#pragma mark - Delegate

// determine the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.groups.count;
}

// determine the appearance of table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    YAHImagePickerGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[YAHImagePickerGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    YAHAlbumModel *groupForCell = self.groups[indexPath.row];
    [cell setAssetsGroup:groupForCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YAHAlbumModel *groupForCell = self.groups[indexPath.row];
    [self pushAlbumDetailVC:groupForCell animated:YES];
}

#pragma mark - Action

- (void)cancel:(id)sender {
    
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)done:(id)sender {
    
    if (self.sucessBlock) {
        __weak __typeof(self)weakSelf = self;
        [[YAHImagePeckerAssetsData shareInstance] getSelectAssetsSuccessBlock:^(NSArray *assets) {
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.sucessBlock(assets);
        } failureBlock:^(NSError *error) {
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.failureBlock) {
                strongSelf.failureBlock(error);
            }
        }];
    }
}

#pragma mark - Private

- (void)showBarView {
    
    self.title = LS(@"game.complete.album");
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    doneButton.enabled = [[YAHImagePeckerAssetsData shareInstance] isSelectOneMore];
    [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
}

- (void)loadGroupAssets {
    
    __weak __typeof(self)weakSelf = self;
    [[YAHImagePeckerAssetsData shareInstance] loadGroupAssetsSuccessBlock:^(NSArray *groupAssets) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.groups = groupAssets;
        [strongSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        //默认显示所有照片
        [strongSelf pushAlbumDetailVC:groupAssets.firstObject animated:NO];
        
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.failureBlock) {
            strongSelf.failureBlock(error);
        }
    }];
}

- (void)addSelectAssetsArrayObserver {
    
    __weak __typeof(self)weakSelf = self;
    [self.KVOController observe:[YAHImagePeckerAssetsData shareInstance] keyPath:@"selectAssetsArray" options:NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.navigationItem.rightBarButtonItem.enabled = [[YAHImagePeckerAssetsData shareInstance] isSelectOneMore];
    }];
}

- (void)pushAlbumDetailVC:(YAHAlbumModel *)model animated:(BOOL)animated {
    
    if (!model) {
        return;
    }
    YAHImagePickerCollectionViewController *vc = [[YAHImagePickerCollectionViewController alloc] initWith:model];
    __weak __typeof(self)weakSelf = self;
    vc.sucessBlock = ^(){
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf done:nil];
    };
    [self.navigationController pushViewController:vc animated:animated];
}

@end

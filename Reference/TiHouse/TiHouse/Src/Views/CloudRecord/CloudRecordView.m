//
//  CloudRecordView.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CloudRecordView.h"
#import "CloudRecordListCell.h"
#import "CloudRecordHeadView.h"
#import "House.h"
#import "Login.h"
#import "CloudReListCountModel.h"
#import "CloudReFileListModel.h"
#import "MonthDairyModel.h"
#import "AllSearchViewController.h"

@interface CloudRecordView ()<CloudRecordListCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//view
@property (strong, nonatomic) CloudRecordHeadView * headView;

//model
@property (retain, nonatomic) House * house;

//data
@property (strong, nonatomic) NSArray * fileDataArray;
@property (strong, nonatomic) NSMutableArray * monthDataArray;
@property (strong, nonatomic) NSMutableArray * monthShowDataArray;
@property (strong, nonatomic) NSMutableArray * sectionArray;
@property (strong, nonatomic) NSArray * headDataArray;
@property (assign, nonatomic) int index;//刷新索引
@property (assign, nonatomic) BOOL isEdit;//是否进行编辑状态

@end

@implementation CloudRecordView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel withHouse:(House *)house {
    CloudRecordView * cloudRecordView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    cloudRecordView.house = house;
    
    [cloudRecordView xl_setupViews];
//    [cloudRecordView xl_bindViewModel];
    
    return cloudRecordView;
}

-(void)xl_setupViews {
    [self.headView setFrame:CGRectMake(0, 0, kScreen_Width, 190)];
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //init
    self.index = 0;
    
    //add table refresh
    // 暂时注释上拉加载
//    [self addFooterRefresh];
}

-(void)xl_bindViewModel {
    
    [self beginLoading];
    
    //获取文件统计列表
    WEAKSELF;
    User *user = [Login curLoginUser];
    [[TiHouse_NetAPIManager sharedManager] request_cloudRecordListCountWithParams:@{@"houseid":@(self.house.houseid),@"uid":@(user.uid)} Block:^(id data, NSError *error) {

        [weakSelf requestAllFileList];
        
        if (data) {
            weakSelf.headDataArray = data;
            [weakSelf.headView setCloudRecordHeadViewInfo:data];
        } else {
            [weakSelf endLoading];
        }
    }];
}

-(void)refreshData {
    self.index = 0;
    [self xl_bindViewModel];
}

-(void)addFooterRefresh {
    
    WS(weakSelf);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        
        if (!weakSelf.isEdit) {
            weakSelf.index += 10;
            [weakSelf requestListCountByMonth];
        }
        
    }];
}

/**
 * 获取文件统计列表(按月)
 */
-(void)requestListCountByMonth {
 
    WEAKSELF;
    User *user = [Login curLoginUser];
    [[TiHouse_NetAPIManager sharedManager] request_cloudRecordListCountByMonthWithParams:@{@"houseid":@(self.house.houseid),@"uid":@(user.uid),@"start":@(self.index),@"limit":@(10)} Block:^(id data, NSError *error) {
        
        NSArray * array = data;
        if (array || array.count > 0) {
            if (weakSelf.index == 0) {
                [weakSelf.monthDataArray removeAllObjects];
            }
            
            
//            for (CloudReListCountModel * model in array) {
            for (MonthDairyModel *model in array) {
                NSArray * yyyymm = model.dairymonth.length > 0 ? [model.dairymonth componentsSeparatedByString:@"-"] : nil;
                model.year = yyyymm.count > 0 ? yyyymm[0] : @"";//model.month.length > 0 ? [model.month substringWithRange:NSMakeRange(0, 4)] : @"";
                model.MM = yyyymm.count > 1 ? yyyymm[1] : @"";
//                if (model.countphoto > 0 || model.countvideo) {
                    [weakSelf.monthDataArray addObject:model];
//                }
            }
            
            [weakSelf.monthShowDataArray removeAllObjects];
            [weakSelf.sectionArray removeAllObjects];
            
//            for (CloudReListCountModel * model in weakSelf.monthDataArray) {
            for (MonthDairyModel * model in weakSelf.monthDataArray) {

                if (weakSelf.sectionArray.count <= 0) {
                    [weakSelf.sectionArray addObject:model.year];
                } else {
                    if (![weakSelf.sectionArray containsObject:model.year]) {
                        [weakSelf.sectionArray addObject:model.year];
                    }
                }
            }
            
            for (NSString * year in weakSelf.sectionArray) {
                
                NSMutableArray * rowArray = [[NSMutableArray alloc] init];
//                for (CloudReListCountModel * model in weakSelf.monthDataArray) {
                for (MonthDairyModel * model in weakSelf.monthDataArray) {
                    if ([year isEqualToString:model.year]) {
                        [rowArray addObject:model];
                    }
                }
                
                [weakSelf.monthShowDataArray addObject:rowArray];
            }
            
            [weakSelf.tableView reloadData];
        }
        
        //停止加载提示
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf endLoading];
    }];
}

/**
 * 获取文件夹列表(所有，根据房屋id)
 */
-(void)requestAllFileList {
    WEAKSELF;
    User *user = [Login curLoginUser];
    [[TiHouse_NetAPIManager sharedManager] request_cloudRecordListByHouseidWithParams:@{@"houseid":@(self.house.houseid),@"uid":@(user.uid)} Block:^(id data, NSError *error) {
        
        [weakSelf requestListCountByMonth];
        
        if (data) {
            
            NSMutableArray * tempArray = [[NSMutableArray alloc] init];
            for (CloudReFileListModel * model in data) {
                model.folderImgName = @"c_file";
                [tempArray addObject:model];
            }
            
            if (weakSelf.house.isedit)
            {
                //添加自己添加文件夹
                CloudReFileListModel * model = [[CloudReFileListModel alloc] init];
                model.foldername = @"添加文件夹";
                model.folderImgName = @"c_add_file";
                model.folderid = 0;
                model.uid = (int)user.uid;
                model.foldertype = 3;//添加文件
                model.houseid = weakSelf.house.houseid;
                [tempArray addObject:model];
            }

            weakSelf.fileDataArray = tempArray;
            
            [weakSelf.tableView reloadData];
            
        } else {
            [weakSelf endLoading];
        }
    }];
}

/**
 * 添加文件夹接口请求
 */
-(void)addFileRequest:(NSString *)fileName {
    
    [self beginLoading];

    WEAKSELF;
    User *user = [Login curLoginUser];
    [[TiHouse_NetAPIManager sharedManager]
     request_cloudRecordAddFolderWithParams:@{@"uid":@(user.uid),@"foldername":fileName,@"houseid":@(self.house.houseid)} Block:^(id data, NSError *error) {
        if (data) {
            [weakSelf endLoading];
            [NSObject showHudTipStr:data];
            
            //刷新数据
            [weakSelf requestAllFileList];
        }
    }];
}

/**
 * 删除文件夹
 */
-(void)delFileRequest:(long)folderid {
    
    [self beginLoading];
    
    WEAKSELF;
    User *user = [Login curLoginUser];
    [[TiHouse_NetAPIManager sharedManager]
     request_cloudRecordDelFolderWithParams:@{@"uid":@(user.uid),@"folderid":@(folderid),@"houseid":@(self.house.houseid)} Block:^(id data, NSError *error) {
         if (data) {
             [weakSelf endLoading];
             [NSObject showHudTipStr:data];
             
             //加载提示
             
             //刷新数据
             [weakSelf requestAllFileList];
         }
     }];
}

#pragma mark - public method
/**
 * 点击编辑事件
 */
-(void)clickEditAction {
    self.isEdit = YES;
    
    [self.changeEditBtnSubject sendNext:@"编辑"];
    
    self.headView.userInteractionEnabled = NO;
    [self.tableView.mj_footer setHidden:YES];
    [self.tableView reloadData];
}

/**
 * 点击完成事件
 */
-(void)clickDoneAction {
    self.isEdit = NO;
    
    [self.changeEditBtnSubject sendNext:@"完成"];
    
    self.headView.userInteractionEnabled = YES;
    [self.tableView.mj_footer setHidden:NO];
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section == 0 && indexPath.row == self.fileDataArray.count - 1) || (indexPath.section == 1 && indexPath.row == self.monthDataArray.count - 1)) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.fileDataArray.count;
    } else {
        if (self.isEdit) {
            return 0;
        }
        NSArray * array = self.monthShowDataArray[section - 1];
        return array.count;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ((section == 0 && self.fileDataArray.count <= 0)) {
        return nil;
    }
    
    if ((section == 1 && self.monthDataArray.count <= 0) || (section == 1 && self.isEdit)) {
        return nil;
    }
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = XWColorFromHex(0xF8F8F8);
    view.frame = CGRectMake(0, 0, kScreen_Width, 42);
    
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = XWColorFromHex(0x999999);
    [view addSubview:label];
    if (section == 0) {
        label.text = @"文件夹";
    } else {
        if (self.isEdit) {
            label.text = @"";
        } else {
            label.text = [NSString stringWithFormat:@"%@年",self.sectionArray[section - 1]];
        }
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.top.mas_equalTo(12);
        make.height.mas_equalTo(15);
    }];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((section == 0 && self.fileDataArray.count <= 0)) {
        return 0;
    }
    
    if ((section == 1 && self.monthDataArray.count <= 0) || (section == 1 && self.isEdit)) {
        return 0;
    }
    
    return 42;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"CloudRecordListCell";
    CloudRecordListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CloudRecordListCell" owner:nil options:nil] firstObject];
    }
    
    if (indexPath.section == 0) {
        
        [cell.imgView setContentMode:UIViewContentModeCenter];
        CloudReFileListModel * model = self.fileDataArray[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:model.folderImgName];
        cell.titleLabel.text = model.foldername;
        
        cell.titleLabelConstraintY.constant = 0;
        [cell.contentLabel setHidden:YES];
        
        if (self.isEdit) {
            cell.delegate = self;
            cell.delBtn.tag = indexPath.row;
            
            if (model.foldertype == 1 || indexPath.row == self.fileDataArray.count - 1) {
                [cell.delBtn setHidden:YES];
            } else {
               [cell.delBtn setHidden:NO];
            }
            
        } else {
            [cell.delBtn setHidden:YES];
        }
    } else {
        [cell.imgView setContentMode:UIViewContentModeScaleAspectFill];
        NSArray * sectionArray = self.monthShowDataArray[indexPath.section - 1];
//        CloudReListCountModel * model = sectionArray[indexPath.row];
        MonthDairyModel *model = sectionArray[indexPath.row];
//        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.urllastfile] placeholderImage:nil];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[model.dairymonthfileJA[0] fileurlsmall]] placeholderImage:nil];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@月",model.MM];
//        cell.contentLabel.text = [NSString stringWithFormat:@"共%d张照片，%d个视频",model.countphoto,model.countvideo];
        cell.contentLabel.text = [NSString stringWithFormat:@"共%ld记录",model.dairymonthnum];
        cell.titleLabelConstraintY.constant = -10;
        [cell.contentLabel setHidden:NO];
        [cell.delBtn setHidden:YES];
    }
    [self updateConstraints];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    //可编辑状态，禁止点击
    if (self.isEdit) {
        return;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == self.fileDataArray.count - 1 && self.house.isedit) {
            [self AddFileAlertView];
        } else {
            [self.cellClickSubject sendNext:self.fileDataArray[indexPath.row]];
        }
    } else {
        NSArray * sectionArray = self.monthShowDataArray[indexPath.section - 1];
//        CloudReListCountModel * model = sectionArray[indexPath.row];
        MonthDairyModel *model = sectionArray[indexPath.row];
        model.isMonthFile = YES;
//        [self.cellClickSubject sendNext:model];
        [self.headerClickSubject sendNext:model];
    }
}

#pragma mark - UIAlertController

/**
 * 添加新文件事件
 */
-(void)AddFileAlertView {
    // 1.创建UIAlertController
    WEAKSELF;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加文件夹"
                                                                             message:@"请输入文件夹名称"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // 2.1 添加文本框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入文件夹名称";
    }];
    
    // 2.2  创建Cancel Login按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *fileName = alertController.textFields.firstObject;
        
        //添加加载提示
        
        //执行请求
        [weakSelf addFileRequest:fileName.text];
    }];
   
    // 2.3 添加按钮
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    // 3.显示警报控制器
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - CloudRecordListCellDelegate
-(void)CloudRecordListCellDelegateDelAction:(NSInteger)index {
    
    CloudReFileListModel * model = self.fileDataArray[index];

    WEAKSELF;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要永远删除该文件夹吗？\n删除后，文件夹的文件将移到“默认”文件夹" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf delFileRequest:model.folderid];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - get fun
-(CloudRecordHeadView *)headView {
    if (!_headView) {
        _headView = [CloudRecordHeadView shareInstanceWithViewModel:nil];
        
        WEAKSELF;
        _headView.CloudReHeadImgClickBlock = ^(int index) {
            
            MonthDairyModel * tempModel = nil;
            for (MonthDairyModel * model in weakSelf.headDataArray) {
                if ([model.dairymonthfileJA[0] filetype] == index) {
                    tempModel = model;
                    break;
                }
            }
            [weakSelf.cellClickSubject sendNext:tempModel];
        };
        _headView.CloudReSearchBarClickBlock = ^{
            [weakSelf.searchBarClickSubject sendNext:nil];
        };
        
        _headView.clickBlock = ^{
            [weakSelf.searchBarClickSubject sendNext:nil];
        };
    }
    return _headView;
}

-(RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

- (RACSubject *)headerClickSubject {
    if (!_headerClickSubject) {
        _headerClickSubject = [RACSubject subject];
    }
    return _headerClickSubject;
}

-(RACSubject *)changeEditBtnSubject {
    if (!_changeEditBtnSubject) {
        _changeEditBtnSubject = [RACSubject subject];
    }
    return _changeEditBtnSubject;
}

-(RACSubject *)searchBarClickSubject {
    if (!_searchBarClickSubject) {
        _searchBarClickSubject = [RACSubject subject];
    }
    return _searchBarClickSubject;
}

-(NSMutableArray *)monthDataArray {
    if (!_monthDataArray) {
        _monthDataArray = [[NSMutableArray alloc] init];
    }
    return _monthDataArray;
}

-(NSMutableArray *)monthShowDataArray {
    if (!_monthShowDataArray) {
        _monthShowDataArray = [[NSMutableArray alloc] init];
    }
    return _monthShowDataArray;
}

-(NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [[NSMutableArray alloc] init];
    }
    return _sectionArray;
}

@end

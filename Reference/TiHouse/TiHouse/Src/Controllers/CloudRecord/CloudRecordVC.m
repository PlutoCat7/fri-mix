//
//  CloudRecordVC.m
//  TiHouse
//  云记录界面
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CloudRecordVC.h"
#import "CloudRecordView.h"
#import "House.h"
#import "CloudRecordCollectVC.h"
#import "CloudRecordSearchVC.h"
#import "CloudReFileListModel.h"
#import "CloudReListCountModel.h"
#import "CloudRecordCollectView.h"
#import "MonthDairyModel.h"
#import "THHouseMonthViewController.h"

@interface CloudRecordVC ()

@property (strong, nonatomic) CloudRecordView * cloudRecordView;

@end

@implementation CloudRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"云记录";
    
    [self addSubviews];
    [self bindViewModel];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.cloudRecordView refreshData];
}

-(void)addSubviews {
    
    if (self.house.isedit)//如果是有读写权限
    {
        //添加右上角编辑按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editEvent)];
    }
    
    //添加view
    [self.view addSubview:self.cloudRecordView];
    
    if (@available(iOS 11.0, *)) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}

- (void)updateViewConstraints{
    
    [self.cloudRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreen_Width);
    }];
    [super updateViewConstraints];
}

#pragma mark - model action
-(void)bindViewModel {
    
    WEAKSELF;
    [self.cloudRecordView.cellClickSubject subscribeNext:^(id x) {
//        if ([x isKindOfClass:[MonthDairyModel class]]) {

//        } else {
        
                    CloudRecordCollectVC * cloudRecord = [[CloudRecordCollectVC alloc] init];
                    cloudRecord.titleName = [weakSelf getNextVcTitle:x];
                    cloudRecord.houseID = weakSelf.house.houseid;
                    cloudRecord.type = [weakSelf getType:x];
            
                    if ([x isKindOfClass:[CloudReFileListModel class]]) {
                        CloudReFileListModel * model = x;
                        cloudRecord.folderID = model.folderid;
            //        } else if ([x isKindOfClass:[CloudReListCountModel class]]) {
                    } else if ([x isKindOfClass:[MonthDairyModel class]]) {
                        MonthDairyModel * model = x;
                        cloudRecord.monthStr = model.dairymonth;
                    }
            
                    [cloudRecord setHidesBottomBarWhenPushed:YES];
                    [weakSelf.navigationController pushViewController:cloudRecord animated:YES];

//        }
    }];
    [self.cloudRecordView.headerClickSubject subscribeNext:^(id x) {
        
            THHouseMonthViewController *monthVC = [[THHouseMonthViewController alloc] init];
            monthVC.hidesBottomBarWhenPushed = YES;
            MonthDairyModel *model = x;
            monthVC.title = [NSString stringWithFormat:@"%@月",model.dairymonth];
            monthVC.model = model;
            monthVC.house = weakSelf.house;
            [self.navigationController pushViewController:monthVC animated:YES];
    }];
    
    [self.cloudRecordView.changeEditBtnSubject subscribeNext:^(id x) {
        if ([x isEqualToString:@"编辑"]) {
            weakSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:weakSelf action:@selector(doneEvent)];
        } else {
            weakSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:weakSelf action:@selector(editEvent)];
        }
    }];
    [self.cloudRecordView.searchBarClickSubject subscribeNext:^(id x) {
        CloudRecordSearchVC * searchVC = [[CloudRecordSearchVC alloc] init];
        searchVC.house = _house;
//        [searchVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:searchVC animated:YES];
    }];
}

/**
 * 获取下一页标题
 */
-(CloudRecordType )getType:(id )object {
    if ([object isKindOfClass:[CloudReFileListModel class]]) {
        return CloudRecordFolder;
//    } else if ([object isKindOfClass:[CloudReListCountModel class]]) {
    } else if ([object isKindOfClass:[MonthDairyModel class]]) {
        MonthDairyModel * model = object;
        if (model.isMonthFile) {
            return CloudRecordMonth;
        } else {
            if ([model.dairymonthfileJA[0] filetype] == 4) {
                //最近上传
                return CloudRecordRecent;
            } else if ([model.dairymonthfileJA[0] filetype]== 1) {
                //图片
                return CloudRecordPhoto;
            } else if ([model.dairymonthfileJA[0] filetype] == 2) {
                //视频
                return CloudRecordVideo;
            } else {
                //收藏
                return CloudRecordCollect;
            }
        }
    } else {
        return CloudRecordRecent;
    }
}

/**
 * 获取下一页标题
 */
-(NSString *)getNextVcTitle:(id )object {
    if ([object isKindOfClass:[CloudReFileListModel class]]) {
        CloudReFileListModel * model = object;
        return model.foldername;
//    } else if ([object isKindOfClass:[CloudReListCountModel class]]) {
    } else if ([object isKindOfClass:[MonthDairyModel class]]) {
        MonthDairyModel * model = object;
        if (model.isMonthFile) {
            return model.dairymonth;
        } else {
            if ([model.dairymonthfileJA[0] filetype]  == 4) {
                //最近上传
                return @"最近上传";
            } else if ([model.dairymonthfileJA[0] filetype]  == 1) {
                //图片
                return @"图片";
            } else if ([model.dairymonthfileJA[0] filetype] == 2) {
                //视频
                return @"视频";
            } else {
                //收藏
                return @"收藏";
            }
        }
    } else {
        return @"文件";
    }
}

/**
 * 编辑事件
 */
-(void)editEvent {
    [self.cloudRecordView clickEditAction];
}

/**
 * 完成事件
 */
-(void)doneEvent {
    [self.cloudRecordView clickDoneAction];
}

#pragma mark - get fun
-(CloudRecordView *)cloudRecordView {
    if (!_cloudRecordView) {
        _cloudRecordView = [CloudRecordView shareInstanceWithViewModel:nil withHouse:self.house];
        _cloudRecordView.viewController = self;
    }
    return _cloudRecordView;
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

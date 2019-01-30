//
//  GBPerRegionViewController.m
//  GB_TransferMarket
//
//  Created by gxd on 17/1/4.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "GBPerRegionViewController.h"
#import "GBPerSubRegionViewController.h"

#import "GBPerIndicatorCell.h"

#import "UserRequest.h"

@interface GBPerRegionViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *areaArray;
// 区域
@property (nonatomic, assign) NSInteger initProviceId;
@property (nonatomic, assign) NSInteger initCityId;
@property (nonatomic, assign) NSInteger curProviceId;
@property (nonatomic, assign) NSInteger curCityId;

@end

@implementation GBPerRegionViewController

- (instancetype)initWithRegion:(NSInteger)provinceId cityId:(NSInteger)cityId {
    if (self = [super init]) {
        _initProviceId = provinceId;
        _curProviceId = provinceId;
        
        _initCityId = cityId;
        _curCityId = cityId;
    }
    return self;
}

- (void)loadData {
    _areaArray = [RawCacheManager sharedRawCacheManager].areaList;
}

-(void)setupUI {
    
    self.title = LS(@"personal.hint.region");
    [self setupBackButtonWithBlock:nil];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBPerIndicatorCell" bundle:nil] forCellReuseIdentifier:@"GBPerIndicatorCell"];
    
    [self checkSaveEnable];
}

- (void)checkSaveEnable {
    
}

#pragma mark - Action


#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.areaArray count];
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBPerIndicatorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBPerIndicatorCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AreaInfo *areaInfo = self.areaArray[indexPath.row];
    cell.nameLbl.text = areaInfo.areaName;
    cell.lineView.hidden = (indexPath.row + 1 == [self.areaArray count]);
    
    return cell;
    
}

// 选择row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AreaInfo *areaInfo = self.areaArray[indexPath.row];
    self.curProviceId = areaInfo.areaID;
    
    GBPerSubRegionViewController *vc = [[GBPerSubRegionViewController alloc] initWithRegion:areaInfo cityId:self.curCityId];
    @weakify(self)
    vc.saveBlock = ^(NSInteger cityId){
        
        @strongify(self)
        self.curCityId = cityId;
        if (self.curProviceId == self.initProviceId &&
            self.curCityId == self.initCityId) {
            return YES;
        }else {
            UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
            userInfo.provinceId = self.curProviceId;
            userInfo.cityId = self.curCityId;
            
            [UserRequest updateUserInfo:userInfo handler:^(id result, NSError *error) {
                if (!error) {
                    BLOCK_EXEC(self.saveBlock, self.curProviceId, self.curCityId)
                    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                    if ([viewControllers.lastObject isKindOfClass:[GBPerSubRegionViewController class]]) {
                        [viewControllers removeLastObject];
                    }
                    if ([viewControllers.lastObject isKindOfClass:[self class]]) {
                        [viewControllers removeLastObject];
                    }
                    [self.navigationController setViewControllers:viewControllers animated:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_BaseInfo object:nil];
                    
                }else {
                    [[UIApplication sharedApplication].keyWindow showToastWithText:error.domain];
                }
            }];
        }
        return YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46.f;
}


@end

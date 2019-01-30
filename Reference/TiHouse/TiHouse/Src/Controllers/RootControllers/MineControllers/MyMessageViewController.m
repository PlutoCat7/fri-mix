//
//  MyMessageViewController.m
//  TiHouse
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageTableViewCell.h"
#import "CustomerServiceChatViewController.h"
#import "ActivityViewController.h"
#import "Login.h"
#import "BaseNavigationController.h"
#import <IQKeyboardManager.h>
#import "NSDate+Common.h"

@interface MyMessageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) BOOL loaded;
@property (nonatomic, retain) NSMutableArray *dairies;
@property (nonatomic, copy) NSDictionary *assemarccontent;
@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    if (!_dairies) {
        _dairies = [NSMutableArray new];
    }
    [self tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    [self getDairies];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getLatestConcern];
    [self getLogDairyOpeList];
    [_tableView reloadData];
//    for (UIView *view in self.navigationController.navigationBar.subviews) {
//        NSLog(@"层级view %@", view);
//        if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
//            CGRect frame = view.frame;
//            frame.origin.y = -20;
//            view.frame = frame;
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_assemarccontent count] != 0) {
        return [_dairies count] + 2;
    } else {
        return [_dairies count] + 1;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    User *user = [Login curLoginUser];
    NSString *uidString =  [NSString stringWithFormat:@",%ld,", user.uid];
    
    if (([_assemarccontent count] != 0) && (indexPath.row == [_dairies count])) {
        cell.avatarImgView.image = [UIImage imageNamed:@"discover"];
        cell.titleLabel.text = @"发现的动态";
        int strlen = [_assemarccontent[@"username"] length];
        switch ([_assemarccontent[@"logassemarcopetype"] intValue]) {
            case 1:
                cell.detailsLabel.text = [NSString stringWithFormat:@"%@ 赞了我的发现", _assemarccontent[@"username"]];
                break;
            case 2:
                cell.detailsLabel.text = [NSString stringWithFormat:@"%@ 评论了我的发现", _assemarccontent[@"username"]];
                break;
            case 3:
                cell.detailsLabel.text = [NSString stringWithFormat:@"%@ 收藏了我的发现", _assemarccontent[@"username"]];
                break;
            case 4:
                cell.detailsLabel.text = [NSString stringWithFormat:@"%@ 关注了我", _assemarccontent[@"username"]];
                break;
            case 5:
                cell.detailsLabel.text = [NSString stringWithFormat:@"我关注的%@ 有了新发现", _assemarccontent[@"username"]];
                break;
            default:
                break;
        }
        cell.timeLabel.text = [self compareCurrentTime:[_assemarccontent[@"logassemarcopectime"] longValue]];
        if ([_assemarccontent[@"usernumunreadassem"] integerValue] > 0) {
            [cell.contentView addBadgeTip:[NSString stringWithFormat:@"%@", _assemarccontent[@"usernumunreadassem"]] withCenterPosition:CGPointMake(kScreen_Width - 25, kRKBHEIGHT(50))];
        } else {
            [cell.contentView removeBadgeTips];
        }
    } else if ((([_assemarccontent count] != 0) && (indexPath.row == [_dairies count] +1)) || (([_assemarccontent count] == 0) && (indexPath.row == [_dairies count]))) {
        NSArray *ar = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_CUSTOMERSERVICE targetId:RY_KEFU_ID count:1];
        if ([ar count] > 0) {
            RCMessage *msg = [ar objectAtIndex:0];
            if ([msg.objectName isEqualToString:@"RC:TxtMsg"]) {
                cell.detailsLabel.text = [msg.content mj_keyValues][@"content"];
            } else if ([msg.objectName isEqualToString:@"RC:ImgMsg"]) {
                cell.detailsLabel.text = @"[图片]";
            } else if ([msg.objectName isEqualToString:@"RC:VcMsg"]) {
                cell.detailsLabel.text = @"[语音]";
            } else if ([msg.objectName isEqualToString:@"RC:InfoNtf"]) {
                cell.detailsLabel.text = @"抱歉，暂无人工客服在线!";
            }
            cell.timeLabel.text = [self compareCurrentTime:msg.receivedTime];
        } else {
            cell.detailsLabel.text = @"点击这里和有数啦客服对话";
            cell.timeLabel.text = @"";
        }
        cell.avatarImgView.image = [UIImage imageNamed:@"customerservice"];
        cell.titleLabel.text = @"有数啦客服";
    } else {
        [cell.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(kRKBHEIGHT(16));
        }];
        cell.timeLabel.text = [self compareCurrentTime:[_dairies[indexPath.row][@"logdairyopectime"] longValue]];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ 的动态", _dairies[indexPath.row][@"housename"]];
        [cell.avatarImgView sd_setImageWithURL:_dairies[indexPath.row][@"urlfront"] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        if ([_dairies[indexPath.row][@"logdairyopetype"] intValue] == 1) {
            NSString *str = [NSString stringWithFormat:@"%@ 赞了一个", _dairies[indexPath.row][@"logdairyopenickname"]];
            cell.detailsLabel.text = str;
        } else if ([_dairies[indexPath.row][@"logdairyopetype"] intValue] == 2) {
            if ([_dairies[indexPath.row][@"logdairyopeuidon"] intValue] == -1) {
                NSString *str = [NSString stringWithFormat:@"%@ 发表了评论", _dairies[indexPath.row][@"logdairyopenickname"]];
                cell.detailsLabel.text = str;
            } else {
                NSString *str = [NSString stringWithFormat:@"%@ 回复了 %@", _dairies[indexPath.row][@"logdairyopenickname"], _dairies[indexPath.row][@"logdairyopenicknameon"]];
                cell.detailsLabel.text = str;
            }
        } else if ([_dairies[indexPath.row][@"logdairyopetype"] intValue] == 3) {
            if ([_dairies[indexPath.row][@"arruidremind"] rangeOfString:uidString].location == NSNotFound) {
                NSString *str = [NSString stringWithFormat:@"%@ 发布了日记", _dairies[indexPath.row][@"logdairyopenickname"]];
                cell.detailsLabel.text = str;
            } else {
                cell.detailsLabel.text = [NSString stringWithFormat:@"【提醒我看】%@ 发布了日记", _dairies[indexPath.row][@"logdairyopenickname"]];
            }
        } else if ([_dairies[indexPath.row][@"logdairyopetype"] intValue] == 4) {
            if ([_dairies[indexPath.row][@"arruidremind"] rangeOfString:uidString].location == NSNotFound) {
                NSString *str = [NSString stringWithFormat:@"%@ 发布了照片", _dairies[indexPath.row][@"logdairyopenickname"]];
                cell.detailsLabel.text = str;
            } else {
                cell.detailsLabel.text = [NSString stringWithFormat:@"【提醒我看】%@ 发布了照片", _dairies[indexPath.row][@"logdairyopenickname"]];
            }
        } else if ([_dairies[indexPath.row][@"logdairyopetype"] intValue] == 5) {
            if ([_dairies[indexPath.row][@"arruidremind"] rangeOfString:uidString].location == NSNotFound) {
                NSString *str = [NSString stringWithFormat:@"%@ 发布了视频", _dairies[indexPath.row][@"logdairyopenickname"]];
                cell.detailsLabel.text = str;
            } else {
                cell.detailsLabel.text = [NSString stringWithFormat:@"【提醒我看】%@ 发布了视频", _dairies[indexPath.row][@"logdairyopenickname"]];
            }
        } else {
            NSString *str = [NSString stringWithFormat:@"%@ 关注了%@", _dairies[indexPath.row][@"logdairyopenickname"],  _dairies[indexPath.row][@"housename"]];
            cell.detailsLabel.text = str;
        }
        if ([_dairies[indexPath.row][@"housepersonnumunreaddt"] integerValue] > 0) {
//            [cell.contentView addBadgeTip:[NSString stringWithFormat:@"%@",_dairies[indexPath.row][@"housepersonnumunreaddt"]] withCenterPosition:CGPointMake(CGRectGetMaxX(cell.timeLabel.frame) >100 ? CGRectGetMaxX(cell.timeLabel.frame)-7 : kScreen_Width - 25, CGRectGetMaxY(cell.timeLabel.frame) > 0 ? CGRectGetMaxY(cell.timeLabel.frame)+15 : kRKBHEIGHT(40))];
            [cell.contentView addBadgeTip:[NSString stringWithFormat:@"%@",_dairies[indexPath.row][@"housepersonnumunreaddt"]] withCenterPosition:CGPointMake(kScreen_Width - 25, kRKBHEIGHT(50))];
        }else{
            [cell.contentView removeBadgeTips];
        }
        
    }
    //    cell.bottomLineStyle = CellLineStyleDefault;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kRKBHEIGHT(80);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (([_assemarccontent count] != 0) && (indexPath.row == [_dairies count])) {
        [self markReaded];
        ActivityViewController *avc = [ActivityViewController new];
        avc.housename = @"发现";
        [self.navigationController pushViewController:avc animated:YES];
    } else if ((([_assemarccontent count] != 0) && (indexPath.row == [_dairies count] +1)) || (([_assemarccontent count] == 0) && (indexPath.row == [_dairies count]))) {
        CustomerServiceChatViewController *rcclvc = [CustomerServiceChatViewController new];
        rcclvc.title = @"有数啦客服";
        rcclvc.conversationType = ConversationType_CUSTOMERSERVICE;
        rcclvc.targetId = RY_KEFU_ID;
        [self.navigationController pushViewController:rcclvc animated:YES];
    } else {
        ActivityViewController *avc = [ActivityViewController new];
        avc.houseid = [_dairies[indexPath.row][@"houseid"] intValue];
        avc.housename = _dairies[indexPath.row][@"housename"];
        [self.navigationController pushViewController:avc animated:YES];
        //更新未读书为0
        [self upUnreadDairy:_dairies[indexPath.row]];
        MyMessageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.contentView removeBadgeTips];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - getters and setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
        }];
    }
    return _tableView;
}

- (void)getLatestConcern {
    WEAKSELF
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/logassemarc/pageMyconcernByTime" withParams:@{@"start": [NSString stringWithFormat:@"%d", 0], @"limit": [NSString stringWithFormat:@"%d", 1]} withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            _assemarccontent = [data[@"data"] firstObject];
            [weakSelf.tableView reloadData];
        }
    }];
}

//- (void)getDairies {
//    User *user = [Login curLoginUser];
//    WEAKSELF
//    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/dairy/listLatestExceptMine" withParams:@{@"uid":[NSString stringWithFormat:@"%ld", user.uid]} withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
//        if ([data[@"is"] intValue]) {
//            [_dairies addObjectsFromArray:data[@"data"]];
//            [weakSelf.tableView reloadData];
//        } else {
//            NSLog(@"%@", error);
//        }
//    }];
//}

-(void)getLogDairyOpeList {
    User *user = [Login curLoginUser];
    WEAKSELF
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/logdairyope/list" withParams:@{@"uid":[NSString stringWithFormat:@"%ld", user.uid]} withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [_dairies removeAllObjects];
            [_dairies addObjectsFromArray:data[@"data"]];
            [weakSelf.tableView reloadData];
        }
    }];
}

//-(void)getPageByHouseidTime {
//    User *user = [Login curLoginUser];
//    WEAKSELF
//    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/logdairyope/pageByHouseidTime" withParams:@{@"uid":[NSString stringWithFormat:@"%ld", user.uid]} withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
//        if ([data[@"is"] intValue]) {
//            [_dairies addObjectsFromArray:data[@"data"]];
//            [weakSelf.tableView reloadData];
//        }
//    }];
//}

-(void)upUnreadDairy:(NSDictionary *)dair{
    dair = [dair mutableCopy];
    [dair setValue:0 forKey:@"housepersonnumunreaddt"];
    WEAKSELF
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/houseperson/editHousepersonnumunreaddtToZeroByHouseid" withParams:@{@"houseid": [NSString stringWithFormat:@"%@",[dair objectForKey:@"houseid"]]} withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [weakSelf getLogDairyOpeList];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

-(void)markReaded {
    WEAKSELF
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/user/editUsernumunreadassemToZero" withParams:@{} withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [weakSelf getLogDairyOpeList];
        } else {
            NSLog(@"%@", error);
        }
    }];

}

- (NSString *)timestampToString:(long)timeStamp {
    NSTimeInterval timeInterval = timeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd"];
    
    NSDateFormatter *fo = [[NSDateFormatter alloc] init];
    [fo setDateFormat:@"HH:mm"];
    NSString *hoursandSec = [fo stringFromDate:date];
    
    NSString *createDate = [format stringFromDate:date];
    
    NSDate *nowDate = [NSDate date];
    NSString *today = [format stringFromDate:nowDate];
    
    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *yesterday = [format stringFromDate:yesterdayDate];
    
    if ([createDate isEqualToString:today]) {
        return [NSString stringWithFormat:@"%@",hoursandSec];
    } else if ([createDate isEqualToString:yesterday]) {
        return [NSString stringWithFormat:@"昨天",hoursandSec];
    } else {
        return [NSString stringWithFormat:@"%@",createDate];
    }
}

- (NSString *) compareCurrentTime:(long)timeStamp
{
    NSTimeInterval timeInter = timeStamp/1000;

    //把字符串转为NSdate
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:timeInter];
    
    //得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <15){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else{
        //把字符串转为NSdate
        
        result = [NSString stringWithFormat:@"%d-%02d-%02d", (int)timeDate.year, (int)timeDate.month, (int)timeDate.day];
    }
    
    return  result;
}


@end


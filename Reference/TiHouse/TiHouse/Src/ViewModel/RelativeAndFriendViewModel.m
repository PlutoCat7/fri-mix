//
//  RelativeAndFriendViewModel.m
//  TiHouse
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RelativeAndFriendViewModel.h"

@implementation RelativeAndFriendViewModel

-(RACSubject *)cellClickSubject{
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}


-(void)loadData{
    WS(weakSelf);
    __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window beginLoading];
    
    [[TiHouse_NetAPIManager sharedManager] request_RelativeAndFriendHousepersonWithPath:URL_Get_RelFri_List Params:@{@"houseid":@(_houseId)} Block:^(id data, NSError *error) {
        [appDelegate.window endLoading];
        if (data) {
            // 筛选出男主人和女主人，放到上面的视图中
            weakSelf.masters = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"typerelation=1 || typerelation=2"]];
            
            // 其他的亲人放到表格中
            weakSelf.others = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"typerelation=0 || typerelation>2"]];
            [weakSelf.successSubject sendNext:nil];
        }else{
            [NSObject showError:error];
        }
    }];
}

@end

//
//  AssemCellModel.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemCellModel.h"

@implementation AssemCellModel

- (void)setUserList:(NSArray<FindAssemUserInfo *> *)userList {
    
    if (userList.count>4) {
        _userList = [userList subarrayWithRange:NSMakeRange(0, 4)];
    }else {
        _userList = userList;
    }
}

@end

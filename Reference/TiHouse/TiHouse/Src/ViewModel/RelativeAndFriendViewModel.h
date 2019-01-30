//
//  RelativeAndFriendViewModel.h
//  TiHouse
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"
#import "House.h"

@interface RelativeAndFriendViewModel : BaseViewModel

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic,strong) NSArray * masters;
@property (nonatomic,strong) NSArray * others;

@property (nonatomic, assign) long houseId;

@property (nonatomic, strong) House *house;

-(void)loadData;

@end

//
//  PushTeamApplyItem.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//  球队申请

#import "PushTeamItem.h"

@interface PushTeamApplyItem : PushTeamItem

@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, assign) NSInteger ope_user_id;  //申请者id

@end

//
//  PlayerRankResponeInfo.h
//  GB_Football
//
//  Created by gxd on 2017/11/29.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface PlayerRankInfo : YAHActiveObject
    
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy  ) NSString  *nickName;
@property (nonatomic, copy  ) NSString  *photoImageUrl;
@property (nonatomic, assign) CGFloat   value;
@property (nonatomic, assign) NSInteger rank;

@end

@interface PlayerRankHeadInfo : YAHActiveObject
    
@property (nonatomic, assign) CGFloat   value;
@property (nonatomic, assign) NSInteger rank;

@end

@interface PlayerRankRespone : YAHActiveObject
    
@property (nonatomic, strong) NSArray<PlayerRankInfo *> *content;
@property (nonatomic, strong) PlayerRankHeadInfo *head;

@end

@interface PlayerRankResponeInfo : GBResponseInfo

@property (nonatomic, strong) PlayerRankRespone *data;
    
@end


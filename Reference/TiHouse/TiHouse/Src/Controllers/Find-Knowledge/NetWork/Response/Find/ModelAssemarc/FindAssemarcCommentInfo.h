//
//  FindAssemarcCommentInfo.h
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "YAHActiveObject.h"

@interface FindAssemarcCommentInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger assemarccommid;
@property (nonatomic, assign) NSInteger assemarcid;
@property (nonatomic, assign) NSInteger assemarccommuid;
@property (nonatomic, assign) NSInteger assemarccommuidon;
@property (nonatomic, copy) NSString *assemarccommcontent;
@property (nonatomic, copy) NSString *assemarccommcontentsub;
@property (nonatomic, assign) long assemarccommctime;
@property (nonatomic, assign) NSInteger assemarccommnumzan;
@property (nonatomic, copy) NSString *assemarccommname;
@property (nonatomic, copy) NSString *assemarccommurlhead;
@property (nonatomic, copy) NSString *assemarccommnameon;
@property (nonatomic, copy) NSString *assemarccommurlheadon;
@property (nonatomic, assign) BOOL assemarccommiszan;

@end

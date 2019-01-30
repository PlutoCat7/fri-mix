//
//  AssemarccommModel.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssemarccommModel : NSObject

@property (nonatomic, assign) long assemarccommid, assemarcid, assemarccommuid, assemarccommuidon;
@property (nonatomic, copy) NSString *assemarccommcontent;
@property (nonatomic, assign) long assemarccommctime, assemarccommstime;
@property (nonatomic, assign) int assemarccommnumzan;
@property (nonatomic, copy) NSString *assemarccommname, *assemarccommurlhead, *assemarccommnameon, *assemarccommurlheadon;
@property (nonatomic, assign) int assemarccommiszan;
@property (nonatomic, copy) NSString *assemarccommcontentsub;

@end

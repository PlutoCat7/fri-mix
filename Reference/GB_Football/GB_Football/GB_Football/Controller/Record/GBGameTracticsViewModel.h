//
//  GBGameTracticsViewModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/16.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LineUpPlayerModel.h"
#import "LineUpModel.h"

@interface GBGameTracticsViewModel : NSObject

@property (nonatomic, strong, readonly) LineUpModel *tracticsModel;
@property (nonatomic, strong, readonly) NSArray<NSArray<LineUpPlayerModel *> *> *dataList;

- (instancetype)initWithTracticsType:(TracticsType)type players:(NSArray<TeamLineUpInfo *> *)players;

@end

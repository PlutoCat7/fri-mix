//
//  TacticsListViewModel.h
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TeamTacticsInfo;

@interface TacticsListCellModel : NSObject

@property (nonatomic, copy) NSAttributedString *playerNumberAttributedString;
@property (nonatomic, copy) NSString *tacticsName;
@property (nonatomic, copy) NSString *dateString;

@end

@interface TacticsListViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray<TacticsListCellModel *> *cellModels;

- (void)getFirstPageListWithBlock:(void(^)(NSError *error))block;
- (void)getNextPageListWithBlock:(void(^)(NSError *error))block;
- (void)deleteTacticsWithIndex:(NSInteger)index block:(void(^)(NSError *error))block;
- (TeamTacticsInfo *)tacticsInfoWithIndex:(NSInteger)index;

@end

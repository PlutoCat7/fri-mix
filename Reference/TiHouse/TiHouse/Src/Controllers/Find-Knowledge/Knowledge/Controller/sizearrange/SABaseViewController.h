//
//  SABaseViewController.h
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
#import "BasePageNetworkRequest.h"
#import "KnowModeInfo.h"

@interface SABaseViewController : FindKnowledgeBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) BasePageNetworkRequest *recordPageRequest;

@property (nonatomic, strong) NSArray<KnowModeInfo *> *recordList;
@property (assign, nonatomic) KnowType knowType;
@property (assign, nonatomic) KnowTypeSub knowTypeSub;

@property (nonatomic, assign) BOOL isFontBold;

- (instancetype)initWithKnowType:(KnowType)knowType knowTypeSub:(KnowTypeSub)knowTypeSub;
- (void)setupTableView:(UITableView *)tableView;
- (BasePageNetworkRequest *)createRecordPageRequest;

- (void)getFirstRecordList;
- (void)getNextRecordList;


@end

//
//  TweetMonthCount.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/2/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetMonthCount : NSObject

@property (nonatomic, copy) NSString *arruidrange;
@property (nonatomic, assign) long contentid;
@property (nonatomic, assign) NSInteger contentstatus;
@property (nonatomic, assign) long houseid;
@property (nonatomic, assign) long latesttime;
@property (nonatomic, assign) long logtimeaxisid;
@property (nonatomic, assign) long logtimeaxistype;
@property (nonatomic, copy) NSString *urlpic;

@end

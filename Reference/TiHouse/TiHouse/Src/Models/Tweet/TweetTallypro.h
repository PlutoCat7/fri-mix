//
//  TweetTallypro.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetTallypro : NSObject

@property (nonatomic, assign) long amountzj ,cateoneid, catetwoid, logtallyopeid, tallyid, tallyopetime;
@property (nonatomic, assign) NSInteger tallyopetype ,tallyprotype;
@property (nonatomic, copy) NSString *cateonename, *catetwoname, *tallyname, *tallyprocatename, *tallyproremark;

@end

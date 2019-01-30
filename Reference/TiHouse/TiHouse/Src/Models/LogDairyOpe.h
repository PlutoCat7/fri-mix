//
//  Logdairyope.h
//  TiHouse
//
//  Created by admin on 2018/3/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogDairyOpe : NSObject

@property (nonatomic, assign) long logdairyopeid, dairyid, houseid, logdairyopeuid, logdairyopectime;
@property (nonatomic, assign) int logdairyopetype;
@property (strong, nonatomic) NSString *logdairyopecontent, *nickname, *urlhead, *arrurlfile, *housename, *arruidrange, *arruidremind, *logdairyopenicknameon, *logdairyopeuidon, *urlfilesmall, *logdairyopenickname;

@end


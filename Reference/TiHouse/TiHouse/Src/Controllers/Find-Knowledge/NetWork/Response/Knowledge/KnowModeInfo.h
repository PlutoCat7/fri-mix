//
//  KnowModeInfo.h
//  TiHouse
//
//  Created by weilai on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "YAHDataResponseInfo.h"
#import "Enums.h"

@interface KnowModeInfo : YAHDataResponseInfo

@property (assign, nonatomic) NSInteger knowid;
@property (strong, nonatomic) NSString *knowtitle;
@property (strong, nonatomic) NSString *knowtitlesub;
@property (strong, nonatomic) NSString *knowcontent;
@property (strong, nonatomic) NSString *knowurlindex;
@property (strong, nonatomic) NSString *knowcontentdown;
@property (strong, nonatomic) NSString *knowcreatername;
@property (assign, nonatomic) long knowctime;
@property (assign, nonatomic) NSInteger knownumzan;
@property (assign, nonatomic) NSInteger knownumcomm;
@property (assign, nonatomic) NSInteger knownumcoll;
@property (assign, nonatomic) KnowType knowtype;
@property (assign, nonatomic) BOOL knowiscoll;
@property (nonatomic, copy  ) NSString *urlshare;
@property (nonatomic, copy  ) NSString *linkshare;

@property (assign, nonatomic) BOOL isExpand;

@end

@interface GroupKnowModeInfo : YAHActiveObject

@property (assign, nonatomic) NSInteger groupid;
@property (assign, nonatomic) NSInteger grouppushstatus;
@property (assign, nonatomic) NSInteger grouppushrealtime;
@property (assign, nonatomic) NSInteger grouppushappointtime;
@property (assign, nonatomic) NSInteger groupctime;
@property (assign, nonatomic) NSInteger groupstatus;
@property (strong, nonatomic) NSArray<KnowModeInfo *> *listModelKnow;

@end

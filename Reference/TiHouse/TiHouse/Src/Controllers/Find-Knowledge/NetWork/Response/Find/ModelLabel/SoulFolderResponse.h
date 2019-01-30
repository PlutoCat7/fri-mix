//
//  SoulFolderResponse.h
//  TiHouse
//
//  Created by weilai on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponseInfo.h"

@interface SoulFolderInfo : YAHActiveObject

@property (assign, nonatomic) NSInteger soulfolderid;
@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *soulfoldername;
@property (assign, nonatomic) long soulfolderctime;
@property (assign, nonatomic) NSInteger countAssemblefile;
@property (assign, nonatomic) NSInteger allcount;
@property (assign, nonatomic) NSInteger knownumcoll;

@end

@interface SoulFolderAllInfo : YAHActiveObject

@property (assign, nonatomic) NSInteger allcount;
@property (nonatomic, strong) NSArray<SoulFolderInfo *> *soulfolderList;

@end

@interface SoulFolderResponse : GBResponseInfo

@property (nonatomic, strong) SoulFolderAllInfo *data;

@end

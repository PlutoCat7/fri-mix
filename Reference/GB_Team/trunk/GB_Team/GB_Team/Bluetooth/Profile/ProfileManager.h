//
//  ProfileManager.h
//  GB_Football
//
//  Created by 王时温 on 2016/11/3.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PacketProfile.h"

@interface ProfileManager : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;

- (void)addProfile:(__kindof PacketProfile *)profile;
- (void)addProfileWithArray:(NSArray<__kindof PacketProfile *> *)list;
- (void)removeProfile:(__kindof PacketProfile *)profile;
- (void)removeAllProfile;

- (void)cleanTask;

@end

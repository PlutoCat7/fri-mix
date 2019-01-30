//
//  DailySportMutableProfile.m
//  GB_Football
//
//  Created by gxd on 17/6/13.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "DailySportMutableProfile.h"

@interface DailySportMutableProfile() <PacketProfileDelegate>
{
    
    NSMutableArray *dateArr;
    
    NSDate *date;
    NSInteger sMonth;
    NSInteger sDay;
    
    NSInteger totalCount;
    NSInteger readCount;
    
    NSMutableData *dailyData;
    NSMutableDictionary *resultData;
}
@property (nonatomic, copy) ReadServiceBlock serviceBlock;
@property (nonatomic, strong) NSTimer *readTimer;

@end

@implementation DailySportMutableProfile

-(id)init
{
    self = [super init];
    
    dateArr = [NSMutableArray new];
    resultData = [NSMutableDictionary new];
    
    return self;
}

- (void)stopTask {
    
    [super stopTask];
    [self closeReadTimer];
}

#pragma mark - Public

-(void)sendMutableDailyProfile:(NSArray *)dateArray serviceBlock:(ReadServiceBlock)serviceBlock {
    
    [self reset];
    self.serviceBlock = serviceBlock;
    [dateArr addObjectsFromArray:dateArray];
    
    [self sendDailyProfile];
}


#pragma mark - PacketProfileDelegate
-(void)gattPacketProfile:(PacketProfile*)profile packet:(GattPacket *)packet
{
    
    if (!self.isActive) {
        return;
    }
    if (packet.type == (0x36|0x80)) {
        [self resetReadTimer];
        
        totalCount = [GattPacket parseSportStepPacketCountGatt:packet.data];
        if (totalCount == 0) { //当前日期没有日常数据，读取下个日期
            [self sendDailyProfile];
        } else {//读取日常数据
            GattPacket *gattPacket = [GattPacket createSportStepPacketGatt:sMonth day:sDay index:0];
            [self sendPacket:gattPacket];
        }
        
    } else if (packet.type == (0x37|0x80)) {
        [self resetReadTimer];
        
        NSData *paserData = [GattPacket parseSportStepPacketGatt:packet.data];
        if (paserData) {
            [dailyData appendData:paserData];
            readCount++;
            if (readCount == totalCount) {
                NSDictionary *dataDict = [GattPacket transSportStepPacketGatt:dailyData];
                if (dataDict && date) {
                    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
                    [dateToStrFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *YMD = [dateToStrFormatter stringFromDate:date];
                    
                    [resultData setObject:dataDict forKey:YMD];
                }
                
                [self sendDailyProfile];
            }
        }
    }
    GBLog(@"%@ packet:%@", self.class, packet);
}

-(void)gattPacketProfile:(PacketProfile*)profile error:(NSError*)error
{
    if (!self.isActive) {
        return;
    }
    [self closeReadTimer];
    
    BLOCK_EXEC(self.serviceBlock, nil, makeError(GattErrors_PaserFail, LS(@"bluetooth.read.fail")));
    GBLog(@"%@ error:%@", self.class, error);
}

#pragma mark - private mothed

-(void)resetReadTimer
{
    GBLog(@"resetReadTimer");
    if (self.readTimer) {
        [self.readTimer invalidate];
    }
    
    self.readTimer = [NSTimer scheduledTimerWithTimeInterval:kReadTimeInterval target:self selector:@selector(timerDidFire) userInfo:nil repeats:NO];
}

-(void)closeReadTimer
{
    GBLog(@"closeReadTimer");
    if (self.readTimer) {
        [self.readTimer invalidate];
    }
}

-(void)timerDidFire
{
    BLOCK_EXEC(self.serviceBlock, nil, makeError(GattErrors_PaserFail, LS(@"bluetooth.read.fail")));
}

-(void)sendDailyProfile
{
    if ([dateArr count] == 0) {
        [self closeReadTimer];
        BLOCK_EXEC(self.serviceBlock, resultData, nil);
        return;
    }
    
    date = dateArr[0];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [cal components:unitFlags fromDate:date];
    sMonth = [dateComponent month];
    sDay = [dateComponent day];
    [dateArr removeObjectAtIndex:0];
    
    totalCount = 0;
    readCount = 0;
    dailyData = [[NSMutableData alloc] init];
    
    GattPacket *countGattPacket = [GattPacket createSportStepPacketCountGatt:sMonth day:sDay];
    [self sendPacket:countGattPacket];
    
    [self resetReadTimer];
}

- (void)reset {
    
    [dateArr removeAllObjects];
    date = nil;
    sMonth = 0;
    sDay = 0;
    totalCount = 0;
    readCount = 0;
    dailyData = [[NSMutableData alloc] init];
    [resultData removeAllObjects];
}

@end

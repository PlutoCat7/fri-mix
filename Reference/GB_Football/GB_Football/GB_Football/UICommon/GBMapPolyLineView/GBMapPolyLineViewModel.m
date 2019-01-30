//
//  GBMapPolyLineViewModel.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMapPolyLineViewModel.h"

#define kMaxSpeed 10   //最高速度
#define KMaxDistance 100   //两点的最大距离， 用于飘星后续点的处理
#define KLineLength 30   //30s一个时间段

@interface GBMapPolyLineViewModel ()

@property (nonatomic, strong) NSArray<RunInfo *> *runInfoList;

@property (nonatomic, strong) GBMKPolyline *runPolyLine;
@property (nonatomic, assign) CLLocationCoordinate2D minLocationCoordinate2D;
@property (nonatomic, assign) CLLocationCoordinate2D maxLocationCoordinate2D;

@end

@implementation GBMapPolyLineViewModel

- (instancetype)initWithRunInfoList:(NSArray<RunInfo *> *)runInfoList {
    
    self = [super init];
    if (self) {
        _runInfoList = runInfoList;
        [self caculateMinMaxLocation];
        [self drawPolyLine];
    }
    
    return self;
}

- (void)caculateMinMaxLocation{
    
    RunInfo *initialLoc = self.runInfoList.firstObject;
    
    CLLocationDegrees minLat = initialLoc.lat;
    CLLocationDegrees minLng = initialLoc.lon;
    CLLocationDegrees maxLat = minLat;
    CLLocationDegrees maxLng = minLng;
    
    for (RunInfo *location in self.runInfoList) {
        if (location.lat < minLat) {
            minLat = location.lat;
        }
        if (location.lon < minLng) {
            minLng = location.lon;
        }
        if (location.lat > maxLat) {
            maxLat = location.lat;
        }
        if (location.lon > maxLng) {
            maxLng = location.lon;
        }
    }
    self.minLocationCoordinate2D = CLLocationCoordinate2DMake(minLat, minLng);
    self.maxLocationCoordinate2D = CLLocationCoordinate2DMake(maxLat, maxLng);
}

- (void)getRunPolyLine:(void(^)(GBMKPolyline *runPolyLine))block {
    
    if (self.runPolyLine) {
        BLOCK_EXEC(block, self.runPolyLine);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self drawPolyLine];
        dispatch_async(dispatch_get_main_queue(), ^{
            BLOCK_EXEC(block, self.runPolyLine);
        });
    });
}

- (NSArray<RunInfo *> *)caculateLocation {
    
    NSInteger length = 3;
    if (self.runInfoList.count<=length) {
        return self.runInfoList;
    }
    
    NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:1];
    [tmpList addObject:self.runInfoList.firstObject];
    for (NSInteger index=length; index<self.runInfoList.count-length; index=index+length) {
        
        CLLocationDegrees totalLat = 0;
        CLLocationDegrees totalLon = 0;
        for (NSInteger i=index-2; i<=index+2; i++) {
            totalLat += self.runInfoList[i].lat;
            totalLon += self.runInfoList[i].lon;
        }
        self.runInfoList[index].lat = totalLat/5;
        self.runInfoList[index].lon = totalLon/5;
        [tmpList addObject:self.runInfoList[index]];
        //        CLLocationDegrees totalLat = 0;
        //        CLLocationDegrees totalLon = 0;
        //        for (NSInteger i=index-2; i<=index; i++) {
        //            totalLat += self.runInfoList[i].lat;
        //            totalLon += self.runInfoList[i].lon;
        //        }
        //        self.runInfoList[index-1].lat = totalLat/3;
        //        self.runInfoList[index-1].lon = totalLon/3;
        //        RunInfo *startInfo = self.runInfoList[index-length-1];
        //        RunInfo *endInfo = self.runInfoList[index-1];
        //        NSInteger startIndex = index-length-1;
        //        NSInteger endIndex = index-1;
        //        CGFloat totalSpeed = 0;
        //        for (NSInteger j=startIndex; j<=endIndex; j++) {
        //            totalSpeed += self.runInfoList[j].speed;
        //        }
        //        CGFloat currentSpeed = 0;
        //        for (NSInteger i=startIndex; i<=endIndex; i++) {
        //            currentSpeed += self.runInfoList[i].speed;;
        //            //double t = (i-startIndex)*1.0/(endIndex-startIndex);
        //            double t = currentSpeed/totalSpeed;
        //            self.runInfoList[i].lat = startInfo.lat + (endInfo.lat-startInfo.lat)*t;
        //            self.runInfoList[i].lon = startInfo.lon + (endInfo.lon-startInfo.lon)*t;
        //        }
    }
    [tmpList addObject:self.runInfoList.lastObject];
    
    return [tmpList copy];
}

- (NSArray<RunSectionInfo *> *)caculateColorSection {
    
    //先分组
    NSMutableArray<NSArray *> *tmpList = [NSMutableArray arrayWithCapacity:1];
    NSInteger total = 0;
    while (1) {
        NSInteger count = 30;
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:count];
        
        for (NSInteger i=0; i<count; i++) {
            if (total == self.runInfoList.count) {
                break;
            }
            
            [list addObject:self.runInfoList[total]];
            total++;
        }
        [tmpList addObject:[list copy]];
        if (total == self.runInfoList.count) {
            break;
        }
    }
    NSMutableArray<RunSectionInfo *> *runSectionInfoList = [NSMutableArray arrayWithCapacity:1];
    RunSectionInfo *firstRunSectionInfo = [self runSectionInfoWithRunInfo:self.runInfoList.firstObject lastRunSectionInfo:nil];
    firstRunSectionInfo.startIndex = 0;
    [runSectionInfoList addObject:firstRunSectionInfo];
    NSInteger k=0;
    for(NSInteger index=0; index<tmpList.count; index++) {
        NSArray<RunInfo *> *list = tmpList[index];
        
        [runSectionInfoList addObjectsFromArray:[self colorListWithRunInfoList:list startIndex:k lastRunSectionInfo:runSectionInfoList.lastObject]];
        k+=list.count;
    }
    RunSectionInfo *lastRunSectionInfo = [self runSectionInfoWithRunInfo:self.runInfoList.lastObject lastRunSectionInfo:runSectionInfoList.lastObject];
    lastRunSectionInfo.startIndex = self.runInfoList.count-1;
    [runSectionInfoList addObject:lastRunSectionInfo];
    
    return [runSectionInfoList copy];
}

- (void)drawPolyLine {
    
    
    NSArray<RunSectionInfo *> *runSectionInfoList = [self caculateColorSection];
    
    NSArray<RunInfo *> *pointList = [self caculateLocation];
    NSMutableArray *colorsList = [NSMutableArray arrayWithCapacity:pointList.count];
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * pointList.count);
    NSInteger k=0;
    for(NSInteger index=0; index<self.runInfoList.count; index++) {
        
        RunInfo *runInfo = self.runInfoList[index];
        if (![pointList containsObject:runInfo]) {
            continue;
        }
        coords[k].latitude = runInfo.lat;
        coords[k].longitude = runInfo.lon;
        k++;
        for (NSInteger i=0; i<runSectionInfoList.count; i++) {
            RunSectionInfo *endRunSectionInfo = runSectionInfoList[i];
            if (index<=endRunSectionInfo.startIndex) {
                if (i == 0) {
                    [colorsList addObject:endRunSectionInfo.startColor];
                }else {
                    RunSectionInfo *startRunSection = runSectionInfoList[i-1];
                    CGFloat totalSpeed = 0;
                    CGFloat currentSpeed = 0;
                    for (NSInteger j=startRunSection.startIndex; j<=endRunSectionInfo.startIndex; j++) {
                        totalSpeed += self.runInfoList[j].speed;
                        if (j<=index) {
                            currentSpeed += self.runInfoList[j].speed;;
                        }
                    }
                    const CGFloat *startColorCompoent = CGColorGetComponents(startRunSection.startColor.CGColor);
                    const CGFloat *endColorCompoent = CGColorGetComponents(endRunSectionInfo.startColor.CGColor);
                    double t = (index-startRunSection.startIndex)*1.0/(endRunSectionInfo.startIndex-startRunSection.startIndex);
                    //double t = currentSpeed/totalSpeed;
                    float r = startColorCompoent[0] + (endColorCompoent[0] - startColorCompoent[0]) * t;
                    float g = startColorCompoent[1] + (endColorCompoent[1] - startColorCompoent[1]) * t;
                    float b = startColorCompoent[2] + (endColorCompoent[2] - startColorCompoent[2]) * t;
                    [colorsList addObject:[UIColor colorWithRed:r green:g blue:b alpha:1]];
                }
                break;
            }
        }
        
    }
    
    NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:colorsList.count];
    for(NSInteger i=0; i<colorsList.count; i++){
        [indexArray addObject:@(i)];
    }
    
    self.runPolyLine = [GBMKPolyline polylineWithCoordinates:coords count:colorsList.count drawStyleIndexes:indexArray];
    self.runPolyLine.colors = [colorsList copy];
}

- (NSArray<RunSectionInfo *> *)colorListWithRunInfoList:(NSArray<RunInfo *> *)runInfoList startIndex:(NSInteger)startIndex lastRunSectionInfo:(RunSectionInfo *)lastRunSectionInfo {
    
    if (runInfoList.count == 0) {
        return nil;
    }
    CGFloat totalSpeed = 0;
    for (int i = 0; i < runInfoList.count; i++) {
        RunInfo *info = runInfoList[i];
        totalSpeed += info.speed;
    }
    //取中点
    NSInteger centerIndex = (runInfoList.count)/2;
    RunInfo *tmpRunInfo = [[RunInfo alloc] init];
    tmpRunInfo.speed = totalSpeed/runInfoList.count;
    tmpRunInfo.lat = runInfoList[centerIndex].lat;
    tmpRunInfo.lon = runInfoList[centerIndex].lon;
    
    RunSectionInfo *third = [self runSectionInfoWithRunInfo:tmpRunInfo lastRunSectionInfo:lastRunSectionInfo];
    third.startIndex = (runInfoList.count)/2+startIndex;
    third.lat = tmpRunInfo.lat;
    third.lon = tmpRunInfo.lon;
    return @[third];
}

- (RunSectionInfo *)runSectionInfoWithRunInfo:(RunInfo *)runInfo lastRunSectionInfo:(RunSectionInfo *)lastRunSectionInfo {
    
    CGFloat speed = runInfo.speed;
    double staticSpeed = 0;
    double slowwalkSpeed = 0.5;
    double walkSpeed = 0.8;
    double fastwalked = 1.4;
    double slowRunSpeed = 2;
    double normalSpeed = 3; //
    double fastSpeed = 4.16;  //4min/km
    
    NSArray *colors = @[[UIColor colorWithWholeRed:53.0f green:255.f blue:0],
                        [UIColor colorWithWholeRed:119.0f green:255.f blue:0],
                        [UIColor colorWithWholeRed:185.0f green:255.f blue:0],
                        [UIColor colorWithWholeRed:250.0f green:255.f blue:0],
                        [UIColor colorWithWholeRed:250.0f green:180.f blue:0],
                        [UIColor colorWithWholeRed:250.0f green:105.f blue:0],
                        [UIColor colorWithWholeRed:250.0f green:22.f blue:0]];
    
    RunSectionInfo *nowRunSectionInfo = [[RunSectionInfo alloc] init];
    if (speed < staticSpeed+slowwalkSpeed/2) { //颜色取整
        nowRunSectionInfo.speedInterval = 0;
    }else if (speed < (slowwalkSpeed+walkSpeed)/2) {
        nowRunSectionInfo.speedInterval = 1;
    }else if (speed < (walkSpeed+fastwalked)/2) {
        nowRunSectionInfo.speedInterval = 2;
    } else if (speed < (fastwalked+slowRunSpeed)/2) {
        nowRunSectionInfo.speedInterval = 3;
    }else if (speed < (slowRunSpeed+normalSpeed)/2) {
        nowRunSectionInfo.speedInterval = 4;
    } else if (speed < (normalSpeed+fastSpeed)/2) {
        nowRunSectionInfo.speedInterval = 5;
    } else {
        nowRunSectionInfo.speedInterval = 6;
    }
    
    if (lastRunSectionInfo) {
        if (labs(nowRunSectionInfo.speedInterval - lastRunSectionInfo.speedInterval)>1) { //比较相邻色
            if (nowRunSectionInfo.speedInterval>lastRunSectionInfo.speedInterval) {
                nowRunSectionInfo.speedInterval = lastRunSectionInfo.speedInterval+1;
            }else {
                nowRunSectionInfo.speedInterval = lastRunSectionInfo.speedInterval-1;
            }
        }
    }
    nowRunSectionInfo.startColor = colors[nowRunSectionInfo.speedInterval];
    nowRunSectionInfo.lat = runInfo.lat;
    nowRunSectionInfo.lon = runInfo.lon;
    
    return nowRunSectionInfo;
}

#pragma mark - Setter and Getter

- (MACoordinateRegion)coordinateRegion {
    
    MACoordinateRegion region;
    region.center.latitude = (self.minLocationCoordinate2D.latitude + self.maxLocationCoordinate2D.latitude) / 2.0f;
    region.center.longitude = (self.minLocationCoordinate2D.longitude + self.maxLocationCoordinate2D.longitude) / 2.0f;
    
    region.span.latitudeDelta = (self.maxLocationCoordinate2D.latitude - self.minLocationCoordinate2D.latitude) * 1.3f;
    region.span.longitudeDelta = (self.maxLocationCoordinate2D.longitude
                                  - self.minLocationCoordinate2D.longitude) * 1.3f;
    
    return region;
}

@end

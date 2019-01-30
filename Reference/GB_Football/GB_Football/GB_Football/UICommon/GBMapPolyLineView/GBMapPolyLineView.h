//
//  GBMapPolyLineView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunInfo.h"

@interface GBMapPolyLineView : UIView

@property (nonatomic, strong) NSArray<RunInfo *> *runInfoList;

- (UIImage *)snapshotImage;

@end

//
//  GBCourtTracticsView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineUpPlayerModel.h"

@class GBCourtLineUpView;
@protocol GBCourtLineUpViewDelegate <NSObject>

- (void)courtTracticsView:(GBCourtLineUpView *)courtTracticsView didSelectAtIndexPath:(NSIndexPath *)indexPath;

- (void)courtTracticsView:(GBCourtLineUpView *)courtTracticsView removeAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GBCourtLineUpView : UIView

@property (nonatomic, weak) id<GBCourtLineUpViewDelegate> delegate;

@property (nonatomic, strong) NSArray<NSArray<LineUpPlayerModel *> *> *dataList;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, assign) BOOL isEdit;

@end

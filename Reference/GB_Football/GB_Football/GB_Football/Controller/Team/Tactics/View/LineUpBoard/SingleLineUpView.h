//
//  SingleTracticsView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineUpPlayerModel.h"

@class SingleLineUpView;
@protocol SingleLineUpViewDelegate <NSObject>

- (void)singleTracticsView:(SingleLineUpView *)singleTracticsView didSelectAtIndex:(NSInteger)index;

- (void)singleTracticsView:(SingleLineUpView *)singleTracticsView removeAtIndex:(NSInteger)index;

@end

@interface SingleLineUpView : UIView

@property (nonatomic, weak) id<SingleLineUpViewDelegate> delegate;
@property (nonatomic, strong) NSArray<LineUpPlayerModel *> *data;

//默认-1
@property (nonatomic, assign) NSInteger selectRow;
@property (nonatomic, assign) BOOL isEdit;
@end

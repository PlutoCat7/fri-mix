//
//  TracticsPlayerSelectView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineUpPlayerModel.h"
#import "TeamHomeResponeInfo.h"

@class LineUpPlayerSelectView;
@protocol LineUpPlayerSelectViewDelegate <NSObject>

- (void)tracticsPlayerSelectView:(LineUpPlayerSelectView *)tracticsPlayerSelectView didSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface LineUpPlayerSelectView : UIView

@property (nonatomic, weak) id<LineUpPlayerSelectViewDelegate> delegate;

@property (nonatomic, strong) NSArray<TeamPalyerInfo *> *dataList;

@end

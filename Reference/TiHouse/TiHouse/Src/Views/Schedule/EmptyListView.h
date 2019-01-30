//
//  EmptyListView.h
//  TiHouse
//
//  Created by apple on 2018/2/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"

typedef void(^EmptyListViewBlock)(void);

@interface EmptyListView : BaseView

@property (nonatomic, copy) EmptyListViewBlock btnClickBlock;

@end

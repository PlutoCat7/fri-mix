//
//  screenPopView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SharePopView : UIView

@property (nonatomic ,copy) void(^finishSelectde)(NSInteger tag);

-(void)Show;

@end


//
//  PieView.h
//  TiHouse
//
//  Created by gaodong on 2018/2/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieView : UIView

- (void)drawPieWithNumbers:(NSArray *)numArray
                     price:(NSNumber *)price
                  isPay:(BOOL)ispay ;
@end


//
//  GBEmptyView.h
//  GB_Football
//
//  Created by Pizza on 16/9/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBEmptyView : UIView
@property (nonatomic,strong) NSString *title;
@property (weak, nonatomic) IBOutlet UIView *roundView;
-(void)clip:(CGFloat)width;
@end

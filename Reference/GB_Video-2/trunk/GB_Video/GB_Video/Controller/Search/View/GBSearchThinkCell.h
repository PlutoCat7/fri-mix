//
//  GBSearchThinkCell.h
//  GB_Video
//
//  Created by gxd on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBSearchThinkCell : UITableViewCell

@property (assign,nonatomic) BOOL isThink;
-(void)setupConent:(NSString*)conent high:(NSString*)high;

@end

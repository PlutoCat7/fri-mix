//
//  GBFieldCell.h
//  GB_Football
//
//  Created by Pizza on 16/8/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBFieldCell : UITableViewCell

- (void)setCourtName:(NSString *)name address:(NSString *)address;
@property (nonatomic,assign) BOOL isNew;
@end

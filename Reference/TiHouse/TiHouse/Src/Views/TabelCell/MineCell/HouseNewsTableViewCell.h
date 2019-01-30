//
//  HouseNewsTableViewCell.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
@class HouseNewsTableViewCell;
@protocol HouseNewsDelegate<NSObject>

- (void)editIsreceiOpen:(HouseNewsTableViewCell *)cell;
- (void)editIsreceiClose:(HouseNewsTableViewCell *)cell;
@end

@interface HouseNewsTableViewCell : CommonTableViewCell

@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, strong) UIImageView *portraitImgv;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *houseid;

@property (nonatomic, assign) id<HouseNewsDelegate> delegate;

@end

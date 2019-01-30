//
//  MineSettingsTableViewCell.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface MineSettingsButton: UIButton

@end

@protocol MineSettingsDelegate <NSObject>

- (void)handleClick:(NSInteger)tag;

@end

@interface MineSettingsTableViewCell : CommonTableViewCell

@property (nonatomic, assign) id <MineSettingsDelegate> delegate;
@property (nonatomic, copy) NSString *badgeValue;
-(void)UnRead;

@end

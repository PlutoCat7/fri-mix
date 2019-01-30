//
//  FindAssemActivitySelectCell.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFindAssemActivitySelectCellHeight kRKBWIDTH(55)

@interface FindAssemActivitySelectCell : UITableViewCell

- (void)refreshWithName:(NSString *)name isSelect:(BOOL)isSelect;

@end

//
//  MoneyRecord_Header.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#ifndef MoneyRecord_Header_h
#define MoneyRecord_Header_h


@protocol AddTallyViewCellProtocol<UITableViewDelegate>
// 用于更新tableViewcell 高度
- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath;
@end

//
#import "NSDate+Extend.h"

// apiManager
#import "TiHouse_NetAPIManager+Tally.h"

// Helper
#import "TallyHelper.h"

// Models
#import "TallyCategory.h"

// Controller
#import "AddTallyViewController.h"

#endif /* MoneyRecord_Header_h */

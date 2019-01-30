//
//  UITableView+EmptyData.h
//  TiHouse
//
//  Created by admin on 2018/3/19.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

@import UIKit;

@interface UITableView (EmptyData)
- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;
@end

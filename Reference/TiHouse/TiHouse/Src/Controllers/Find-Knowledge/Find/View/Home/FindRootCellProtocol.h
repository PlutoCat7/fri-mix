
//
//  FindRootCellProtocol.h
//  TiHouse
//
//  Created by yahua on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#ifndef FindRootCellProtocol_h
#define FindRootCellProtocol_h

@protocol FindRootCellDelegate <NSObject>

@optional
- (void)findRootCellaAtionAttention:(UITableViewCell *)cell;
- (void)findRootCellaAtionLike:(UITableViewCell *)cell;
- (void)findRootCellaAtionCollection:(UITableViewCell *)cell;
- (void)findRootCellaAtionComment:(UITableViewCell *)cell;
- (void)findRootCellaAtionShare:(UITableViewCell *)cell;

//点击图片
- (void)findRootCellaAtionImageClick:(UITableViewCell *)cell imageIndex:(NSInteger)index;

//点击标签
- (void)findRootCellaAtionLabel:(UITableViewCell *)cell labelTitle:(NSString *)title;

@end


#endif /* FindRootCellProtocol_h */

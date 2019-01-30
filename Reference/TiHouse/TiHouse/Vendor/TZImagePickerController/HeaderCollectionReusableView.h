//
//  HeaderCollectionReusableView.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/18.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, retain) UILabel *leftLabel;
@property (nonatomic, retain) UILabel *rightLabel;
@property (nonatomic, retain) UIButton *rightBtn;

@property (nonatomic, assign) BOOL isAllSelect;


@end

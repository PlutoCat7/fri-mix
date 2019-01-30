//
//  GBGameTimeDivisionFooterView.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBGameTimeDivisionFooterViewDelegate <NSObject>

- (void)didClickDelete;

- (void)didClickAdd;

@end

@interface GBGameTimeDivisionFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, weak) id<GBGameTimeDivisionFooterViewDelegate> delegate;

- (void)setAddButtonEnable:(BOOL)enable;

- (void)setDelButtonEnable:(BOOL)enable;

@end

//
//  GBGameTypeDescView.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBGameTypeDescView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *descImageView;

+ (void)showWithGameType:(GameType)gameType;

@end

//
//  GBTacticsPlayerModel.h
//  TestDemo
//
//  Created by yahua on 2017/12/11.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TacticsPlayerType) {
    TacticsPlayerType_Football,          /**< 足球 */
    TacticsPlayerType_Home,   /**< 主队 */
    TacticsPlayerType_Guest,     /**< 客队 */
};

@interface GBTacticsPlayerModel : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) TacticsPlayerType playerType;
//home:#3FA1EC   guest:#f1b03a
@property (nonatomic, strong) UIColor *playerColor;     //战术小球所代表的颜色
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *playerNumber;
@property (nonatomic, copy) NSString *playerName;
@property (nonatomic, assign) CGPoint playerOriginPos;  //球员初始相对于战术面板的位置
@property (nonatomic, assign) CGPoint playerCurrentPos; //球员当前相对于战术面板的位置

@end

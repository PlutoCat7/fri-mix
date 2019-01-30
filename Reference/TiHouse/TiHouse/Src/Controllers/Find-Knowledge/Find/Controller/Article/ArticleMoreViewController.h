//
//  ArticleMoreViewController.h
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kArticleMoreViewControllerViewHeigth kRKBWIDTH(280)

@interface ArticleMoreViewController : UIViewController

//为了筛选剔除自己
- (instancetype)initWithArcTitle:(NSString *)title assemarcid:(NSString *)assemarcid;

@end

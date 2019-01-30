//
//  PersonDiscoveryAndArticleViewController.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger , PERSONDISCOVERYANDARTICLEVIEWCONTROLLERSTATUS) {
    PERSONDISCOVERYANDARTICLEVIEWCONTROLLERSTATUS_ALL = 0,//全部
    PERSONDISCOVERYANDARTICLEVIEWCONTROLLERSTATUS_ARTICLE = 1,//文章
    PERSONDISCOVERYANDARTICLEVIEWCONTROLLERSTATUS_PHOTO = 2//图文
};



@interface PersonDiscoveryAndArticleViewController : BaseViewController
 
@property (nonatomic, assign ) NSInteger                                 uid;
@property (nonatomic, copy   ) NSString                                  *navigationTitle;
@property (nonatomic, assign ) PERSONDISCOVERYANDARTICLEVIEWCONTROLLERSTATUS type;

@end

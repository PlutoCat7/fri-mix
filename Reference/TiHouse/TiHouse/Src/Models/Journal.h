//
//  Journal.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/22.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Journal : NSObject


@property (nonatomic ,retain) NSArray *medias;//图片数组

@property (nonatomic ,assign) CGFloat cellHeight;
@property (nonatomic ,copy) NSString *content;

@end

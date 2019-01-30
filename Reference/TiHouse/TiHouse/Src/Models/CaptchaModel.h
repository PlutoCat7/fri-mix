//
//  CaptchaModel.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaptchaModel : NSObject

@property (nonatomic, assign) long createtime, picturecodeid, updatetime, status;
@property (nonatomic, copy) NSString *picturecodeurl, *picturecodevalue;

@end

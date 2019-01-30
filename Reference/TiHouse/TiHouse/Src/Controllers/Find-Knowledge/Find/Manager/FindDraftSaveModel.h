//
//  FindDraftSaveModel.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YAHActiveObject.h"

@interface FindDraftSaveModel : YAHActiveObject

@property (nonatomic, assign) NSInteger identifier;  //唯一标识符  自动加1
@property (nonatomic, assign) NSTimeInterval createTimeInterval;
@property (nonatomic, assign) NSTimeInterval editTimeInterval;
@property (nonatomic, copy) NSString *coverFullImageUrl;  //图片url
@property (nonatomic, copy) NSString *coverHalfImageUrl;  //upload开头
@property (nonatomic, assign) CGFloat coverImageWidth;
@property (nonatomic, assign) CGFloat coverImageHeight;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *contentAttributedString;
@property (nonatomic, copy) NSString *htmlString;

@end

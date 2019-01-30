//
//  PlayerDetailCommentCellModel.h
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerDetailCommentCellModel : NSObject

@property (nonatomic, copy) NSString *userImageUrl;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, assign) CGFloat cellHeight;

@end

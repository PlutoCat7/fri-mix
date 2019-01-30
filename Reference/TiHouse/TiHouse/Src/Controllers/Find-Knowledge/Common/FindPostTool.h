//
//  FindPostTool.h
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindPostTool : NSObject

// 将 html 转 attr
+(NSAttributedString *)htmlToAttribute:(NSString *)htmlString;

// 将 attr 转 html
+(NSString *)attributeToHtml:(NSAttributedString *)attributeString;

@end

//
//  COSDefine.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/7/31.
//  Copyright © 2017年 yahua. All rights reserved.
//

#ifndef COSDefine_h
#define COSDefine_h

/////////debug环境判断//////////////
#ifdef DEBUG

#define ServerAPIBaseURL    @"http://www.zgqrmy.com/app.php"
#define ServerHost    @"www.zgqrmy.com"

#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define GBLog(...) printf("%s %s 第%d行: %s\n\n",[[[NSDate date] stringWithFormat:@"YYYY-MM-dd hh:mm:ss.SSS"] UTF8String], [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#define KGBDebug    YES

#else

#define ServerAPIBaseURL    @"http://www.zgqrmy.com/app.php"
#define ServerHost    @"www.zgqrmy.com"
#define GBLog(format, ...)

#define KGBDebug    NO

#endif

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
#define BLOCK_EXEC_SetNil(block, ...) if (block) { block(__VA_ARGS__); block = nil;};
#define kAppScale ([UIScreen mainScreen].bounds.size.width*1.0/375)
#define FONT_ADAPT(F) [UIFont systemFontOfSize:(F*kAppScale)]


#define kWeChatAppKey @"wx605aa8c11e0cca65"

#endif /* COSDefine_h */

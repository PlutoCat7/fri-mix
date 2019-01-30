
//
//  Header.h
//  MagicBean
//
//  Created by admin on 16/3/10.
//  Copyright © 2016年 wangsw. All rights reserved.

#ifndef SystemHeader_h
#define SystemHeader_h


////////////////////////////////////////////////////////////////////
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#define IOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

#define IOS7_OR_EARLIER		( !IOS8_OR_LATER )
#define IOS6_OR_EARLIER		( !IOS7_OR_LATER )
#define IOS5_OR_EARLIER		( !IOS6_OR_LATER )
#define IOS4_OR_EARLIER		( !IOS5_OR_LATER )
#define IOS3_OR_EARLIER		( !IOS4_OR_LATER )

#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height == 667) ? YES : NO)
#define IS_IPHONE6P (([[UIScreen mainScreen] bounds].size.height == 736) ? YES : NO)

#define kUIScreen_Width [[UIScreen mainScreen] bounds].size.width
#define kUIScreen_Height [[UIScreen mainScreen] bounds].size.height

#define kUIScreen_NavigationBarHeight 64
#define kUIScreen_TopBarHeight 44
#define kUIScreen_TopBarContentY 20
#define kUIScreen_TabBarHeight 49
#define kUIScreen_AppContentHeightWithTabBar  (kUIScreen_Height - kUIScreen_NavigationBarHeight - kUIScreen_TabBarHeight)
#define kUIScreen_AppContentHeight  (kUIScreen_Height - kUIScreen_NavigationBarHeight)
#endif
////////////////////////////////////////////////////////////////////


#endif //SystemHeader_h

//
//  AddressBookObject.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookObject : NSObject

@property(assign,nonatomic)NSInteger sectionNumber;
@property(assign,nonatomic)NSInteger recorID;
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *email;
@property(copy,nonatomic)NSString *tel;

// 获取通讯录
+ (NSArray<AddressBookObject *> *)getAddrBook;

+ (NSArray<NSString *> *)getAddrBookPhoneList;

@end

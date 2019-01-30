//
//  AddressBookObject.m
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "AddressBookObject.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "LogicManager.h"
@implementation AddressBookObject

+ (NSArray<AddressBookObject *> *)getAddrBook
{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        
        NSMutableArray *addressArr = [NSMutableArray new];
        
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        NSArray *keys = @[CNContactPhoneNumbersKey];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
        // 遍历
        [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            NSArray *phoneNums = contact.phoneNumbers;
            for (CNLabeledValue *labeledValue in phoneNums) {
                CNPhoneNumber *phoneNumer = labeledValue.value;
                NSString *phoneValue = phoneNumer.stringValue;
                if(![NSString stringIsNullOrEmpty:phoneValue]) {
                    AddressBookObject *addrBookObj=[[AddressBookObject alloc]init];
                    addrBookObj.tel = phoneValue;
                    [addressArr addObject:addrBookObj];
                    break;
                }
            }
        }];
        return [addressArr copy];
    }else {
        
        NSMutableArray *addressArr = [NSMutableArray new];
        
        ABAddressBookRef addressBooks=nil;
        if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0)
        {
            addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
            //获取通讯录权限
            dispatch_semaphore_t sema=dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            //dispatch_release(sema);
        }
        else
        {
            addressBooks=ABAddressBookCreate();
        }
        //获取通讯录中所有的人
        CFArrayRef appPeople=ABAddressBookCopyArrayOfAllPeople(addressBooks);
        //获取通讯录人数
        CFIndex nPeopel=ABAddressBookGetPersonCount(addressBooks);
        if (addressBooks) {
            CFRelease(addressBooks);
        }
        //循环获取每个人的个人信息
        for (NSInteger i=0; i<nPeopel; i++)
        {
            //新建一个addressbook model类
            AddressBookObject *addrBookObj=[[AddressBookObject alloc]init];
            //获取个人
            ABRecordRef person=CFArrayGetValueAtIndex(appPeople, i);
            //获取个人名字
            CFTypeRef abName=ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFTypeRef abLastName=ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
            CFStringRef abFullName=ABRecordCopyCompositeName(person);
            NSString *namestring=(__bridge NSString *)abName;
            NSString *lastName=(__bridge NSString *)abLastName;
            if ((__bridge id)abFullName !=nil)
            {
                namestring =[(__bridge NSString *)abFullName copy];
                CFRelease(abFullName);
            }
            else
            {
                if ((__bridge id)abLastName!=nil)
                {
                    namestring = [NSString stringWithFormat:@"%@ %@",namestring,lastName];
                }
            }
            addrBookObj.name=namestring;
            addrBookObj.recorID=(int)ABRecordGetRecordID(person);
            ABPropertyID multiproperties[]={
                kABPersonPhoneProperty,
                kABPersonEmailProperty
            };
            NSInteger multiPropertiesTotal =sizeof(multiproperties) /sizeof(ABPropertyID);
            for (NSInteger j=0; j<multiPropertiesTotal; j++)
            {
                ABPropertyID property=multiproperties[j];
                ABMultiValueRef valueref=ABRecordCopyValue(person, property);
                NSInteger valuesCount=0;
                if (valueref !=nil)
                {
                    valuesCount = ABMultiValueGetCount(valueref);
                    CFRelease(valueref);
                }
                if (valuesCount==0)
                {
                    continue;
                }
                for (NSInteger k=0; k<valuesCount; k++)
                {
                    CFTypeRef value=ABMultiValueCopyValueAtIndex(valueref, k);
                    switch (j)
                    {
                        case 0:
                            //手机号
                            addrBookObj.tel=(__bridge NSString *)(value);
                            break;
                        case 1:
                            //email
                            addrBookObj.email=(__bridge NSString *)(value);
                            break;
                        default:
                            break;
                    }
                    CFRelease(value);
                }
            }
            //将个人信息添加到数组中，循环完成后addressbooktemp中包含所有联系人的信息
            [addressArr addObject:addrBookObj];
            if (abName)
            {
                CFRelease(abName);
            }
            if (abLastName)
            {
                CFRelease(abLastName);
            }
        }
        if (appPeople) {
            CFRelease(appPeople);
        }
        return [addressArr copy];
    }
}

+ (NSArray<NSString *> *)getAddrBookPhoneList {
    
    NSMutableArray *phoneArray = [NSMutableArray new];
    if (![LogicManager checkIsOpenContact]) {
        return [phoneArray copy];
    }
    
    NSArray *addrBookArray = [AddressBookObject getAddrBook];
   
    for (AddressBookObject *addrBookObj in addrBookArray) {
        if (addrBookObj && addrBookObj.tel && addrBookObj.tel.length > 0) {
            NSString *phone = [addrBookObj.tel adjustmentPhone];
            [phoneArray addObject:phone];
        }
        
    }
    return [phoneArray copy];
}

@end

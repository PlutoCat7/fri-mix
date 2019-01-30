//
//  NSObject+ObjectMap.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "NSObject+ObjectMap.h"
#import <objc/runtime.h>

#define OMDateFormat @"yyyy-MM-dd'T'HH:mm:ss.SSS"
#define OMTimeZone @"UTC"

@implementation NSObject (ObjectMap)


+(NSMutableArray *)arrayMapFromArray:(NSArray *)nestedArray forPropertyName:(NSString *)propertyName {
    // Set Up
    NSMutableArray *objectsArray = [@[] mutableCopy];
    
    // Removes "ArrayOf(PropertyName)s" to get to the meat
    //NSString *filteredProperty = [propertyName substringWithRange:NSMakeRange(0, propertyName.length - 1)]; /* TenEight */
    //NSString *filteredProperty = [propertyName substringWithRange:NSMakeRange(7, propertyName.length - 8)]; /* AlaCop */
    // Create objects
    for (int xx = 0; xx < nestedArray.count; xx++) {
        // If it's an NSDictionary
        if ([nestedArray[xx] isKindOfClass:[NSDictionary class]]) {
            // Create object of filteredProperty type
            id nestedObj = [[NSClassFromString(propertyName) alloc] init];
            
            // Iterate through each key, create objects for each
            for (NSString *newKey in [nestedArray[xx] allKeys]) {
                // If it's an Array, recur
                if ([[nestedArray[xx] objectForKey:newKey] isKindOfClass:[NSArray class]]) {
                    //添加属性判断，防止运行时崩溃
                    objc_property_t property = class_getProperty([NSClassFromString(propertyName) class], [@"propertyArrayMap" UTF8String]);
                    if (!property) {
                        continue;
                    }
                    NSString *propertyType = [nestedObj valueForKeyPath:[NSString stringWithFormat:@"propertyArrayMap.%@", newKey]];
                    if (!propertyType) {
                        continue;
                    }
                    [nestedObj setValue:[NSObject arrayMapFromArray:[nestedArray[xx] objectForKey:newKey]  forPropertyName:propertyType] forKey:newKey];
                }
                // If it's a Dictionary, create an object, and send to [self objectFromJSON]
                else if ([[nestedArray[xx] objectForKey:newKey] isKindOfClass:[NSDictionary class]]) {
                    NSString *type = [nestedObj classOfPropertyNamed:newKey];
                    if (!type) {
                        continue;
                    }
                    
                    id nestedDictObj = [NSObject objectOfClass:type fromJSON:[nestedArray[xx] objectForKey:newKey]];
                    [nestedObj setValue:nestedDictObj forKey:newKey];
                }
                // Else, it is an object
                else {
                    NSString *tempNewKey;
                    if ([newKey isEqualToString:@"description"] || [newKey isEqualToString:@"hash"]) {
                        tempNewKey = [newKey stringByAppendingString:@"_mine"];
                    }else{
                        tempNewKey = newKey;
                    }
                    objc_property_t property = class_getProperty([NSClassFromString(propertyName) class], [tempNewKey UTF8String]);
                    if (!property) {
                        continue;
                    }
                    NSString *classType = [self typeFromProperty:property];
                    // check if NSDate or not
                    if ([classType isEqualToString:@"T@\"NSDate\""]) {
                        //                        1970年的long型数字
                        NSObject *obj = [nestedArray[xx] objectForKey:newKey];
                        if ([obj isKindOfClass:[NSNumber class]]) {
                            NSNumber *timeSince1970 = (NSNumber *)obj;
                            NSTimeInterval timeSince1970TimeInterval = timeSince1970.doubleValue/1000;
                            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSince1970TimeInterval];
                            [nestedObj setValue:date forKey:tempNewKey];
                        }else{
                            //                            日期字符串
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:OMDateFormat];
                            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:OMTimeZone]];
                            
                            NSString *dateString = [[nestedArray[xx] objectForKey:newKey] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                            [nestedObj setValue:[formatter dateFromString:dateString] forKey:tempNewKey];
                        }
                    }
                    else {
                        [nestedObj setValue:[nestedArray[xx] objectForKey:newKey] forKey:tempNewKey];
                    }
                }
            }
            
            // Finally add that object
            [objectsArray addObject:nestedObj];
        }
        
        // If it's an NSArray, recur
        else if ([nestedArray[xx] isKindOfClass:[NSArray class]]) {
            [objectsArray addObject:[NSObject arrayMapFromArray:nestedArray[xx] forPropertyName:propertyName]];
        }
        
        // Else, add object directly
        else {
            [objectsArray addObject:nestedArray[xx]];
        }
    }
    
    // This is now an Array of objects
    return objectsArray;
}


#pragma mark - Dictionary to Object
+(id)objectOfClass:(NSString *)object fromJSON:(NSDictionary *)dict {
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id newObject = [[NSClassFromString(object) alloc] init];
    
    NSDictionary *mapDictionary = [newObject propertyDictionary];
    
    for (NSString *key in [dict allKeys]) {
        NSString *tempKey;
        if ([key isEqualToString:@"description"] || [key isEqualToString:@"hash"]) {
            tempKey = [key stringByAppendingString:@"_mine"];
        }else{
            tempKey = key;
        }
        NSString *propertyName = [mapDictionary objectForKey:tempKey];
        if (!propertyName) {
            continue;
        }
        // If it's a Dictionary, make into object
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            //id newObjectProperty = [newObject valueForKey:propertyName];
            NSString *propertyType = [newObject classOfPropertyNamed:propertyName];
            id nestedObj = [NSObject objectOfClass:propertyType fromJSON:[dict objectForKey:key]];
            [newObject setValue:nestedObj forKey:propertyName];
        }
        
        // If it's an array, check for each object in array -> make into object/id
        else if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
            NSArray *nestedArray = [dict objectForKey:key];
            NSString *propertyType = [newObject valueForKeyPath:[NSString stringWithFormat:@"propertyArrayMap.%@", key]];
            [newObject setValue:[NSObject arrayMapFromArray:nestedArray forPropertyName:propertyType] forKey:propertyName];
        }
        
        // Add to property name, because it is a type already
        else {
            objc_property_t property = class_getProperty([newObject class], [propertyName UTF8String]);
            if (!property) {
                continue;
            }
            NSString *classType = [newObject typeFromProperty:property];
            
            // check if NSDate or not
            if ([classType isEqualToString:@"T@\"NSDate\""]) {
                //                1970年的long型数字
                NSObject *obj = [dict objectForKey:key];
                if ([obj isKindOfClass:[NSNumber class]]) {
                    NSNumber *timeSince1970 = (NSNumber *)obj;
                    NSTimeInterval timeSince1970TimeInterval = timeSince1970.doubleValue/1000;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSince1970TimeInterval];
                    [newObject setValue:date forKey:propertyName];
                }else{
                    //                            日期字符串
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:OMDateFormat];
                    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:OMTimeZone]];
                    NSString *dateString = [[dict objectForKey:key] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    [newObject setValue:[formatter dateFromString:dateString] forKey:propertyName];
                }
            }
            else {
                if ([dict objectForKey:key] != [NSNull null]) {
                    [newObject setValue:[dict objectForKey:key] forKey:propertyName];
                }
                else {
                    [newObject setValue:nil forKey:propertyName];
                }
            }
        }
    }
    
    return newObject;
}

-(NSDictionary *)propertyDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:key forKey:key];
    }
    
    free(properties);
    
    // Add all superclass properties as well, until it hits NSObject
    NSString *superClassName = [[self superclass] nameOfClass];
    if (![superClassName isEqualToString:@"NSObject"]) {
        for (NSString *property in [[[self superclass] propertyDictionary] allKeys]) {
            [dict setObject:property forKey:property];
        }
    }
    
    return dict;
}

-(NSString *)nameOfClass {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

-(NSString *)classOfPropertyNamed:(NSString *)propName {
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int xx = 0; xx < count; xx++) {
        NSString *curProperty = [NSString stringWithUTF8String:property_getName(properties[xx])];
        if ([curProperty isEqualToString:propName]) {
            NSString *className = [NSString stringWithFormat:@"%s", getPropertyType(properties[xx])];
            free(properties);
            return className;
        }
    }
    
    return nil;
}

static const char * getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //    printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

-(NSString *)typeFromProperty:(objc_property_t)property {
    return [[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","][0];
}

@end

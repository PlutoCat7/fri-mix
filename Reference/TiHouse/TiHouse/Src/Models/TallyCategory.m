//
//  TallyCategory.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TallyCategory.h"

#define kTallCategoryDataPath @"tallcategory_data_path.plist"

@implementation TallyCategory

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"catetwoList": [TallySecondCategoryModel class]
             };
}

MJExtensionCodingImplementation

+ (void)saveData:(NSArray *)categoryList {
    [NSKeyedArchiver archiveRootObject:categoryList toFile:[self loginDataListPath]];
}

+ (NSArray *)readData {
    NSArray *aray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self loginDataListPath]];
    return aray;
}

+ (NSString *)loginDataListPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:kTallCategoryDataPath];
}

@end

@implementation TallySecondCategoryModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"tallytempletList": [TallyThridCategoryModel class]
             };
}
@end
@implementation TallyThridCategoryModel

@end

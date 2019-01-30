//
//  GBEvalutionString.h
//  GB_Football
//
//  Created by Pizza on 2017/1/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBEvalutionString : NSObject
@property (nonatomic,strong) NSArray<NSString*> *distanceDescribe1;
@property (nonatomic,strong) NSArray<NSString*> *distanceDescribe2;
@property (nonatomic,strong) NSArray<NSString*> *highspeedDescribe1;
@property (nonatomic,strong) NSArray<NSString*> *highspeedDescribe2;
@property (nonatomic,strong) NSArray<NSString*> *calorieDescribe1;
@property (nonatomic,strong) NSArray<NSString*> *calorieDescribe2;
@property (nonatomic,strong) NSArray<NSString*> *runpowerDescribe1;
@property (nonatomic,strong) NSArray<NSString*> *runpowerDescribe2;
@property (nonatomic,strong) NSArray<NSString*> *decayDescribe1;
@property (nonatomic,strong) NSArray<NSString*> *decayDescribe2;
@property (nonatomic,strong) NSArray<NSString*> *foodName;

@property (nonatomic,strong) NSArray<NSString*> *distanceEnglish;
@property (nonatomic,strong) NSArray<NSString*> *highspeedEnglish;
@property (nonatomic,strong) NSArray<NSString*> *calorieEnglish;
@property (nonatomic,strong) NSArray<NSString*> *runpowerEnglish;
@property (nonatomic,strong) NSArray<NSString*> *decayEnglish;
@end

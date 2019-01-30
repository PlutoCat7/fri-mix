//
//  GBEvalutionString.m
//  GB_Football
//
//  Created by Pizza on 2017/1/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBEvalutionString.h"

@implementation GBEvalutionString

-(id)init
{
    self = [super init];
    self.distanceDescribe1 = @[
                               LS(@"analyse.distance.describe1.level1"),
                               LS(@"analyse.distance.describe1.level2"),
                               LS(@"analyse.distance.describe1.level3"),
                               LS(@"analyse.distance.describe1.level4")];
    
    self.distanceDescribe2 = @[
                               LS(@"analyse.distance.describe2.level1"),
                               LS(@"analyse.distance.describe2.level2"),
                               LS(@"analyse.distance.describe2.level3"),
                               LS(@"analyse.distance.describe2.level4")];
    
    self.highspeedDescribe1 = @[
                              LS(@"analyse.highspeed.describe1.level1"),
                              LS(@"analyse.highspeed.describe1.level2"),
                              LS(@"analyse.highspeed.describe1.level3"),
                              LS(@"analyse.highspeed.describe1.level4")];
    
    self.highspeedDescribe2 = @[
                              LS(@"analyse.highspeed.describe2.level1"),
                              LS(@"analyse.highspeed.describe2.level2"),
                              LS(@"analyse.highspeed.describe2.level3"),
                              LS(@"analyse.highspeed.describe2.level4")];
    
    
    self.calorieDescribe1  = @[
                              LS(@"analyse.calorie.describe1.level1"),
                              LS(@"analyse.calorie.describe1.level2"),
                              LS(@"analyse.calorie.describe1.level3"),
                              LS(@"analyse.calorie.describe1.level4")];
    self.calorieDescribe2  = @[
                              LS(@"analyse.calorie.describe2.level1"),
                              LS(@"analyse.calorie.describe2.level2"),
                              LS(@"analyse.calorie.describe2.level3"),
                              LS(@"analyse.calorie.describe2.level4")];
    
    
    self.runpowerDescribe1 = @[
                               LS(@"analyse.runpower.describe1.level1"),
                               LS(@"analyse.runpower.describe1.level2"),
                               LS(@"analyse.runpower.describe1.level3"),
                               LS(@"analyse.runpower.describe1.level4")];
    self.runpowerDescribe2 = @[
                               LS(@"analyse.runpower.describe2.level1"),
                               LS(@"analyse.runpower.describe2.level2"),
                               LS(@"analyse.runpower.describe2.level3"),
                               LS(@"analyse.runpower.describe2.level4")];
    
    self.decayDescribe1    = @[
                            LS(@"analyse.decay.describe1.level1"),
                            LS(@"analyse.decay.describe1.level2"),
                            LS(@"analyse.decay.describe1.level3"),
                            LS(@"analyse.decay.describe1.level4")];
    
    self.decayDescribe2    = @[
                            LS(@"analyse.decay.describe2.level1"),
                            LS(@"analyse.decay.describe2.level2"),
                            LS(@"analyse.decay.describe2.level3"),
                            LS(@"analyse.decay.describe2.level4")];
    
    self.foodName = @[
                      LS(@"analyse.food.label.tomato"),
                      LS(@"analyse.food.label.apple"),
                      LS(@"analyse.food.label.corn"),
                      LS(@"analyse.food.label.newcake"),
                      LS(@"analyse.food.label.french"),
                      LS(@"analyse.food.label.hamburg"),
                      LS(@"analyse.food.label.milksh"),
                      LS(@"analyse.food.label.walnut"),
                      LS(@"analyse.food.label.drbeef"),
                      LS(@"analyse.food.label.rice"),
                      LS(@"analyse.food.label.noodle"),
                      LS(@"analyse.food.label.snkickers")];
    
    self.distanceEnglish = @[
                      LS(@"analyse.distance.english.level1"),
                      LS(@"analyse.distance.english.level2"),
                      LS(@"analyse.distance.english.level3"),
                      LS(@"analyse.distance.english.level4")];
    
    self.highspeedEnglish = @[
                              LS(@"analyse.highspeed.english.level1"),
                              LS(@"analyse.highspeed.english.level2"),
                              LS(@"analyse.highspeed.english.level3"),
                              LS(@"analyse.highspeed.english.level4")];
    
    self.calorieEnglish = @[
                            LS(@"analyse.calorie.english.level1"),
                            LS(@"analyse.calorie.english.level2"),
                            LS(@"analyse.calorie.english.level3"),
                            LS(@"analyse.calorie.english.level4")];
    
    self.runpowerEnglish = @[
                             LS(@"analyse.runpower.english.level1"),
                             LS(@"analyse.runpower.english.level2"),
                             LS(@"analyse.runpower.english.level3"),
                             LS(@"analyse.runpower.english.level4")];
    
    self.decayEnglish = @[
                          LS(@"analyse.decay.english.level1"),
                          LS(@"analyse.decay.english.level2"),
                          LS(@"analyse.decay.english.level3"),
                          LS(@"analyse.decay.english.level4")];
    
    return self;
}
@end


//
//  SettingAuthView.m
//  TiHouse
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SettingAuthView.h"
#import "Login.h"

@implementation SettingAuthView

- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray new];
    }
    return _arr;
}

- (void)setPerson:(Houseperson *)person{
    _person = person;
    
    if (person.isedit) {
        [self.btnEdit setImage:IMAGE_ANME(@"r_select") forState:UIControlStateNormal];
    }else{
        [self.btnEdit setImage:IMAGE_ANME(@"r_no_select") forState:UIControlStateNormal];
    }
    
    if (person.isreaddairy) {
        [self.btnPhoto setImage:IMAGE_ANME(@"r_select") forState:UIControlStateNormal];
        if (![self.arr containsObject:@"照片、视频、日记"]) {
            [self.arr addObject:@"照片、视频、日记"];
        }
        
    } else {
        [self.btnPhoto setImage:IMAGE_ANME(@"r_no_select") forState:UIControlStateNormal];
        if ([self.arr containsObject:@"照片、视频、日记"]) {
            [self.arr removeObject:@"照片、视频、日记"];
        }
    }
    
    if (person.isreadbudget) {
        [self.btnBudget setImage:IMAGE_ANME(@"r_select") forState:UIControlStateNormal];
        
        if (![self.arr containsObject:@"预算"]) {
            [self.arr addObject:@"预算"];
        }
        
    } else {
        [self.btnBudget setImage:IMAGE_ANME(@"r_no_select") forState:UIControlStateNormal];
        if ([self.arr containsObject:@"预算"]) {
            [self.arr removeObject:@"预算"];
        }
    }
    
    if (person.isreadtally) {
        [self.btnAccount setImage:IMAGE_ANME(@"r_select") forState:UIControlStateNormal];
        
        if (![self.arr containsObject:@"记账"]) {
            [self.arr addObject:@"记账"];
        }
        
    } else {
        [self.btnAccount setImage:IMAGE_ANME(@"r_no_select") forState:UIControlStateNormal];
        if ([self.arr containsObject:@"记账"]) {
            [self.arr removeObject:@"记账"];
        }
    }
    
    if (person.isreadschedule) {
        [self.btnSchedule setImage:IMAGE_ANME(@"r_select") forState:UIControlStateNormal];
        if (![self.arr containsObject:@"日程"]) {
            [self.arr addObject:@"日程"];
        }
        
    } else {
        [self.btnSchedule setImage:IMAGE_ANME(@"r_no_select") forState:UIControlStateNormal];
        if ([self.arr containsObject:@"日程"]) {
            [self.arr removeObject:@"日程"];
        }
    }
    if (self.arr.count>0) {
        if ([self.arr containsObject:@"预算"]) {
            [self.arr removeObject:@"预算"];
        }

        if ([self.arr containsObject:@"记账"]) {
            [self.arr removeObject:@"记账"];
        }
        
        if ([self.arr containsObject:@"日程"]) {
            [self.arr removeObject:@"日程"];
        }

        self.lblTip.text = JString(@"可添加:%@",[self.arr componentsJoinedByString:@","]);
//        self.editImage.image = IMAGE_ANME(@"r_select");
        self.imgVVisitor.image = IMAGE_ANME(@"r_select");
    } else {
        
        self.lblTip.text = @"--";
//        self.editImage.image = IMAGE_ANME(@"r_no_select");
        self.imgVVisitor.image = IMAGE_ANME(@"r_no_select");
    }
}


- (IBAction)photoClick:(id)sender {
    
    if (!_isMaster) {
        [NSObject showStatusBarErrorStr:@"您没有权限编辑"];
        return;
    }
    
    if (_person.isreaddairy) {
        return;
    }
    _person.isreaddairy = !_person.isreaddairy;
    [self uploadAuth];
}

- (IBAction)budgetClick:(id)sender {
    if (!_isMaster) {
        [NSObject showStatusBarErrorStr:@"您没有权限编辑"];
        return;
    }
    _person.isreadbudget = !_person.isreadbudget;
    [self uploadAuth];
}

- (IBAction)accountClick:(id)sender {
    if (!_isMaster) {
        [NSObject showStatusBarErrorStr:@"您没有权限编辑"];
        return;
    }
    _person.isreadtally = !_person.isreadtally;
    [self uploadAuth];
}

- (IBAction)scheduleClick:(id)sender {
    if (!_isMaster) {
        [NSObject showStatusBarErrorStr:@"您没有权限编辑"];
        return;
    }
    
    _person.isreadschedule = !_person.isreadschedule;
    
    [self uploadAuth];
}

- (IBAction)editClick:(id)sender {
    if (!_isMaster) {
        [NSObject showStatusBarErrorStr:@"您没有权限编辑"];
        return;
    }
    
    _person.isedit = !_person.isedit;
    
    [self uploadAuth];
    
}


- (void)uploadAuth{
    
    __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window beginLoading];
    WS(weakSelf);
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:URL_Edit_Fri_Auth withParams:[self getParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        [appDelegate.window endLoading];
        if ([data[@"is"] intValue]) {
            weakSelf.person = _person;
            [NSObject showStatusBarSuccessStr:@"设置成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            });
            
        }else{
            [NSObject showStatusBarErrorStr:data[@"msg"]];
        }
    }];
}

- (NSDictionary *)getParams{
    User *user = [Login curLoginUser];
    return @{
             @"uid":JLong2String(user.uid),
             @"housepersonid":JLong2String(self.person.housepersonid),
             @"isedit":@(self.person.isedit),
             @"isreaddairy":@(self.person.isreaddairy),
             @"isreadbudget":@(self.person.isreadbudget),
             @"isreadtally":@(self.person.isreadtally),
             @"isreadschedule":@(self.person.isreadschedule)
             };
}

/*
 
 uid
 housepersonid
 isedit
 isreaddairy
 isreadbudget
 isreadtally
 isreadschedule
 */


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end


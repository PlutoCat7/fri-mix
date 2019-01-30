//
//  RelativeAndFriendHeadView.m
//  TiHouse
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RelativeAndFriendHeadView.h"
#import "Houseperson.h"
#import "NSDate+Extend.h"
#import "Login.h"

@implementation RelativeAndFriendHeadView

- (void)setMasters:(NSArray *)masters{
    _masters = masters;
    
    self.fTime.text = @"";
    self.fHead.image = IMAGE_ANME(@"invite_icon");
    self.mTime.text = @"";
    self.mHead.image = IMAGE_ANME(@"invite_icon");
    self.mMe.hidden = self.fMe.hidden = YES;
    
    Houseperson *fPerson = nil,*mPerson = nil;
    
    for (Houseperson *per in masters) {
        if (per.typerelation == 1) {//女主人
            fPerson = per;
        }else {
            mPerson = per;
        }
       
    }
    User *user = [Login curLoginUser];
    
    
    if (fPerson) {//女主人
        NSDate *date = [NSDate dateFromTimestamp:fPerson.updatetime/1000];
        NSString *strDate = [NSDate stringWithDate:date format:@"MM-dd hh:mm"];
        self.fTime.text = JString(@"最近：%@",strDate);;
        self.fMe.hidden = user.uid != fPerson.uidconcert;
        [self.fHead sd_setImageWithURL:[NSURL URLWithString:fPerson.urlhead] placeholderImage:IMAGE_ANME(@"invite_icon")];
        self.womanLabel.text = @"女主人";
    } else {
        self.womanLabel.text = @"邀请女主人加入";
    }
    
    
     if (mPerson) {//男主人
         NSDate *date = [NSDate dateFromTimestamp:mPerson.updatetime/1000];
         NSString *strDate = [NSDate stringWithDate:date format:@"MM-dd hh:mm"];
         self.mMe.hidden = user.uid != mPerson.uidconcert;
         self.mTime.text = JString(@"最近：%@",strDate);
         [self.mHead sd_setImageWithURL:[NSURL URLWithString:mPerson.urlhead] placeholderImage:IMAGE_ANME(@"invite_icon")];
         self.manLabel.text = @"男主人";
     } else {
         self.manLabel.text = @"邀请男主人加入";
     }
    
}

- (IBAction)fTap:(id)sender {
    if (_house.uidcreater != [Login curLoginUser].uid) {
        [NSObject showHudTipStr:@"只有房屋创建者可以邀请亲友"];
        return;
    }
    for (Houseperson *per in self.masters) {
        if (per.typerelation == 1) {//女主人
            if (_callback) {
                _callback(per);
                return;
            }
        }
    }
    _callback(nil);
}

- (IBAction)mTap:(id)sender {
    if (_house.uidcreater != [Login curLoginUser].uid) {
        [NSObject showHudTipStr:@"只有房屋创建者可以邀请亲友"];
        return;
    }
    for (Houseperson *per in self.masters) {
        if (per.typerelation == 2) {//男主人
            if (_callback) {
                _callback(per);
                return;
            }
        }
    }
    _callback(nil);
}

- (void)setHouse:(House *)house {
    _house = house;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

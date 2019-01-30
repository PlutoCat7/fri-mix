//
//  User.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "User.h"

@implementation User

- (id)copyWithZone:(NSZone *)zone {
    User *model = [[User allocWithZone:zone] init];
    model.mobile = self.mobile;
    model.password = self.password;
    model.username = self.username;
    model.token = self.token;
    model.uidconcert = self.uidconcert;
    model.folderid = self.folderid;
    model.typerelation = self.typerelation;
    model.uid = self.uid;
    model.registtime = self.registtime;
    model.birthdaytime = self.birthdaytime;
    model.status = self.status;
    model.sex = self.sex;
    model.selected = self.selected;
    model.urlhead = self.urlhead;
    model.nickname = self.nickname;
    model.rongcloudToken = self.rongcloudToken;
    return model;
}


@end

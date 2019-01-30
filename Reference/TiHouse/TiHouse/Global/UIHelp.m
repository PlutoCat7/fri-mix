//
//  UIHelp.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/16.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "UIHelp.h"
#import "NSDate+Extend.h"

@implementation UIHelp

+(NSArray *)getAddHouseUI{
    UIModel * model1 = [[UIModel alloc]initWithTitleStr:@"*名称" TextFieldPlaceholder:@"请输入"];
    UIModel * model2 = [[UIModel alloc]initWithTitleStr:@"*小区" TextFieldPlaceholder:@"请输入"];
    UIModel * model3 = [[UIModel alloc]initWithTitleStr:@"*面积" TextFieldPlaceholder:@"请输入"];
    UIModel * model4 = [[UIModel alloc]initWithTitleStr:@"*户型" TextFieldPlaceholder:@"请选择"];
    UIModel * model5 = [[UIModel alloc]initWithTitleStr:@"*地区" TextFieldPlaceholder:@"请选择"];
    UIModel * model6 = [[UIModel alloc]initWithTitleStr:@" 详址" TextFieldPlaceholder:@"请输入"];
    UIModel * model7 = [[UIModel alloc]initWithTitleStr:@"*您与房屋的关系" TextFieldPlaceholder:@"请选择"];
    NSArray *modelo = @[model1,model2,model3,model4,model5,model6];
    NSArray *modelw = @[model7];
    NSArray *models = @[modelo, modelw];
    
    return models;
}

+(NSArray *)getRelationUIWithHousename:(NSString *)housename{
    UIModel * model1 = [[UIModel alloc]initWithTitleStr:[NSString stringWithFormat:@"与“%@”的关系",housename] TextFieldPlaceholder:@"请选择"];
    UIModel * model2 = [[UIModel alloc]initWithTitleStr:@"昵称" TextFieldPlaceholder:@"请输入"];
    NSArray *models = @[model1, model2];
    
    return models;
}

+(NSArray *)getHouseChangeUI{
    
    UIModel * model1 =  [[UIModel alloc]initWithTitleStr:@"记录时间" TextFieldPlaceholder:@"拍摄时间" Icon:@"clock_icon"];
    UIModel * model2 =  [[UIModel alloc]initWithTitleStr:@"放入文件夹" TextFieldPlaceholder:@"默认" Icon:@"file_icon"];
    UIModel * model3 =  [[UIModel alloc]initWithTitleStr:@"可见范围" TextFieldPlaceholder:@"所有亲友" Icon:@"eye_icon"];
    UIModel * model4 =  [[UIModel alloc]initWithTitleStr:@"提醒谁看" TextFieldPlaceholder:@"" Icon:@"at_icon"];
    
    NSArray *models = @[model1,model2,model3,model4];
    return models;
}


+(NSArray *)getRecordingTimeUI{
    
    UIModel * model1 =  [[UIModel alloc]initWithTitleStr:@"拍摄时间" TextFieldPlaceholder:@"默认，如多张不同拍摄日期照片则自动拆分上传"];
    UIModel * model2 =  [[UIModel alloc]initWithTitleStr:@"当前时间" TextFieldPlaceholder:[NSDate ymdFormat]];
    UIModel * model3 =  [[UIModel alloc]initWithTitleStr:@"自定义时间" TextFieldPlaceholder:@""];
    
    NSArray *models = @[model1,model2,model3];
    return models;
}

+(NSArray *)getFriendsRange{
    
    UIModel * model1 =  [[UIModel alloc]initWithTitleStr:@"所有亲友" TextFieldPlaceholder:@"" Icon:@"photo_-unselected"];
    UIModel * model2 =  [[UIModel alloc]initWithTitleStr:@"仅自己" TextFieldPlaceholder:@"" Icon:@"photo_-unselected"];
    UIModel * model3 =  [[UIModel alloc]initWithTitleStr:@"选择好友" TextFieldPlaceholder:@"" Icon:@"photo_-unselected"];
    
    NSArray *models = @[model1,model2,model3];
    return models;
}

+(NSArray *)getNewBudgerUI{
    
    UIModel * model1 =  [[UIModel alloc]initWithTitleStr:@"所在地区" TextFieldPlaceholder:@""];
    UIModel * model2 =  [[UIModel alloc]initWithTitleStr:@"装修面积" TextFieldPlaceholder:@""];
    //    UIModel * model3 =  [[UIModel alloc]initWithTitleStr:@"期望总价" TextFieldPlaceholder:@""];
    UIModel * model4 =  [[UIModel alloc]initWithTitleStr:@"房屋户型" TextFieldPlaceholder:@""];
    
    NSArray *models = @[model1,model2,model4];
    return models;
}


+ (NSArray *)getSettingsUI {
    UIModel * model1 = [[UIModel alloc]initWithTitleStr:@"账号信息"];
    UIModel * model2 = [[UIModel alloc]initWithTitleStr:@"消息通知"];
    UIModel * model3 = [[UIModel alloc]initWithTitleStr:@"推荐给好友"];
    UIModel * model4 = [[UIModel alloc]initWithTitleStr:@"关于有数啦"];
    UIModel * model5 = [[UIModel alloc]initWithTitleStr:@"清理占用空间"];
    UIModel * model6 = [[UIModel alloc]initWithTitleStr:@"只使用WIFI上传大文件"];
    NSArray *modela = @[model1, model2];
    NSArray *modelb = @[model3, model4];
    NSArray *modelc = @[model5, model6];
    NSArray *models = @[modela, modelb, modelc];
    
    return models;
}

+ (NSArray *)getAccountInfoUI {
    UIModel * model1 = [[UIModel alloc]initWithTitleStr:@"手机号"];
    UIModel * model2 = [[UIModel alloc]initWithTitleStr:@"登陆密码"];
    UIModel * model3 = [[UIModel alloc]initWithTitleStr:@"微信"];
    UIModel * model4 = [[UIModel alloc]initWithTitleStr:@"微博"];
    UIModel * model5 = [[UIModel alloc]initWithTitleStr:@"QQ"];
    NSArray *modela = @[model1, model2];
    NSArray *modelb = @[model3, model4, model5];
    NSArray *models = @[modela, modelb];
    return models;
}

+ (NSArray *)getAboutUSUI {
    UIModel * model1 = [[UIModel alloc]initWithTitleStr:@"给有数啦打个分吧" TextFieldPlaceholder:@""];
    UIModel * model2 = [[UIModel alloc]initWithTitleStr:@"帮助中心" TextFieldPlaceholder:@""];
    UIModel * model3 = [[UIModel alloc]initWithTitleStr:@"官方客服" TextFieldPlaceholder:@"(工作日9:00-19:00)"];
    NSArray *models = @[model1, model2, model3];
    return models;
}

+ (NSArray *)getClearCacheUI {
    UIModel * model1 = [[UIModel alloc]initWithTitleStr:@"总占用空间"];
    UIModel * model2 = [[UIModel alloc]initWithTitleStr:@"下载占用"];
    UIModel * model3 = [[UIModel alloc]initWithTitleStr:@"缓存占用"];
    NSArray *modela = @[model1];
    NSArray *modelb = @[model2, model3];
    NSArray *models = @[modela, modelb];
    return models;
}

+ (NSArray *)getNotificationUI {
    UIModel * model1 = [[UIModel alloc]initWithTitleStr:@"接收新消息通知"];
    UIModel * model2 = [[UIModel alloc]initWithTitleStr:@"房屋动态"];
//    UIModel * model3 = [[UIModel alloc]initWithTitleStr:@"互动消息"];
    UIModel * model4 = [[UIModel alloc]initWithTitleStr:@"声音提醒"];
    UIModel * model5 = [[UIModel alloc]initWithTitleStr:@"振动提醒"];
    UIModel * model6 = [[UIModel alloc]initWithTitleStr:@"有数小报"];
    NSArray *modela = @[model1];
//    NSArray *modelb = @[model2, model3];
    NSArray *modelb = @[model2];
    NSArray *modelc = @[model4, model5];
    NSArray *modeld = @[model6];
    
    NSArray *models = @[modela, modelb, modelc, modeld];
    return models;
}

+ (NSArray *)getCoverImages {
    if (kDevice_Is_iPhoneX) {
        return @[@"cover_x1", @"cover_x2", @"cover_x3", @"cover_x4", @"cover_x5"];
    } else if (kDevice_Is_iPhone6Plus) {
        return @[@"cover_6p1", @"cover_6p2", @"cover_6p3", @"cover_6p4", @"cover_6p5"];
    } else if (kDevice_Is_iPhone6) {
        return @[@"cover_6s1", @"cover_6s2", @"cover_6s3", @"cover_6s4", @"cover_6s5"];
    } else {
        return @[@"cover_5s1", @"cover_5s2", @"cover_5s3", @"cover_5s4", @"cover_5s5"];
    }
}

@end


@implementation UIModel

-(instancetype)init{
    if (self = [super init]) {
        self.TextFieldPlaceholder = @"";
        self.Title = @"";
        self.Icon = @"";
    }
    return self;
}

- (instancetype)initWithTitleStr:(NSString *)title {
    UIModel *model = [[UIModel alloc] initWithTitleStr:title TextFieldPlaceholder:@""];
    return model;
}

-(instancetype)initWithTitleStr:(NSString *)title TextFieldPlaceholder:(NSString *)placeholder{
    
    UIModel *model = [[UIModel alloc]initWithTitleStr:title TextFieldPlaceholder:placeholder Icon:nil];
    return model;
}

-(instancetype)initWithTitleStr:(NSString *)title TextFieldPlaceholder:(NSString *)placeholder Icon:(NSString *)icon{
    
    UIModel *model = [[UIModel alloc]init];
    model.Title = title;
    model.TextFieldPlaceholder = placeholder;
    model.Icon = icon;
    return model;
}


@end


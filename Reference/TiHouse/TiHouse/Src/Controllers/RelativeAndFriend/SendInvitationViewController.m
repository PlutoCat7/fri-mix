//
//  SendInvitationViewController.m
//  TiHouse
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SendInvitationViewController.h"
#import <MessageUI/MessageUI.h>
#import "SGQRCodeTool.h"

#define  kLinker(houseId) JString(@"http://wap.usure.com.cn/wap/outer/house/share.html?houseid=%ld",houseId)


@interface SendInvitationViewController ()<MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *invitationCode;

@property (weak, nonatomic) IBOutlet UIImageView *invitationImageV;

@property (weak, nonatomic) IBOutlet UILabel *tip;

@end

@implementation SendInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.invitationCode.text = self.house.codeinvite;
    CGFloat scale = 0.2;
    
    self.invitationImageV.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:kLinker(self.house.houseid) logoImageName:@"AppIcon" logoScaleToSuperView:scale];

    [self requestRegisterCode];
}

#pragma mark - 刷新房屋邀请码
-(void)requestRegisterCode {
    
    WS(weakSelf);
    [[TiHouse_NetAPIManager sharedManager]request_HouseInfoWithPath:@"api/inter/house/get" Params:@{@"houseid":[NSString stringWithFormat:@"%ld",_house.houseid]} Block:^(id data, NSError *error) {
        if (data) {
            House * house
            = data;
            weakSelf.invitationCode.text = house.codeinvite;
        }
    }];
}

- (IBAction)wChatInvitation:(id)sender {
    
    WEAKSELF
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UIImage * img_url = [UIImage imageNamed:@"w_share_icon"];
    NSString *mainTitle = [NSString stringWithFormat:@"我在【有数啦】记录了“%@“的新变化，快来关注吧！", _house.housename];
    NSString *subTitle = @"关注后就能探秘房屋的所有照片啦～";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:mainTitle descr:subTitle thumImage:_house.urlshare];
    shareObject.webpageUrl = _house.linkshare;
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            [NSObject showStatusBarErrorStr:@"分享失败"];
        }else{
            if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = result;
                //分享结果消息
                [NSObject showStatusBarErrorStr:resp.message];
                
                if (!error) {
                    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(2),@"typeid":@(weakSelf.house.houseid),@"platform":@"1"} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                        
                    }];
                }
                
            }
        }
    }];
    
    //微信好友
    //[self shareWechat:@"有数啦" withDes:JString(@"我在有数啦记录了%@房屋的装修过程，你也来关注一下吧！http://wap.usure.com.cn/static/html/outer/house/share.html?houseid=%ld",self.house.housename,self.house.houseid) withVideo_Url:nil withImg_Url:nil withWXScene:0];
}


-(void)shareWechat:(NSString *)title withDes:(NSString *)des withVideo_Url:(NSString *)videoUrl withImg_Url:(NSString *)imgUrl withWXScene:(int )scene{
    
    WXMediaMessage * message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.message = message;
    req.scene = scene;//0:好友，1:朋友圈
    
    [WXApi sendReq:req];
}

- (IBAction)msgInvitation:(id)sender {
    
    if( [MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.body = JString(@"我在【有数啦】记录了”%@”的新变化，快来关注吧！%@",self.house.housename, self.house.linkshare); //此处的body就是短信将要发生的内容
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"title"];//修改短信界面标题
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }

}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

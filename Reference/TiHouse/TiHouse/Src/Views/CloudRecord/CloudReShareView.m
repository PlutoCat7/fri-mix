//
//  CloudReShareView.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CloudReShareView.h"
#import "Login.h"

@interface CloudReShareView ()
@property (weak, nonatomic) IBOutlet UIImageView *collection_star_Img;

@end

@implementation CloudReShareView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel
{
    CloudReShareView * cloudReShareView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    
   [cloudReShareView setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 200 + kNavigationBarTop)];
    [cloudReShareView xl_bindViewModel];
    
    return cloudReShareView;
}

-(void)xl_bindViewModel {
    
}

-(void)setItemModel:(CloudReCollectItemModel *)itemModel {
    _itemModel = itemModel;
    
    if (itemModel.typecollect == 0) {
        self.collection_star_Img.image = [UIImage imageNamed:@"c_star.png"];
    } else {
        self.collection_star_Img.image = [UIImage imageNamed:@"c_select_star.png"];
    }
}

- (IBAction)shareTapAction:(UITapGestureRecognizer *)sender {
    WEAKSELF
    NSString *platform;
    NSInteger UMSocialPlatformType = 0;
    switch (sender.view.tag) {
        case 1:
            UMSocialPlatformType = UMSocialPlatformType_WechatSession;
            platform = @"1";
            break;
            
        case 2:
            UMSocialPlatformType = UMSocialPlatformType_WechatTimeLine;
            platform = @"2";
            break;
            
        case 3:
            UMSocialPlatformType = UMSocialPlatformType_QQ;
            platform = @"3";
            break;
            
        case 4:
            UMSocialPlatformType = UMSocialPlatformType_Sina;
            platform = @"4";
            break;
            
        default:
            break;
            
    }
    
    //创建分享消息对象
    UMShareWebpageObject *WebpageObject = [UMShareWebpageObject shareObjectWithTitle:@"有数啦" descr:[_itemModel.dairydesc stringByRemovingPercentEncoding] thumImage:[UIImage imageNamed:@"w_share_icon"]];
    //设置文本
    WebpageObject.webpageUrl = _itemModel.linkshare;
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObjectWithMediaObject:WebpageObject];
    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType) messageObject:messageObject currentViewController:[HouseInfoViewController new] completion:^(id result, NSError *error) {
//
//    }];
    
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    NSString * img_url = self.itemModel.urlfile;
////    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:nil descr:@"有数啦" thumImage:img_url];
//    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"有数啦" descr:nil thumImage:[NSURL URLWithString:img_url]];
//    shareObject.shareImage = [NSURL URLWithString:img_url];
//    //shareObject.webpageUrl = @"http://mobile.umeng.com/social";
//    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType) messageObject:messageObject currentViewController:self.viewVC completion:^(id result, NSError *error) {
        if (error) {
            [NSObject showStatusBarErrorStr:@"分享失败"];
        }else{
            if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = result;
                //分享结果消息
                [NSObject showHudTipStr:resp.message];
//                [NSObject showStatusBarErrorStr:resp.message];
                
                if (!error) {
                    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(1),@"typeid":@(weakSelf.itemModel.dairyid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                        
                    }];
                }
            }
        }
    }];
    
    /*
    UMSocialPlatformType type = -2;
    if (sender.view.tag == 1) {
        //微信好友
        [self shareWechat:@"有数啦" withDes:self.itemModel.dairydesc withVideo_Url:self.videoUrl withImg_Url:self.itemModel.urlfile withWXScene:0];
    } else if (sender.view.tag == 2) {
        //微信朋友圈
        [self shareWechat:@"有数啦" withDes:self.itemModel.dairydesc withVideo_Url:self.videoUrl withImg_Url:self.itemModel.urlfile withWXScene:1];
    } else {
        if (sender.view.tag == 3) {
            //qq好友
            type = UMSocialPlatformType_QQ;
        } else {
            //新浪
            type = UMSocialPlatformType_Sina;
        }
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        NSString * img_url = self.itemModel.urlfile;
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:nil descr:@"有数啦" thumImage:img_url];
        shareObject.webpageUrl = @"http://mobile.umeng.com/social";
        messageObject.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self.viewVC completion:^(id data, NSError *error) {
            if (error) {
                [NSObject showHudErrorTipStr:@"分享失败"];
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    
                    //分享结果消息
                    [NSObject showHudErrorTipStr:resp.message];
                }
            }
        }];
    }
     */
}

-(void)shareWechat:(NSString *)title withDes:(NSString *)des withVideo_Url:(NSString *)videoUrl withImg_Url:(NSString *)imgUrl withWXScene:(int )scene{
    
    WXMediaMessage * message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    
    id mediaObject = nil;
    BOOL bText = YES;
    if (videoUrl) {
        WXVideoObject * videoObject = [WXVideoObject object];
        videoObject.videoUrl = videoUrl;
        mediaObject = videoObject;
        bText = NO;
    }
    message.mediaObject = mediaObject;
    
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.message = message;
    req.scene = scene;//0:好友，1:朋友圈
    
    [WXApi sendReq:req];
}

- (IBAction)otherTapAction:(UITapGestureRecognizer *)sender {
//    WEAKSELF;
    if (sender.view.tag == 1) {
        //收藏
        User *user = [Login curLoginUser];
        [[TiHouse_NetAPIManager sharedManager] request_cloudRecordCollectFileWithParams:@{@"fileid":@(self.fileid)} Block:^(id data, NSError *error) {
            
            if (data) {
                if (_itemModel.typecollect == 0) {
                    self.itemModel.typecollect = 1;
                    self.collection_star_Img.image = [UIImage imageNamed:@"c_select_star.png"];
                } else {
                    self.itemModel.typecollect = 0;
                    self.collection_star_Img.image = [UIImage imageNamed:@"c_star.png"];
                }
                [NSObject showStatusBarSuccessStr:data];
            }
        }];
    } else if (sender.view.tag == 2) {
        //下载
        
        if (self.videoUrl) {
            //保存视频
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoUrl)) {
                //保存相册核心代码
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoUrl, self, @selector(saveVideo:didFinishSavingWithError:contextInfo:), nil);
            }
        } else {
            //保存图片
            UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), NULL);
        }
        
    } else {
        //删除
        [[TiHouse_NetAPIManager sharedManager] request_cloudRecordDelFileWithParams:@{@"fileid":@(self.fileid)} Block:^(id data, NSError *error) {
            
            if (data) {
                [NSObject showStatusBarSuccessStr:data];
                
                if (_DelBlock) {
                    _DelBlock();
                }
            }
        }];
    }
}

//保存图片完成后调用的方法
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [NSObject showStatusBarErrorStr:@"保存图片出错"];
    }
    else {
        [NSObject showStatusBarErrorStr:@"保存图片成功"];
    }
}

//保存视频完成之后的回调
- (void)saveVideo:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [NSObject showStatusBarErrorStr:@"保存视频出错"];
    }
    else {
        [NSObject showStatusBarErrorStr:@"保存视频成功"];
    }
}

-(void)showSelectColorView {
    [UIView animateWithDuration:0.4 animations:^{
        [self setOrigin:CGPointMake(0, kScreen_Height - 200 - kNavigationBarTop)];
    }];
}

-(void)dismissSelectColorView {
    [UIView animateWithDuration:0.4 animations:^{
        [self setOrigin:CGPointMake(0, kScreen_Height)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

//
//  SingleArticleViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SingleArticleViewController.h"
#import "BaseNavigationController.h"
#import "CommentViewController.h"
#import "CommentListViewController.h"
#import "GBSharePan.h"
#import "UIViewController+YHToast.h"

#import "KnowledgeRequest.h"
#import "KnowledgeUtil.h"
#import "Enums.h"
#import "NotificationConstants.h"

@interface SingleArticleViewController () <UIWebViewDelegate, GBSharePanDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *commentBgView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *faverCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favorImageView;

@property (strong, nonatomic) KnowModeInfo *knowModeInfo;

//分享页面
@property (strong, nonatomic)  GBSharePan *sharePan;

@end

@implementation SingleArticleViewController

- (instancetype)initWithKnowModeInfo:(KnowModeInfo *)knowModeInfo {
    
    if (self = [super init]) {
        _knowModeInfo = knowModeInfo;
        if (@available(iOS 11.0, *)) {
            self.automaticallyAdjustsScrollViewInsets = YES;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self wr_setNavBarBarTintColor:[UIColor colorWithHexString:@"0xFCFCFC"]];
    
    [self loadNetworkData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark - Action

- (IBAction)actionComment:(id)sender {
    CommentViewController *vc = [[CommentViewController alloc] initWithCommentId:_knowModeInfo.knowid commId:0 commuid:0 comuname:nil type:CommentType_Know];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)actionCommentList:(id)sender {
    CommentListViewController *viewController = [[CommentListViewController alloc] initWithKnowId:_knowModeInfo.knowid];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)actionFavor:(id)sender {
    
    [self showLoadingToast];
    if (_knowModeInfo.knowiscoll) {
        WEAKSELF
        [KnowledgeRequest removeKnowledgeFavor:_knowModeInfo.knowid handler:^(id result, NSError *error) {
            [weakSelf dismissToast];
            if (!error) {
                GBResponseInfo *info = result;
                [NSObject showHudTipStr:weakSelf.view tipStr:info.msg];
                
                weakSelf.knowModeInfo.knowiscoll = NO;
                weakSelf.knowModeInfo.knownumcoll -= 1;
                
                weakSelf.faverCountLabel.text = [NSString stringWithFormat:@"%td", weakSelf.knowModeInfo.knownumcoll];
                weakSelf.favorImageView.image = weakSelf.knowModeInfo.knowiscoll ? [UIImage imageNamed:@"klistfavor"] : [UIImage imageNamed:@"klistunfavor"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UnFavor_KnowSucc object:weakSelf.knowModeInfo];
            }
        }];
        
    } else {
        WEAKSELF
        [KnowledgeRequest addKnowledgeFavor:_knowModeInfo.knowid handler:^(id result, NSError *error) {
            [weakSelf dismissToast];
            if (!error) {
                GBResponseInfo *info = result;
                [NSObject showHudTipStr:weakSelf.view tipStr:info.msg];
                
                weakSelf.knowModeInfo.knowiscoll = YES;
                weakSelf.knowModeInfo.knownumcoll += 1;
                
                weakSelf.faverCountLabel.text = [NSString stringWithFormat:@"%td", weakSelf.knowModeInfo.knownumcoll];
                weakSelf.favorImageView.image = weakSelf.knowModeInfo.knowiscoll ? [UIImage imageNamed:@"klistfavor"] : [UIImage imageNamed:@"klistunfavor"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Favor_KnowSucc object:weakSelf.knowModeInfo];
            }
        }];
    }
}

- (IBAction)actionShare:(id)sender {
     [self.sharePan showSharePanWithDelegate:self showSingle:YES];
}

#pragma mark - private

- (void)loadData {
    self.commentCountLabel.text = [NSString stringWithFormat:@"%td",_knowModeInfo.knownumcomm];
    self.faverCountLabel.text = [NSString stringWithFormat:@"%td",_knowModeInfo.knownumcoll];
    if (_knowModeInfo.knownumcomm == 0) {
        self.commentCountLabel.hidden = YES;
    } else {
        self.commentCountLabel.hidden = NO;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(_knowModeInfo.knowctime/1000)]];
    
    NSString *header = @"<h1 class=\"title\" style=\"font-size:21px; color:#000;\">%@</h1><p style=\"font-size:15px; color:#888888; margin-bottom:10px;\" >%@</p>";
    NSString *title = [NSString stringWithFormat:header, _knowModeInfo.knowtitle, [NSString stringWithFormat:@"%@  %@", time, _knowModeInfo.knowcreatername]];
//    NSString *content = [NSString stringWithFormat:@"<div style=\"width:90%%; margin:5%%; padding:0; float:left; font-size:14px; color:#3a3a3a;\">%@%@</div>", title, _knowModeInfo.knowcontent];
    NSString *content = [NSString stringWithFormat:@"<div style=\"font-size:14px; color:#3a3a3a;\">%@%@</div>", title, _knowModeInfo.knowcontent];
    
    self.favorImageView.image = _knowModeInfo.knowiscoll ? [UIImage imageNamed:@"klistfavor"] : [UIImage imageNamed:@"klistunfavor"];
    
    self.webView.delegate = self;
    [self.webView loadHTMLString:content baseURL:nil];
}

- (void)setupUI {
    self.title = [KnowledgeUtil nameWithKnowType:_knowModeInfo.knowtype];
    
    [self.commentBgView.layer setMasksToBounds:YES];
    [self.commentBgView.layer setCornerRadius:3.f];
    
    [self.commentCountLabel.layer setMasksToBounds:YES];
    [self.commentCountLabel.layer setCornerRadius:6.f];
    
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
}

- (void)loadNetworkData {
    WEAKSELF
    [KnowledgeRequest getKnowledgeDetail:_knowModeInfo.knowid handler:^(id result, NSError *error) {
        if (!error) {
            KnowModeInfo *newModeInfo = result;
            weakSelf.knowModeInfo.knownumcomm = newModeInfo.knownumcomm;
            weakSelf.knowModeInfo.knownumcoll = newModeInfo.knownumcoll;
            weakSelf.knowModeInfo.knowiscoll = newModeInfo.knowiscoll;
            
            [weakSelf updateUi];
        }
    }];
}

- (void)updateUi {
    self.commentCountLabel.text = [NSString stringWithFormat:@"%td",_knowModeInfo.knownumcomm];
    self.faverCountLabel.text = [NSString stringWithFormat:@"%td",_knowModeInfo.knownumcoll];
    if (_knowModeInfo.knownumcomm == 0) {
        self.commentCountLabel.hidden = YES;
    } else {
        self.commentCountLabel.hidden = NO;
    }
    
    self.favorImageView.image = _knowModeInfo.knowiscoll ? [UIImage imageNamed:@"klistfavor"] : [UIImage imageNamed:@"klistunfavor"];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSString *js = @"function imgAutoFit() { \
//    var imgs = document.getElementsByTagName('img'); \
//    for (var i = 0; i < imgs.length; ++i) {\
//    var img = imgs[i];   \
//    img.style.maxWidth = %f;   \
//    } \
//    }";
//    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
//    
//    [webView stringByEvaluatingJavaScriptFromString:js];
//    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
}


#pragma mark - 分享功能

- (GBSharePan*)sharePan
{
    if (!_sharePan)
    {
        _sharePan = [[GBSharePan alloc] init];
        _sharePan.delegate = self;
    }
    return _sharePan;
}
// share delegate

- (void)GBSharePanAction:(GBSharePan*)pan tag:(SHARE_TYPE)tag
{
    [self clickShare:tag];
}

- (void)GBSharePanActionCancel:(GBSharePan *)pan {
}

- (void)clickShare:(SHARE_TYPE)tag {
    
    NSString *platform;
    switch (tag)
    {
        case SHARE_TYPE_WECHAT:
        {
            platform = @"1";
        }
            break;
        case SHARE_TYPE_QQ:
        {
            platform = @"2";
        }
            break;
        case SHARE_TYPE_WEIBO:
        {
            platform = @"3";
        }
            break;
        default:
        {
            platform = @"4";
        }
            break;
    }
    
    @weakify(self)
    NSString *postTitle = [NSString stringWithFormat:@"%@%@", _knowModeInfo.knowtitle, _knowModeInfo.linkshare];
    NSString *title = tag == SHARE_TYPE_WEIBO ? postTitle : _knowModeInfo.knowtitle;
    NSString *content = _knowModeInfo.knowtype == KnowType_Poster ? _knowModeInfo.knowtitlesub : @"【有数啦】家居风水全揭秘！";
    id image = _knowModeInfo.knowtype == KnowType_Poster ? _knowModeInfo.urlshare : nil;
    [[[UMShareManager alloc]init] webShare:tag title:title content:content url:_knowModeInfo.linkshare image:image complete:^(NSInteger state)
     {
         @strongify(self)
         switch (state) {
             case 0: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享成功"];
                 [self.sharePan hide:^(BOOL ok){}];
                 NSInteger type = self.knowModeInfo.knowtype == KnowType_Poster ? 5 : 6;
                 [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(type),@"typeid":@(self.knowModeInfo.knowid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                     
                 }];
             }break;
                 
             case 1: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享失败"];
                 [self.sharePan hide:^(BOOL ok){}];
             }break;
             default:
                 break;
         }
     }];
}

@end

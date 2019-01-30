//
//  FindArticleDetailViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindArticleDetailViewController.h"
#import "ArticlePreHeadherView.h"
#import "ArticleMoreViewController.h"
#import "UIViewController+YHToast.h"
#import "FindCommentView.h"
#import "CommentViewController.h"
#import "CommentListViewController.h"
#import "BaseNavigationController.h"
#import "ArticleLikeView.h"

#import "FindArticleDetailStore.h"
#import "FindAssemarcInfo.h"
#import "FindPostTool.h"
#import "FindCommentPageRequest.h"
#import "CommentPageRequest.h"
#import "NotificationConstants.h"
#import "AssemarcRequest.h"
#import "GBSharePan.h"

@interface FindArticleDetailViewController ()<
UIWebViewDelegate,
GBSharePanDelegate,
ArticleLikeViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *commentBgView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *faverCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favorImageView;


@property (nonatomic, strong) ArticlePreHeadherView *headerView;
@property (nonatomic, strong) ArticleMoreViewController *moreVC;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL isWebFinish;
@property (nonatomic, strong) ArticleLikeView *likeView;  //点赞

@property (nonatomic, strong) FindArticleDetailStore *store;

@property (nonatomic, strong) FindCommentView *commentView;
@property (nonatomic, strong) FindCommentPageRequest *recordPageRequest;
@property (nonatomic, strong) NSArray <FindAssemarcCommentInfo *> *commentArray;

//分享页面
@property (strong, nonatomic)  GBSharePan *sharePan;

@end

@implementation FindArticleDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithAssemarcInfo:(FindAssemarcInfo *)arcInfo {
    
    self = [super init];
    if (self) {
        _store = [[FindArticleDetailStore alloc] initWithAssemarcInfo:arcInfo];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentSuccess) name:Notification_Comment_Success object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentSuccess) name:Notification_Comment_Zan object:nil];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
//    self.headerView.frame = CGRectMake(0, 0, kScreen_Width, kArticlePreHeadherViewHeight);
}

#pragma mark - Notification

- (void)commentSuccess {
    
    [self loadNetworkData];
    
    _store.arcInfo.assemarcnumcoll += 1;
    [self refreshBottomViewUI];
}

#pragma mark - Action

- (IBAction)actionComment:(id)sender {
    CommentViewController *vc = [[CommentViewController alloc] initWithCommentId:_store.arcInfo.assemarcid commId:0 commuid:0 comuname:nil type:CommentType_Asse];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)actionCommentList:(id)sender {
    CommentListViewController *viewController = [[CommentListViewController alloc] initWithAssenarcId:_store.arcInfo.assemarcid];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)actionFavor:(id)sender {
    
    //[self showLoadingToast];
    [_store favorArticleWithHandler:^(BOOL isSuccess) {
        //[self dismissToast];
        if (isSuccess) {
            if (_store.arcInfo.assemarciscoll) {
                [NSObject showHudTipStr:self.view tipStr:@"收藏成功"];
            } else {
                [NSObject showHudTipStr:self.view tipStr:@"取消收藏成功"];
            }
            [self refreshBottomViewUI];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_Collection object:self.store.arcInfo];
        }
    }];
}

- (IBAction)actionShare:(id)sender {
    [self.sharePan showSharePanWithDelegate:self showSingle:YES];
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
        case SHARE_TYPE_CIRCLE:
        {
            platform = @"2";
        }
            break;
        case SHARE_TYPE_QQ:
        {
            platform = @"3";
        }
            break;
        case SHARE_TYPE_WEIBO:
        {
            platform = @"4";
        }
            break;
        default:
        {
            platform = @"4";
        }
            break;
    }
    
    @weakify(self)
    NSString *title = _store.arcInfo.assemarctitle;
    NSString *content = @"【有数啦】你值得拥有的家装神器！";
    if (tag == SHARE_TYPE_WEIBO) {
        title = [NSString stringWithFormat:@"%@%@", title, _store.arcInfo.linkshare];
    }
    NSString *image = _store.arcInfo.urlshare;
    [[[UMShareManager alloc]init] webShare:tag title:title content:content
                                       url:_store.arcInfo.linkshare image:image complete:^(NSInteger state)
     {
         @strongify(self)
         switch (state) {
             case 0: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享成功"];
                 [self.sharePan hide:^(BOOL ok){}];
                 [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(8),@"typeid":@(self.store.arcInfo.assemarcid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
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

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"文章详情";
    
    [self.commentBgView.layer setMasksToBounds:YES];
    [self.commentBgView.layer setCornerRadius:3.f];
    
    [self.commentCountLabel.layer setMasksToBounds:YES];
    [self.commentCountLabel.layer setCornerRadius:6.f];
    
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.webView];
    [self.scrollView addSubview:self.likeView];
    [self.scrollView addSubview:self.moreVC.view];
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self refreshBottomViewUI];
}

- (void)loadNetworkData {
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        if (!error) {
            self.commentArray = self.recordPageRequest.responseInfo.items;
            if (self.commentArray.count >0 ) {
                [self.commentView refreshWithComments:self.commentArray];
                
                if (self.isWebFinish) {
                    [self updateLayout];
                }
            }
        }
    }];
}

- (void)updateLayout {
    
    self.likeView.top = self.webView.bottom;
    if (self.commentArray.count > 0) {
        self.commentView.top = self.likeView.bottom;
        CGRect commentFrame = self.commentView.frame;
        commentFrame.size.height = [self.commentView getFindCommentHeight];
        self.commentView.frame = commentFrame;
        
        self.moreVC.view.top = self.likeView.bottom + commentFrame.size.height;
        
        CGFloat padding = 10;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.moreVC.view.bottom + padding);
        
    } else {
        self.moreVC.view.top = self.likeView.bottom;
        
        CGFloat padding = 10;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.moreVC.view.bottom + padding);
    }
    
    
}

- (void)refreshBottomViewUI {
    
    self.commentCountLabel.text = [NSString stringWithFormat:@"%td",_store.arcInfo.assemarcnumcomm];
    if (_store.arcInfo.assemarcnumcomm == 0) {
        self.commentCountLabel.hidden = YES;
    } else {
        self.commentCountLabel.hidden = NO;
    }
    self.faverCountLabel.text = [NSString stringWithFormat:@"%td",_store.arcInfo.assemarcnumcoll];
    self.favorImageView.image = self.store.arcInfo.assemarciscoll ? [UIImage imageNamed:@"klistfavor"] : [UIImage imageNamed:@"klistunfavor"];
}

#pragma mark - Getters & Setters

- (ArticlePreHeadherView *)headerView {
    
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"ArticlePreHeadherView" owner:self options:nil].firstObject;
        NSInteger headHeight = [ArticlePreHeadherView defaultHeight:self.store.arcInfo.assemarctitle];
        _headerView.frame = CGRectMake(0, 0, kScreen_Width, headHeight);
        _headerView.autoresizingMask = UIViewAutoresizingNone;
        [_headerView refreshWithAssemarcInfo:self.store.arcInfo];
    }
    return _headerView;
}

- (UIWebView *)webView {
    
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(kRKBWIDTH(18),  self.headerView.bottom, kScreen_Width-2*kRKBWIDTH(18), 40)];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        
        [self.webView loadHTMLString:_store.arcInfo.assemarccontent baseURL:nil];
    }
    
    return _webView;
}

- (ArticleLikeView *)likeView {
    
    if (!_likeView) {
        _likeView = [[NSBundle mainBundle] loadNibNamed:@"ArticleLikeView" owner:self options:nil].firstObject;
        _likeView.delegate = self;
        _likeView.frame = CGRectMake(0, self.webView.bottom, kScreen_Width, kArticleLikeViewHeight);
        _likeView.autoresizingMask = UIViewAutoresizingNone;
        [_likeView refreshWithInfo:_store.arcInfo];
    }
    return _likeView;
}

- (ArticleMoreViewController *)moreVC {
    
    if (!_moreVC) {
        _moreVC = [[ArticleMoreViewController alloc] initWithArcTitle:_store.arcInfo.assemarctitle assemarcid:[NSString stringWithFormat:@"%ld",self.store.arcInfo.assemarcid]];
        _moreVC.view.frame = CGRectMake(0, self.likeView.bottom, kScreen_Width, kArticleMoreViewControllerViewHeigth);
        _moreVC.view.autoresizingMask = UIViewAutoresizingNone;
        [self addChildViewController:_moreVC];
    }
    return _moreVC;
}

- (FindCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[NSBundle mainBundle] loadNibNamed:@"FindCommentView" owner:nil options:nil].firstObject;
        WEAKSELF
        _commentView.clickCommentBlock = ^{
            CommentListViewController *viewController = [[CommentListViewController alloc] initWithAssenarcId:weakSelf.store.arcInfo.assemarcid];
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        };

        _commentView.frame = CGRectMake(0, self.likeView.bottom, kScreen_Width, 160);

        [self.scrollView addSubview:_commentView];
    }
    
    return _commentView;
}

- (FindCommentPageRequest *)recordPageRequest {
    if (!_recordPageRequest) {
        _recordPageRequest = [[FindCommentPageRequest alloc] init];
        _recordPageRequest.assemId = _store.arcInfo.assemarcid;
        _recordPageRequest.rankType = CommentRankType_D;
    }
    return _recordPageRequest;
}
#pragma mark - Delegate
#pragma mark ArticleLikeViewDelegate

- (void)articleLikeViewActionLike:(ArticleLikeView *)view {
    
    [self showLoadingToast];
    [_store likeArticleWithHandler:^(BOOL isSuccess) {
        [self dismissToast];
        if (isSuccess) {
            [self.likeView refreshWithInfo:_store.arcInfo];
             [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_Like object:self.store.arcInfo];
        }
    }];
}

#pragma mark UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.isWebFinish = YES;
    
    [self dismissToast];
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        //ps:js可以是上面所写，也可以是document.body.scrollHeight;个人觉得两者在UIWebView中都可以，但是在WKWebView中就不同了，后面会有介绍
        CGRect webFrame = CGRectMake(webView.left,  self.headerView.bottom, webView.width, height+50);
        webView.frame = webFrame;
        
        [self updateLayout];
        
    });
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self showLoadingToast];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self dismissToast];
}

@end

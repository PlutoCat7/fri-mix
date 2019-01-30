//
//  GBBaseShareViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseShareViewController.h"
#import "GBSharePan.h"

@interface GBBaseShareViewController ()<GBSharePanDelegate>

// 分享功能
@property (strong, nonatomic) GBSharePan *sharePan;
@property (strong, nonatomic) UIButton *backButton;

//分享时的navigation bar  image
@property (strong, nonatomic)  UIImage      *navigationBarImage;
@property (nonatomic, strong)  UIImage      *imageCapeture;

@end

@implementation GBBaseShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    
    [super setupUI];
    self.backButton = [self setupBackButtonWithBlock:nil];
    [self resetShareItem];
}

#pragma mark - Public

- (void)resetShareItem {
    
    if ([self showShareItem]) {
        [self showNavItems];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - Action

- (void)hideNavItems {
    
    self.backButton.hidden = YES;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)showNavItems {
    
    self.backButton.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(shareItemAction)];
}

- (void)shareItemAction {
    
    [self hideNavItems];
    [self getPreImage];
    [self.sharePan showSharePanWithDelegate:self];
}

#pragma mark - Private

- (void)getPreImage {
    
    UIGraphicsBeginImageContextWithOptions([self preScreenShotRect].size, NO, 0);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.navigationBarImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageCapeture = [UIImage imageWithCapeture];
}

//默认截屏
- (UIImage *)t_goalShareImage {
    
    UIImage *shareImage = [self shareImage];
    if (shareImage) {
        if ([self shareWithNavigationBarImage]) { //添加navigationbar
            shareImage = [LogicManager getImageWithHeadImage:@[self.navigationBarImage, shareImage] subviews:nil backgroundImage:nil];
        }
        
    }else {
        shareImage = self.imageCapeture;
    }
    return shareImage;
}

#pragma mark - Setter and Getter

- (GBSharePan*)sharePan
{
    if (!_sharePan)
    {
        _sharePan = [[GBSharePan alloc] init];
        _sharePan.delegate = self;
    }
    return _sharePan;
}

#pragma mark - GBSharePanDelegate

- (void)GBSharePanAction:(GBSharePan*)pan tag:(SHARE_TYPE)tag
{
    
    [[[UMShareManager alloc]init] screenShare:tag image:[self t_goalShareImage] complete:^(NSInteger state)
     {
         switch (state)
         {
             case 0:
             {
                 [self showToastWithText:LS(@"share.toast.success")];
                 [self showNavItems];
                 [self shareSuccess];
                 [pan hide:^(BOOL ok){}];
             }break;
             case 1:
             {
                 [self showToastWithText:LS(@"share.toast.fail")];
                 [self showNavItems];
                 [self shareFail];
                 [pan hide:^(BOOL ok){}];
             }break;
             default:
                 break;
         }
     }];
}

- (void)GBSharePanActionCancel:(GBSharePan *)pan
{
    [self showNavItems];
}

- (void)GBSharePanActionWillShow:(GBSharePan*)pan {
    
    [self shareViewWillShow];
}

- (void)GBSharePanActionWillHide:(GBSharePan*)pan {

    [self shareViewWillHide];
}

#pragma mark GBBaseShareViewControllerDelegate and GBBaseShareViewControllerDataSource

- (CGRect)preScreenShotRect {
    
    return CGRectMake(0, 0, kUIScreen_Width, kUIScreen_NavigationBarHeight);
}


- (UIImage *)shareImage {
    
    return nil;
}

- (BOOL)shareWithNavigationBarImage {
    
    return YES;
}

- (BOOL)showShareItem {
    
    return YES;
}

- (void)shareViewWillShow {
}

- (void)shareViewWillHide {
}

- (void)shareSuccess {
    
}

- (void)shareFail {
    
}

@end

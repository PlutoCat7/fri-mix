//
//  LoadingViewController.m
//  Pet
//
//  Created by yahua on 16/4/20.
//  Copyright © 2016年 NDrd. All rights reserved.
//

#import "GBLoadingViewController.h"
#import "UIImageView+WebCache.h"
#import "GBView.h"

#import "SystemRequest.h"
#import "APNSManager.h"

//广告展示时长
static const NSInteger kSplashShowTime = 3;

@interface GBLoadingViewController ()

@property (nonatomic, strong) UIImageView *imageView;

/**
 广告显示界面
 */
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

/**
 广告点击按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *adButton;

@property (weak, nonatomic) IBOutlet GBView *skipView;
@property (weak, nonatomic) IBOutlet UILabel *skipTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skipViewTopLayoutConstraint;

/**
 广告现实倒计时
 */
@property (nonatomic, strong) NSTimer *countDownTimer;

/**
 闪屏广告信息
 */
@property (nonatomic, strong) SplashInfo *splashInfo;

@end

@implementation GBLoadingViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.imageView.frame = self.view.bounds;
    self.skipViewTopLayoutConstraint.constant =  IS_IPHONE_X?48:24;
}

#pragma mark - Action

/**
 点击跳过事件

 */
- (IBAction)skipEvent:(id)sender {
    
    [self.countDownTimer invalidate];
    [self pushNextViewController];
}

/**
 广告被点击了

 */
- (IBAction)adEvent:(id)sender {
    
    [self.countDownTimer invalidate];
    [self pushNextViewController];
    //弹出广告页
    [[APNSManager shareInstance] pushSplash:self.splashInfo];
}

#pragma mark - Private

- (void)setupUI {
    
    self.navigationController.navigationBar.hidden = YES;
    [self.view insertSubview:self.imageView atIndex:0];
    [self.staticLabel setText:LS(@"launch.button.jump")];
}

- (void)loadData {
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSArray *launchArray = [infoPlist valueForKey:@"UILaunchImages"];
    for (NSDictionary *launchDic in launchArray) {
        NSString *icon = [launchDic valueForKey:@"UILaunchImageName"];
        UIImage *image = [UIImage imageNamed:icon];
        if (image.size.height == [[UIScreen mainScreen] bounds].size.height) {
            self.imageView.image = image;
        }
    }
    
    @weakify(self)
    //接口请求超时时间2s
    NSTimer *timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f block:^(NSTimer *timer) {
        
        [timer invalidate];
        @strongify(self)
        [self pushNextViewController];
    } repeats:NO];
    //请求广告数据
    [SystemRequest getSplashInfoWithHandler:^(id result, NSError *error) {
        
        [timeOutTimer invalidate];
        
        @strongify(self)
        if (!self) {  //控制器已经被销毁
            return;
        }
        if (error) {
            [self pushNextViewController];
        }else {
            //下载广告图片
            //超时时间2s
            NSTimer *timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f block:^(NSTimer *timer) {
                
                [timer invalidate];
                @strongify(self)
                [self pushNextViewController];
            } repeats:NO];
            
            self.splashInfo = result;
            [self.adImageView sd_setImageWithURL:[NSURL URLWithString:self.splashInfo.image_url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [timeOutTimer invalidate];
                
                @strongify(self)
                if (error) {
                    [self pushNextViewController];
                    return;
                }
                
                self.skipView.hidden = NO;
                self.adButton.hidden = self.splashInfo.type==PushType_None?YES:NO;
                
                __block NSInteger countDown = kSplashShowTime;
                self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
                    
                    countDown--;
                    if (countDown == 0) {
                        [timer invalidate];
                        [self pushNextViewController];
                    }
                    self.skipTipsLabel.text = @(countDown).stringValue;;
                } repeats:YES];
                self.skipTipsLabel.text = @(countDown).stringValue;;
            }];
        }
    }];
}

/**
 弹出下一个控制器
 */
- (void)pushNextViewController {
    
    if ([RawCacheManager sharedRawCacheManager].isLastLogined && [RawCacheManager sharedRawCacheManager].userInfo) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShowMainView object:nil];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedLogin object:nil];
    }
}

#pragma mark - Getters and Setters

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end

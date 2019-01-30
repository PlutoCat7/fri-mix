//
//  ShareViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ShareViewController.h"
#import <POP.h>
#import "UIView+Common.h"
#import "Login.h"

#define kShareMargin (kScreen_Width - 320) / 5.0

@implementation ShareButton

- (instancetype)init {
    if (self = [super init]) {
        self.titleLabel.font = ZISIZE(10);
        [self setTitleColor:kColorNavTitle forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    
    frame = CGRectMake(0, 60, self.frame.size.width, 20);
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame = CGRectMake(15, 0, 50, 50);

    return frame;
}

@end

@interface ShareViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *shareContainer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) NSArray *iconsArray;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
    
    [self shareContainer];
    [self titleLabel];
    [self cancelButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - target action
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters && setters

- (UIView *)shareContainer {
    if (!_shareContainer) {
        _shareContainer = [[UIView alloc] init];
        [self.view addSubview:_shareContainer];
        [_shareContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@200);
        }];
        _shareContainer.backgroundColor = [UIColor whiteColor];
        for (NSInteger i = 0; i < 4; i++) {
            ShareButton *button = [[ShareButton alloc] init];
            [_shareContainer addSubview:button];
            [button setTitle:self.itemsArray[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:self.iconsArray[i]] forState:UIControlStateNormal];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(kShareMargin + (kShareMargin + 80) * i));
                make.top.equalTo(@45);
                make.size.equalTo(@80);
            }];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 20000 + (i + 1);
        }
    }
    return _shareContainer;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"分享到";
        _titleLabel.font = ZISIZE(12);
        _titleLabel.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        [_shareContainer addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@15);
        }];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareContainer addSubview:_cancelButton];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_shareContainer);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.height.equalTo(@50);
        }];
        [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kColorNavTitle forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = ZISIZE(12);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - 20, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"bfbfbf"];
        [_cancelButton addSubview: line];
    }
    return _cancelButton;
}

- (NSArray *)itemsArray {
    return @[@"微信好友", @"微信朋友圈", @"QQ好友", @"新浪微博"];
}

- (NSArray *)iconsArray {
    return @[@"mine_wechat", @"mine_moment", @"mine_qq", @"mine_weibo"];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_shareContainer]) {
        return NO;
    }
    return YES;
}

- (void)buttonClick:(UIButton *)sender {
//    WEAKSELF
    NSString *platform;
    NSInteger UMSocialPlatformType = 0;
    
    switch (sender.tag - 20000) {
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
    UMShareWebpageObject *WebpageObject = [UMShareWebpageObject shareObjectWithTitle:@"推荐有数啦这个超好的应用" descr:@"让家装心中有数" thumImage:[UIImage imageNamed:@"w_share_icon"]];
    //设置文本
    WebpageObject.webpageUrl = [NSString stringWithFormat:@"http://wap.usure.com.cn/static/html/outer/app/share.html"];
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObjectWithMediaObject:WebpageObject];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType) messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        
        if (!error) {
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@9,@"platform":platform, @"uid": @([Login curLoginUserID])} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {

            }];
        }
        
    }];
    
}


@end

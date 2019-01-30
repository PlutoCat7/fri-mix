//
//  MineFeedBackController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineFeedBackController.h"
#import "FeedBackTextView.h"
#import "UIView+Common.h"
#import "HXPhotoPicker.h"
#import "Login.h"

@interface MineFeedBackController ()<UITextViewDelegate,HXPhotoViewDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) FeedBackTextView *textView;
@property (nonatomic, strong) UIView *uploadImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sendButton;

@property (strong, nonatomic) HXPhotoManager *manager;
@property (nonatomic, strong) HXPhotoView *photoView;
@property (nonatomic, strong) NSMutableArray *imageURLsArray;

@end

@implementation MineFeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    [self textView];
//    [self uploadImageView];
    [self label];
    [self textField];
    [self sendButton];
//    [self photoView];
    _imageURLsArray = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (FeedBackTextView *)textView {
    if (!_textView) {
        _textView = [[FeedBackTextView alloc] init];
        _textView.textView.delegate = self;
        [self.view addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(kNavigationBarHeight);
            make.height.equalTo(@150);
        }];
        [_textView addSubview:[UIView lineViewWithPointYY:0]];
        [_textView addSubview:[UIView lineViewWithPointYY:149.5]];
    }
    return _textView;
}

- (UIView *)uploadImageView {
    if (!_uploadImageView) {
        _uploadImageView = [[UIView alloc] init];
        [self.view addSubview:_uploadImageView];
        [_uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@145);
            make.top.equalTo(_textView.mas_bottom).offset(10);
        }];
        _uploadImageView.backgroundColor = [UIColor whiteColor];
        [_uploadImageView addSubview:[UIView lineViewWithPointYY:0]];
        [_uploadImageView addSubview:[UIView lineViewWithPointYY:144.5]];
        
        UILabel *textLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"上传图片(选填，最多三张)"];
        [attr addAttribute:NSForegroundColorAttributeName value:kLOGINBTNCOLOR range:NSMakeRange(0, 4)];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"bfbfbf"] range:NSMakeRange(4, 9)];
        textLabel.attributedText = attr;
        [_uploadImageView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@17);
            make.top.equalTo(@20);
        }];
    }
    return _uploadImageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        [self.view addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@17);
            make.top.equalTo(_textView.mas_bottom).offset(20);
        }];
        _label.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        _label.font = ZISIZE(12);
        _label.text = @"可留下您的联系方式，方便给您反馈";
    }
    return _label;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(_label.mas_bottom).offset(10);
            make.height.equalTo(@(50));
        }];
        _textField.font = ZISIZE(14);
        _textField.placeholder = @"QQ/微信/邮箱/手机";
        [_textField addSubview:[UIView lineViewWithPointYY:0]];
        [_textField addSubview:[UIView lineViewWithPointYY:49.5]];

    }
    return _textField;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        _sendButton.backgroundColor = kTiMainBgColor;
        _sendButton.layer.cornerRadius = kRKBHEIGHT(25);
        _sendButton.layer.masksToBounds = YES;
        [_sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textField.mas_bottom).offset(kRKBHEIGHT(30));
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.centerX.equalTo(self.view);
            make.left.equalTo(@43);
            make.right.equalTo(@-43);
        }];
    }
    return _sendButton;
}

- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.deleteTemporaryPhoto = NO;
//        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.supportRotation = NO;
//        _manager.configuration.cameraCellShowPreview = NO;
        _manager.configuration.themeColor = kRKBNAVBLACK;
        _manager.configuration.photoMaxNum = 3; // 第一次传入的最大照片数量
        _manager.configuration.navigationBar = ^(UINavigationBar *navigationBar) {
            //                [navigationBar setBackgroundImage:[UIImage imageNamed:@"APPCityPlayer_bannerGame"] forBarMetrics:UIBarMetricsDefault];
            navigationBar.barTintColor = kRKBNAVBLACK;
        };
        _manager.configuration.sectionHeaderTranslucent = NO;
        _manager.configuration.sectionHeaderSuspensionBgColor = kRKBViewControllerBgColor;
        //        _manager.configuration.sectionHeaderSuspensionBgColor = kRKBViewControllerBgColor;
        _manager.configuration.sectionHeaderSuspensionTitleColor = XWColorFromHex(0x999999);
        _manager.configuration.statusBarStyle = UIStatusBarStyleDefault;
        _manager.configuration.selectedTitleColor = kRKBNAVBLACK;
        _manager.configuration.photoListBottomView = ^(HXDatePhotoBottomView *bottomView) {
            //            bottomView.bgView.barTintColor = kTiMainBgColor;
        };
        _manager.configuration.previewBottomView = ^(HXDatePhotoPreviewBottomView *bottomView) {
            //            bottomView.bgView.barTintColor = kTiMainBgColor;
        };
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = YES;
    }
    return _manager;
}

- (HXPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [HXPhotoView photoManager:self.manager];
        [_uploadImageView addSubview:_photoView];
        [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@50);
            make.height.equalTo(@0);
            make.right.equalTo(@-15);
        }];
        _photoView.delegate = self;
        _photoView.outerCamera = YES;
        _photoView.lineCount = 5;
        _photoView.backgroundColor = [UIColor whiteColor];
    }
    return _photoView;
}

#pragma mark - target action

- (void)send {
//    if (_textView.textView.text.length == 0) {
//        [NSObject showHudTipStr:@"反馈内容不能为空"];
//        return;
//    }
    User *user = [Login curLoginUser];
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/feedback/add" withParams:@{@"uid": @(user.uid), @"feedbackcontent": _textView.textView.text, @"feedbackremark": _textField.text, @"feedbackfileurls": [_imageURLsArray componentsJoinedByString:@","]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 400) {
        textView.text = [textView.text substringToIndex:400];
    }
    [_textView reloadCurrentNum:textView.text.length];
}

#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    [_imageURLsArray removeAllObjects];
    [allList enumerateObjectsUsingBlock:^(HXPhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [[TiHouseNetAPIClient sharedJsonClient] uploadImage:obj.previewPhoto path:@"api/outer/upload/uploadfile" name:@"icon" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
//
//        } progerssBlock:^(CGFloat progressValue) {
//
//        }];
        [[TiHouseNetAPIClient sharedJsonClient] uploadImage:obj.thumbPhoto path:@"api/outer/upload/uploadfile" name:@"icon" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            if (responseObject) {
//                [weakSelf updatePortrait:responseObject];
            [_imageURLsArray addObject:responseObject[@"halfpath"]];
            }else{
            }
        } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        } progerssBlock:^(CGFloat progressValue) {
            
        }];
    }];
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

//
//  LoginViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/25.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "SetUsetInfoViewController.h"
#import "UserTextField.h"
#import "UIViewAnimation.h"
#import "BaseNavigationController.h"
#import "HXPhotoPicker.h"
#import "Login.h"

#import "TOCropViewController.h"

@interface SetUsetInfoViewController ()<HXAlbumListViewControllerDelegate,UIImagePickerControllerDelegate,TOCropViewControllerDelegate,HXCustomCameraViewControllerDelegate>
{
    int _secondsCountDown; //倒计时总时长
    NSTimer *_countDownTimer;
}
@property (nonatomic, retain) UIButton *headerView, *messageBtn,*goBtn;
@property (nonatomic, retain) UserTextField *messageCode, *Password, *usetName;
@property (nonatomic, retain) UILabel *headerVTitle;
@property (nonatomic, retain) UIView *coverView, *loginAnimView;//蒙板当用户点击注册或下一步的时候用于遮挡
@property (nonatomic,strong) CAShapeLayer *shapeLayer;//登录转圈的那条白线所在的layer
@property (nonatomic, strong) HXPhotoManager *manager;

@end

@implementation SetUsetInfoViewController


#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self wr_setNavBarBarTintColor:XWColorFromHex(0xfcfcfc)];
    self.title = @"完善信息";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setup];
    [self SecurityCodeBtnClick:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [(BaseNavigationController *)self.navigationController  showNavBottomLine];
}

-(void)setup{
    
    [self headerView];
    [self headerVTitle];
    [self messageCode];
    [self messageBtn];
    [self Password];
    [self usetName];
    [self goBtn];
}

#pragma mark - UITableViewDelegate

#pragma mark - CustomDelegate
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    WEAKSELF
    if (photoList.count > 0) {
        HXPhotoModel *model = photoList.firstObject;
        [weakSelf.headerView setImage:model.previewPhoto forState:UIControlStateNormal];
        weakSelf.myLogin.icon = model.previewPhoto;
    }else if (videoList.count > 0) {
        
    }
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [_headerView setImage:image forState:UIControlStateNormal];
    self.myLogin.icon = image;
    [cropViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - event response

#pragma mark 短信验证码按钮事件
-(void)SecurityCodeBtnClick:(UIButton *)btn
{

    [self setTimer];
    [[TiHouse_NetAPIManager sharedManager] request_MesssgeCodeWithPath:[_myLogin toMessagePath] Params:[_myLogin toMessageParams] Block:^(id data, NSError *error) {
        if (!data) {
            [_countDownTimer invalidate];
            [_messageBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            _messageBtn.enabled = YES;
            [_countDownTimer invalidate];
            _countDownTimer = nil;
        }
    }];
}

//定时器用于短信验证
-(void)setTimer{
    
    _secondsCountDown = 60;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [_messageBtn setTitle:[NSString stringWithFormat:@"短信验证(%d)",_secondsCountDown] forState:UIControlStateNormal];
    _messageBtn.enabled = NO;
}

-(void)timeFireMethod{
    //倒计时-1
    _secondsCountDown--;
    //修改倒计时标签现实内容
    [_messageBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_secondsCountDown] forState:UIControlStateNormal];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(_secondsCountDown==0 || _secondsCountDown < 0){
        [_countDownTimer invalidate];
        [_messageBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        _messageBtn.enabled = YES;
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
}

#pragma mark - private methods 私有方法
#pragma mark -- 登录 and 下一步Click
-(void)goClick{
    
    [self.view endEditing:YES];
    WEAKSELF
    //盖住view，以屏蔽掉点击事件
    _coverView = [[UIView alloc]initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
    
    //执行登录按钮转圈动画的view
    _loginAnimView = [[UIView alloc] initWithFrame:_goBtn.frame];
    _loginAnimView.layer.cornerRadius = 25;
    _loginAnimView.layer.masksToBounds = YES;
    _loginAnimView.backgroundColor = _goBtn.backgroundColor;
    [self.view addSubview:_loginAnimView];
    _goBtn.hidden = YES;
    //把view从宽的样子变圆
    CGPoint centerPoint = self.loginAnimView.center;
    CGFloat radius = MIN(self.loginAnimView.frame.size.width, self.loginAnimView.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.loginAnimView.frame = CGRectMake(0, 0, radius, radius);
        weakSelf.loginAnimView.center = centerPoint;
        weakSelf.loginAnimView.layer.cornerRadius = radius/2;
        weakSelf.loginAnimView.layer.masksToBounds = YES;
    }completion:^(BOOL finished) {
        //给圆加一条不封闭的白色曲线
        weakSelf.shapeLayer = [UIViewAnimation getCircleWithRadius:radius BackgroundColor:weakSelf.loginAnimView.backgroundColor];
        [_loginAnimView.layer addSublayer:self.shapeLayer];
        [weakSelf.loginAnimView.layer addSublayer:weakSelf.shapeLayer];
        //让圆转圈，实现"加载中"的效果
        CABasicAnimation* baseAnimation = [UIViewAnimation getRotateAnimation];
        [_loginAnimView.layer addAnimation:baseAnimation forKey:nil];
    }];
    [self goLogin];
}

#pragma mark -- 获取数据
-(void)goLogin{
    WEAKSELF
    if (_Password.textField.text.length < 6) {
        [NSObject showHudTipStr:@"密码不能小于6位数！"];
        [self loginFail];
        return;
    }
    _myLogin.messageCode = _messageCode.textField.text;
    _myLogin.password = _Password.textField.text;
    _myLogin.nickname = _usetName.textField.text;

    [[TiHouse_NetAPIManager sharedManager] request_UserRegisterWithMyLogin:_myLogin Block:^(id data, NSError *error) {
        if (data) {
            [NSObject showHudTipStr:@"注册成功！"];
            [weakSelf loginSuccess];
            AppDelegate *appledate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appledate setupTabViewController];
            [Login doLogin:data];
        }else{
            [weakSelf loginFail];
        }
    }];
    
}

/** 登录失败 */
- (void)loginFail
{
    //把蒙版、动画view等隐藏，把真正的login按钮显示出来
    _goBtn.hidden = NO;
    [_coverView removeFromSuperview];
    [_loginAnimView removeFromSuperview];
    [_loginAnimView.layer removeAllAnimations];
    
    //给按钮添加左右摆动的效果(路径动画)
    CAKeyframeAnimation *keyFrame = [UIViewAnimation getSwingAnimationWithPoint:_loginAnimView.layer.position IsX:YES];
    [_goBtn.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
}

/** 登录成功 */
- (void)loginSuccess
{
    //移除蒙版
    _goBtn.hidden = NO;
    [_coverView removeFromSuperview];
    [_loginAnimView removeFromSuperview];
    [_loginAnimView.layer removeAllAnimations];
    //跳转到另一个控制器
//    [self.navigationController popViewControllerAnimated:YES];
    // 直接执行自动登录，token
}

-(void)GeiUserIcon{
    WEAKSELF
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"用户相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf hx_presentAlbumListViewControllerWithManager:weakSelf.manager delegate:weakSelf];
    }];
    [action setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        HXCustomCameraViewController *vc = [[HXCustomCameraViewController alloc] init];
        vc.delegate = weakSelf;
        vc.manager = weakSelf.manager;
        HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
        nav.isCamera = YES;
        nav.supportRotation = self.manager.configuration.supportRotation;
        [weakSelf presentViewController:nav animated:YES completion:nil];
    }];
    [action1 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [action2 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - getters and setters
-(UIButton *)headerView{
    if (!_headerView) {
        _headerView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView setImage:[UIImage imageNamed:@"user_icon.jpg"] forState:UIControlStateNormal];
        _headerView.layer.cornerRadius = 40.0f;
        _headerView.layer.masksToBounds = YES;
        [_headerView addTarget:self action:@selector(GeiUserIcon) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(30 + kDevice_Is_iPhoneX ? 88 : 64);
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.centerX.equalTo(self.view);
        }];
    }
    return _headerView;
}

-(UILabel *)headerVTitle{
    if (!_headerVTitle) {
        _headerVTitle = [[UILabel alloc]init];
        _headerVTitle.text = @"点击设置头像";
        _headerVTitle.font = [UIFont systemFontOfSize:13];
        _headerVTitle.textColor = [UIColor grayColor];
        [_headerVTitle sizeToFit];
        [self.view addSubview:_headerVTitle];
        [_headerVTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_bottom).offset(10);
            make.size.mas_equalTo(_headerVTitle.size);
            make.centerX.equalTo(self.view);
        }];
    }
    return _headerVTitle;
}

-(UserTextField *)messageCode{
    if (!_messageCode) {
        _messageCode = [[UserTextField alloc]initWithPlaceholder:@"填写验证码" IconImage:nil];
        _messageCode.textFieldInsets = UIEdgeInsetsMake(0, 0, 0, -100);
        [self.view addSubview:_messageCode];
        [_messageCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(43);
            make.right.equalTo(self.view).offset(-43);
            make.top.equalTo(_headerVTitle.mas_bottom).offset(63);
            make.height.equalTo(@(35));
        }];
    }
    return _messageCode;
}

-(UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setTitle:@"重新获取(60)" forState:UIControlStateNormal];
        [_messageBtn setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _messageBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _messageBtn.backgroundColor = kTiMainBgColor;
        _messageBtn.enabled = NO;
        _messageBtn.layer.cornerRadius = 4.0f;
        _messageBtn.layer.masksToBounds = YES;
        [_messageBtn addTarget:self action:@selector(SecurityCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_messageCode addSubview:_messageBtn];
        [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.top.equalTo(_messageCode);
            make.height.equalTo(@(30));
            make.width.equalTo(@(100));
        }];
    }
    return _messageBtn;
}

-(UserTextField *)Password{
    if (!_Password) {
        _Password = [[UserTextField alloc]initWithPlaceholder:@"请设置密码（至少6位数）" IconImage:nil];
        _Password.textField.secureTextEntry = YES;
        [self.view addSubview:_Password];
        [_Password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(43);
            make.right.equalTo(self.view).offset(-43);
            make.top.equalTo(_messageCode.mas_bottom).offset(44);
            make.height.equalTo(@(35));
        }];
    }
    return _Password;
}

-(UserTextField *)usetName{
    if (!_usetName) {
        _usetName = [[UserTextField alloc]initWithPlaceholder:@"请输入名字或昵称" IconImage:nil];
        [_usetName.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_usetName];
        [_usetName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(43);
            make.right.equalTo(self.view).offset(-43);
            make.top.equalTo(_Password.mas_bottom).offset(44);
            make.height.equalTo(@(35));
        }];
    }
    return _usetName;
}

-(UIButton *)goBtn{
    if (!_goBtn) {
        _goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBtn setTitle:@"完成注册" forState:UIControlStateNormal];
        [_goBtn setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _goBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:20];
        _goBtn.backgroundColor = kTiMainBgColor;
        _goBtn.layer.cornerRadius = 25.0f;
        _goBtn.layer.masksToBounds = YES;
        [_goBtn addTarget:self action:@selector(goClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_goBtn];
        [_goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_usetName.mas_bottom).offset(40);
            make.height.equalTo(@(50));
            make.width.equalTo(_Password);
            make.centerX.equalTo(_Password);
        }];
    }
    return _goBtn;
}

- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.deleteTemporaryPhoto = NO;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.openCamera = NO;
//        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.singleSelected = YES;//是否单选
        _manager.configuration.supportRotation = NO;
        _manager.configuration.cameraCellShowPreview = NO;
        _manager.configuration.ToCarpPresetSquare = YES;
        _manager.configuration.themeColor = kRKBNAVBLACK;
        _manager.configuration.navigationBar = ^(UINavigationBar *navigationBar) {
            navigationBar.barTintColor = kRKBNAVBLACK;
        };
        _manager.configuration.sectionHeaderTranslucent = NO;
        _manager.configuration.sectionHeaderSuspensionBgColor = kRKBViewControllerBgColor;
        _manager.configuration.sectionHeaderSuspensionTitleColor = XWColorFromHex(0x999999);
        _manager.configuration.statusBarStyle = UIStatusBarStyleDefault;
        _manager.configuration.selectedTitleColor = kRKBNAVBLACK;
        
    }
    return _manager;
}

-(void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model{
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.previewPhoto];
        cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        cropController.aspectRatioLockEnabled= YES;
        cropController.resetAspectRatioEnabled = NO;
        cropController.delegate = self;
        cropController.doneButtonTitle = @"完成";
        cropController.cancelButtonTitle = @"取消";
        [self.navigationController pushViewController:cropController animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    NSInteger kMaxLength = 20;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
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

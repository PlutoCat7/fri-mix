//
//  FindPhotoPostViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoPostViewController.h"
#import "FindAssemActivitySelectViewController.h"
#import "UIViewController+YHToast.h"

#import "GamePhotoSelectView.h"
#import "UITextView+ZWPlaceHolder.h"

#import "FindPhotoPostStore.h"
#import "NotificationConstants.h"

@implementation FindPhotoPostDataManager

+ (instancetype)shareInstance {
    
    static FindPhotoPostDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FindPhotoPostDataManager alloc] init];
    });
    return instance;
}

@end

@interface FindPhotoPostViewController () <
GamePhotoSelectViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *joinActivityButton;

@property (nonatomic, strong) GamePhotoSelectView *photoSelectView;

@property (nonatomic, strong) FindAssemActivityInfo *selectAssemActivityInfo;
@property (nonatomic, strong) FindPhotoPostStore *store;

@end

@implementation FindPhotoPostViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithWithPhotoModelList:(NSArray<FindPhotoHandleModel *> *)list {
    
    self = [super init];
    if (self) {
        _store = [[FindPhotoPostStore alloc] initWithWithPhotoModelList:[NSMutableArray arrayWithArray:list]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];

    if ([FindPhotoPostDataManager shareInstance].currentAssemActivity) {
        [self handleWithAssemActivityInfo:[FindPhotoPostDataManager shareInstance].currentAssemActivity];
        [FindPhotoPostDataManager shareInstance].currentAssemActivity = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self checkInputValid];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.photoSelectView.top = self.joinActivityButton.bottom;
    });
}

#pragma mark - Notification

- (void)textViewTextDidChange:(NSNotification *)notification {
    /*
    //输入框颜色黑色
    NSString *textViewText = self.contentTextView.text;
    NSRange inputRange = NSMakeRange(0, textViewText.length);
    //颜色复原
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textViewText];
    if (self.selectAssemActivityInfo) {
        NSString *activityString = [self.selectAssemActivityInfo titleWithPreSub];
        inputRange = NSMakeRange(activityString.length, textViewText.length - activityString.length);
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0xFEC00C] range:NSMakeRange(0, activityString.length)];
    }
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:inputRange];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, textViewText.length)];
    self.contentTextView.attributedText = attributedString;
     */
    
//    [self.contentTextView setSelectedRange:NSMakeRange(position.location, 0)];
    
    [self checkInputValid];
}

#pragma mark - Action

- (void)doneAction {
    
    [self.contentTextView resignFirstResponder];
    if (_store.photoModelList.count == 0) {
        return;
    }
    
    __block NSInteger step = 0;
    [self showLoadingToastWithText:[NSString stringWithFormat:@"上传中 %td/%td",  step, _store.photoModelList.count]];
    @weakify(self)
    [_store startUploadPhotoWithBlock:^(BOOL isSucess, BOOL finish) {
        
        step++;
        @strongify(self)
        if (isSucess) {
            [self showLoadingToastWithText:[NSString stringWithFormat:@"上传中 %td/%td",  step, _store.photoModelList.count]];
            if (finish) { //发布图片
                [self.store postPhotoWithRichContent:[self postRichContent]
                                               title:[self postContent]
                                          activityId:self.selectAssemActivityInfo.assemid
                                       completeBlock:^(BOOL isPost) {
                    [self dismissToast];
                    if (isPost) {//发布成功跳转
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Posted_Photo object:nil];
                    }
                }];
            }
        }
    }];
}

- (IBAction)actionJoinActivity:(id)sender {
    
    @weakify(self)
    FindAssemActivitySelectViewController *vc = [[FindAssemActivitySelectViewController alloc] initWithActivityInfo:self.selectAssemActivityInfo doneBlock:^(FindAssemActivityInfo *selectActivityInfo) {
        
        @strongify(self)
        [self handleWithAssemActivityInfo:selectActivityInfo];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"发布图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认发布" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor  colorWithRGBHex:0xbfbfbf], NSForegroundColorAttributeName, nil] forState:UIControlStateDisabled];
    
    self.contentTextView.zw_placeHolder = @"说点什么吧...";
    
    [self setupPhotoView];
    
}

- (void)setupPhotoView {
    
    _photoSelectView = [[NSBundle mainBundle] loadNibNamed:@"GamePhotoSelectView" owner:self options:nil].firstObject;
    _photoSelectView.photoModelList = self.store.photoModelList;
    _photoSelectView.delegate = self;
    _photoSelectView.maxImageCount = 20;
    _photoSelectView.superViewController = self;
    _photoSelectView.frame = CGRectMake(0, 200, self.containerView.width, 100);
    [self.containerView addSubview:_photoSelectView];
}

- (NSString *)postRichContent {//去除征集活动
    
    NSString *textViewText = self.contentTextView.text;
    
    if (self.selectAssemActivityInfo) {
        NSMutableString *mutableString = [[NSMutableString alloc] initWithString:textViewText];
        NSRange removeRange = [textViewText rangeOfString:[NSString stringWithFormat:@"%@ ", [self.selectAssemActivityInfo titleWithPreSub]]];
        [mutableString deleteCharactersInRange:removeRange];
        textViewText = [mutableString copy];
    }
    
    return [textViewText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)postContent {//去除征集活动
    
    NSString *textViewText = self.contentTextView.text;
    
    if (self.selectAssemActivityInfo) {
        NSMutableString *mutableString = [[NSMutableString alloc] initWithString:textViewText];
        NSRange removeRange = [textViewText rangeOfString:[NSString stringWithFormat:@"%@ ", [self.selectAssemActivityInfo titleWithPreSub]]];
        [mutableString deleteCharactersInRange:removeRange];
        textViewText = [mutableString copy];
    }
    return textViewText;
}

- (void)checkInputValid {
    
    BOOL enabled = [self postRichContent].length>0 && self.store.photoModelList.count>0;
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

- (void)handleWithAssemActivityInfo:(FindAssemActivityInfo *)selectActivityInfo {
    
    NSString *textViewText = self.contentTextView.text;
    if (self.selectAssemActivityInfo) {
        NSMutableString *mutableString = [[NSMutableString alloc] initWithString:textViewText];
        NSRange removeRange = [textViewText rangeOfString:[self.selectAssemActivityInfo titleWithPreSub]];
        [mutableString deleteCharactersInRange:removeRange];
        textViewText = [mutableString copy];
    }
    if (selectActivityInfo) {
        NSString *activityString = [selectActivityInfo titleWithPreSub];
        textViewText = [NSString stringWithFormat:@"%@ %@", activityString, textViewText];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textViewText];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, textViewText.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0xFEC00C] range:NSMakeRange(0, activityString.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(activityString.length, textViewText.length - activityString.length)];
        self.contentTextView.attributedText = attributedString;
        
        [self.contentTextView setSelectedRange:NSMakeRange(textViewText.length, 0)];
    }else {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textViewText];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, textViewText.length)];
        self.contentTextView.attributedText = [attributedString copy];
    }
    self.selectAssemActivityInfo = selectActivityInfo;
    
    [self checkInputValid];
}

#pragma mark - GamePhotoSelectViewDelegate

- (void)GamePhotoSelectViewFrameChange {
    
    self.containerViewHeightLayoutConstraint.constant = _photoSelectView.bottom+0.5;
}

#pragma mark - Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (self.selectAssemActivityInfo) {
        NSRange activityRange = [textView.text rangeOfString:[self.selectAssemActivityInfo titleWithPreSub]];
        if (activityRange.location+activityRange.length+1>range.location) {
            return NO;
        }else {
            return YES;
        }
    }else {
        return YES;
    }
}

@end

//
//  MineDetailViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/28.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "MineDetailViewController.h"
#import "NickViewController.h"

#import "UIImageView+WebCache.h"

#import "UserRequest.h"

#define ORIGINAL_MAX_WIDTH 240.0f

@interface MineDetailViewController () <
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userAvatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromPhoneLabel;


@end

@implementation MineDetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nickChangeNotification) name:Notification_Nick_Change_Success object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification

- (void)nickChangeNotification {
    
    self.userNameLabel.text = [RawCacheManager sharedRawCacheManager].userInfo.nick;
}

#pragma mark - Action

- (IBAction)actionAvator:(id)sender {
    
    //创建一个UIActionSheet，其中destructiveButton会红色显示，可以用在一些重要的选项
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)actionNick:(id)sender {
    
    [self.navigationController pushViewController:[NickViewController new] animated:YES];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"个人信息";
    [self setupBackButtonWithBlock:nil];

    self.userAvatorImageView.layer.cornerRadius = 10;
    self.userAvatorImageView.clipsToBounds = YES;
    
    [self refreshUI];
}

- (void)refreshUI {
    
    [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:[RawCacheManager sharedRawCacheManager].userInfo.avatar] placeholderImage:[UIImage imageNamed:@"default_avator"]];
    self.userNameLabel.text = [RawCacheManager sharedRawCacheManager].userInfo.nick;
    NSString *account = [RawCacheManager sharedRawCacheManager].userInfo.mobile;
    self.phoneLabel.text = account;
    NSString *fromMobile = [RawCacheManager sharedRawCacheManager].userInfo.fromNumber;
    if ([NSString stringIsNullOrEmpty:fromMobile]) {
        fromMobile = @"无";
    }
    self.fromPhoneLabel.text = fromMobile;
}

#pragma mark - Delegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    if (buttonIndex == 0) {
        if (![LogicManager checkIsOpenCamera]) {
            return;
        }
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }else if (buttonIndex == 1){
        if (![LogicManager checkIsOpenAblum]) {
            return;
        }
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self showLoadingToastWithText:@"正在上传头像"];
    dispatch_async( dispatch_get_main_queue(), ^(void){
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage* fixImage = [UIImage fixOrientation:image];
        fixImage = [fixImage imageScaledToSize:CGSizeMake(ORIGINAL_MAX_WIDTH, ORIGINAL_MAX_WIDTH)];
        
        [UserRequest uploadImageWithImage:fixImage handler:^(id result, NSError *error) {
            
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                AttachmentInfo *info = result;
                [UserRequest saveUserAvatorId:info.attachmentId handler:^(id result, NSError *error) {
                    if (error) {
                        [self showToastWithText:error.domain];
                    }else {
                        [self dismissToast];
                        self.userAvatorImageView.image = image;
                        [RawCacheManager sharedRawCacheManager].userInfo.avatar = info.attachment;
                        [[RawCacheManager sharedRawCacheManager].userInfo saveCache];
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_Avator object:image];
                    }
                }];
            }
        }];
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

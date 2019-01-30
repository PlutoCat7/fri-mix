//
//  SupplementViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/27.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "SupplementViewController.h"
#import "UserRequest.h"

@interface SupplementViewController ()<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *personalNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *personalNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *chooseOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseTwoLabel;

@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@property (nonatomic, copy) NSString *attachmentId;

@end

@implementation SupplementViewController

- (void)dealloc
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    [self checkButtonEnable];
}

#pragma mark - Action

- (IBAction)actionAddPhoto:(id)sender {
    
    if (![NSString stringIsNullOrEmpty:self.attachmentId]) {
        return;
    }
    //创建一个UIActionSheet，其中destructiveButton会红色显示，可以用在一些重要的选项
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)actionComplete:(id)sender {
    
    NSString *companyName = [self.companyTextField.text removeSpace];
    NSString *personalName = [self.numberTextField.text removeSpace];
    NSString *phone = [self.personalNameTextField.text removeSpace];
    NSString *address = [self.personalNumberTextField.text removeSpace];
    [self showLoadingToast];
    @weakify(self)
    [UserRequest userSupplement:companyName
                         cer_no:phone
                     cer_person:personalName
                       cer_addr:address
                    cer_pic1_id:self.attachmentId handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [RawCacheManager sharedRawCacheManager].userInfo.needProfile = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_Supplement object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"商家基本信息";
    [self setupBackButtonWithBlock:nil];
    
    self.completeButton.layer.cornerRadius = 8;
    [self.completeButton setBackgroundImage:[UIImage imageWithColor:[ColorManager styleColor]] forState:UIControlStateNormal];
    [self.completeButton setBackgroundImage:[UIImage imageWithColor:[ColorManager buttonDisableColor]] forState:UIControlStateDisabled];
}

- (void)checkButtonEnable {
    
    NSString *companyName = [self.companyTextField.text removeSpace];
    NSString *companyNumber = [self.numberTextField.text removeSpace];
    NSString *personalName = [self.personalNameTextField.text removeSpace];
    NSString *personalNumber = [self.personalNumberTextField.text removeSpace];
    BOOL enbale = (companyName.length>0 &&
                   companyNumber.length>0 &&
                   personalName.length>0 &&
                   personalNumber.length>0 &&
                   ![NSString stringIsNullOrEmpty:self.attachmentId]);
    self.completeButton.enabled = enbale;
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
    [self showLoadingToastWithText:@"正在上传图片"];
    dispatch_async( dispatch_get_main_queue(), ^(void){
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage* fixImage = [UIImage fixOrientation:image];
        
        [UserRequest uploadImageWithImage:fixImage handler:^(id result, NSError *error) {
            
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                AttachmentInfo *info = result;
                self.attachmentId = info.attachmentId;
                [self.addPhotoButton setImage:fixImage forState:UIControlStateNormal];
                [self checkButtonEnable];
            }
        }];
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  RElativeFriDetailTableViewController.m
//  TiHouse
//
//  Created by guansong on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RelativeFriDetailTableViewController.h"
#import "RelativeFriViewController.h"
#import "RelationViewController.h"
#import "HXPhotoPicker.h"
#import "TOCropViewController.h"
#import "Login.h"
#import "SettingAuthorityViewController.h"
#import "HXPhotoPicker.h"

@interface RelativeFriDetailTableViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,HXAlbumListViewControllerDelegate,HXCustomCameraViewControllerDelegate,TOCropViewControllerDelegate>
@property (nonatomic,strong) NSArray *arrSectiontitle;

@property (weak, nonatomic) IBOutlet UIImageView *imgVhead;

@property (weak, nonatomic) IBOutlet UILabel *lblRelative;

@property (weak, nonatomic) IBOutlet UILabel *lblNick;

@property (weak, nonatomic) IBOutlet UILabel *lblAuth;

@property (strong, nonatomic) HXPhotoManager *manager;

@property (nonatomic, retain) TOCropViewController *cropController;

@property (weak, nonatomic) IBOutlet UITableViewCell *cell1;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayout2;




@end

@implementation RelativeFriDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRKBViewControllerBgColor;
    [self wr_setNavBarBarTintColor:kTiMainBgColor];
    [self wr_setNavBarTitleColor:kRKBNAVBLACK];
    [self wr_setNavBarTintColor:kRKBNAVBLACK];
    
    self.title = @"亲友信息";
    
    [self setData];
    
    [self config];
    
}

- (void)config{
    
    WS(weakSelf);
    [RACObserve(self.person, typerelation) subscribeNext:^(id x) {
        weakSelf.lblRelative.text = IF_NULL_TO_STRINGSTR([weakSelf.person typerelationName], @"-");
    }];
    
    [RACObserve(self.person, nickname) subscribeNext:^(id x) {
        weakSelf.lblNick.text = IF_NULL_TO_STRINGSTR(x, @"-");
    }];
    
    [RACObserve(self.person, urlhead) subscribeNext:^(id x) {
        [weakSelf.imgVhead sd_setImageWithURL:[NSURL URLWithString:x] placeholderImage:IMAGE_ANME(@"user_icon.jpg")];
    }];
    
}

- (void)setData{
    
    User *user = [Login curLoginUser];
    if (user.uid == self.house.uidcreater || user.uid == self.person.uidconcert) {
        
        self.cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        self.rightLayout2.constant = 34;
        
        if (user.uid == self.house.uidcreater){
            self.lblAuth.text = @"设置权限";
            self.cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.rightLayout1.constant = 34;
        }else{
            self.lblAuth.text = @"查看权限";
            self.cell1.accessoryType = UITableViewCellAccessoryNone;
            self.rightLayout1.constant = 15;
        }
        
    }else{
        
        self.rightLayout1.constant = 15;
        self.rightLayout2.constant = 15;
        self.cell1.accessoryType = UITableViewCellAccessoryNone;
        self.cell2.accessoryType = UITableViewCellAccessoryNone;
        //        self.cell3.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    
    
    self.lblRelative.text = IF_NULL_TO_STRINGSTR([self.person typerelationName], @"-");
    
    self.lblNick.text = IF_NULL_TO_STRINGSTR(self.person.nickname, @"-");
    
    [self.imgVhead sd_setImageWithURL:[NSURL URLWithString:self.person.urlhead] placeholderImage:IMAGE_ANME(@"user_icon.jpg")];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User *user = [Login curLoginUser];
    if (indexPath.section == 1) {
        
        if (user.uid != self.house.uidcreater){
            [NSObject showStatusBarErrorStr:@"您不是房屋主人，不能删除亲友！"];
            return;
        }
        if (user.uid == self.person.uidconcert) {
            [NSObject showStatusBarErrorStr:@"您不能删除自己！"];
            return;
        }
        //删除
        [self showAlertTip];
        
        return;
    }
    
    switch (indexPath.row) {
        case 0:{
            if (user.uid == self.person.uidconcert) {
                if (@available(iOS 11.0, *)){
                    
                    [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
                }
                //头像
                [self getHeadImage];
            }else {
                [NSObject showStatusBarErrorStr:@"只能修改自己的头像"];
            }
        }
            break;
        case 1:{
            //关系
            if (user.uid == self.house.uidcreater) {
                RelationViewController *rVC = [[RelationViewController alloc] init];
                rVC.house = _house;
                rVC.selectedBtn = self.person.typerelation;
                WS(weakSelf);
                rVC.finishBolck = ^(NSString *ValueStr, NSInteger item) {
                    [weakSelf uploadRelation:item];
                };
                [self.navigationController pushViewController:rVC animated:YES];
            }
        }
            break;
        case 2:{
            if (user.uid == self.person.uidconcert  || user.uid == self.house.uidcreater) {
                //昵称
                RelativeFriViewController *rfVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([RelativeFriViewController class])];
                rfVC.person = self.person;
                WS(weakSelf);
                rfVC.block = ^(id rst) {
                    weakSelf.person.nickname = rst;
                };
                [self.navigationController pushViewController:rfVC animated:YES];
            }
        }
            break;
        case 3:{
            //权限
            //            if (user.uid == self.house.uidcreater) {//主人
            SettingAuthorityViewController *saVC = [[SettingAuthorityViewController alloc] init];
            saVC.person = self.person;
            saVC.isMaster = user.uid == self.house.uidcreater;
            saVC.title = self.lblAuth.text;
            
            [self.navigationController pushViewController:saVC animated:YES];
            
            //            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - load

- (void)uploadRelation:(long)typerelation{
    
    User *user = [Login curLoginUser];
    
    __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window beginLoading];
    WS(weakSelf);
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:URL_Edit_TypeRelation withParams:@{@"typerelation":JLong2String(typerelation),@"uid":JLong2String(user.uid),@"housepersonid":JLong2String(self.person.housepersonid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        [appDelegate.window endLoading];
        if ([data[@"is"] intValue]) {
            
            weakSelf.person.typerelation = typerelation;
            if (weakSelf.person.typerelation == 2) {
                weakSelf.person.isreaddairy = 1;
            }
            
            [NSObject showStatusBarSuccessStr:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [NSObject showStatusBarErrorStr:data[@"msg"]];
        }
    }];
}



#pragma mark - 相册

- (void)request_UpdateUserIconImage:(UIImage *)image
                       successBlock:(void (^)(id responseObj))success
                       failureBlock:(void (^)(NSError *error))failure
                      progerssBlock:(void (^)(CGFloat progressValue))progress{
    if (!image) {
        [NSObject showHudTipStr:@"头像不能为空"];
        if (failure) {
            failure(nil);
        }
        return;
    }
    CGSize maxSize = CGSizeMake(600, 600);
    if (image.size.width > maxSize.width || image.size.height > maxSize.height) {
        image = [image scaleToSize:maxSize usingMode:NYXResizeModeAspectFit];
    }
    [[TiHouseNetAPIClient sharedJsonClient] uploadImage:image path:@"api/outer/upload/uploadfile" name:@"icon" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        
        if (responseObject) {
            success(responseObject);
        }else{
            success(nil);
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        success(nil);
    } progerssBlock:^(CGFloat progressValue) {
        
    }];
}

#pragma end mark

- (void)getHeadImage{
    
    WS(weakSelf);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"用户相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
//        weakSelf.manager.type = HXPhotoManagerSelectedTypePhoto;
//        weakSelf.manager.configuration.singleSelected = YES;//是否单选
//        [weakSelf hx_presentAlbumListViewControllerWithManager:weakSelf.manager delegate:weakSelf];
        
        UIImagePickerController * ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = weakSelf;
        ipc.allowsEditing = YES; //是否可编辑
        [weakSelf presentViewController:ipc animated:YES completion:nil];
        
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

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.singleSelected = YES;
    }
    return _manager;
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window beginLoading];
    
    WS(weakSelf);
    [self request_UpdateUserIconImage:image successBlock:^(id responseObj) {
        weakSelf.person.urlhead = responseObj[@"fullpath"];
        //上传用户信息
        [weakSelf uploadFriendHeadImage:responseObj[@"halfpath"]];
        
    } failureBlock:^(NSError *error) {
        weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;
        weakSelf.view.userInteractionEnabled = YES;
        
        [NSObject showStatusBarErrorStr:@"上传失败"];
        [appDelegate.window endLoading];
        
    } progerssBlock:^(CGFloat progressValue) {
        
    }];
    
    
    //    [self saveIcon];
    [cropViewController.navigationController popViewControllerAnimated:YES];
}

-(void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model{
    _cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.previewPhoto];
    _cropController.aspectRatioLockEnabled= YES;
    _cropController.resetAspectRatioEnabled = NO;
    _cropController.delegate = self;
    _cropController.doneButtonTitle = @"完成";
    _cropController.cancelButtonTitle = @"取消";
    _cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
    
    [self.navigationController pushViewController:_cropController animated:NO];
}

/**
 点击完成
 
 @param albumListViewController self
 @param allList 已选的所有列表(包含照片、视频)
 @param photoList 已选的照片列表
 @param videoList 已选的视频列表
 @param original 是否原图
 */
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original{
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window beginLoading];
    
    UIImage *image = photoList.count>0 ? photoList[0].thumbPhoto :nil;
    // 从info中将图片取出，并加载到imageView当中
    if(image){
        WS(weakSelf);
        [self request_UpdateUserIconImage:image successBlock:^(id responseObj) {
            weakSelf.person.urlhead = responseObj[@"fullpath"];
            //上传用户信息
            [weakSelf uploadFriendHeadImage:responseObj[@"halfpath"]];
            
        } failureBlock:^(NSError *error) {
            [NSObject showStatusBarErrorStr:@"上传失败"];
            
            [appDelegate.window endLoading];
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            self.view.userInteractionEnabled = YES;
            
        } progerssBlock:^(CGFloat progressValue) {
            
        }];
    }
}

#pragma mark - 相册选择图片回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];

    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window beginLoading];
    
    // 从info中将图片取出，并加载到imageView当中
    if(image){
        WS(weakSelf);
        [self request_UpdateUserIconImage:image successBlock:^(id responseObj) {
            weakSelf.person.urlhead = responseObj[@"fullpath"];
            //上传用户信息
            [weakSelf uploadFriendHeadImage:responseObj[@"halfpath"]];
            [Login curLoginUser].urlhead = responseObj[@"fullpath"];

        } failureBlock:^(NSError *error) {
            [NSObject showStatusBarErrorStr:@"上传失败"];
            
            [appDelegate.window endLoading];
            weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;
            weakSelf.view.userInteractionEnabled = YES;
            
        } progerssBlock:^(CGFloat progressValue) {
            
        }];
    }
}

#pragma mark - 上传头像
- (void)uploadFriendHeadImage:(NSString *)urlhead{
    
    User *user = [Login curLoginUser];
    __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate.window beginLoading];
    
    WS(weakSelf);
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:URL_Edit_Fri_Head withParams:@{@"uid":@(user.uid),@"housepersonid":@(self.person.housepersonid),@"urlhead":urlhead}  withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        [appDelegate.window endLoading];
        weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;
        weakSelf.view.userInteractionEnabled = YES;

        if ([data[@"is"] intValue]) {
            [NSObject showStatusBarSuccessStr:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [NSObject showStatusBarErrorStr:data[@"msg"]];
        }
    }];
}





- (void)showAlertTip{
    NSString *msg = JString(@"确定要删除吗？这将导致“%@”不能访问房屋的空间。为了更安全，邀请码也会被重置。",self.person.nickname);
    
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {

        __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.window beginLoading];
        [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:URL_Delect_RelFri withParams:@{@"houseid":@(self.house.houseid), @"uidconcert": @(self.person.uidconcert)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
            [appDelegate.window endLoading];
            if ([data[@"is"] intValue]) {
                [NSObject showStatusBarSuccessStr:@"删除成功"];
                [NSObject showHUDQuery];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    [NSObject hideHUDQuery];
                });
            }else{
                [NSObject showStatusBarErrorStr:data[@"msg"]];
            }
        }];
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    User *user = [Login curLoginUser];
    if (user.uid == self.house.uidcreater) {
        
        //如果是自己创建的房屋，亲友里面进入自己的编辑页面之后，没有删除按钮
        if (self.person.uidconcert != self.house.uidcreater) {
            return 2;
        } else {
            return 1;
        }
    }
    return 1;
}
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(section>=1)
//        return 40;
//    return 0;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    User *user = [Login curLoginUser];
    if (user.uid == self.house.uidcreater) {
        
        if (section == 0) {
            return 4;
        }
        return 1;
    } else if (user.uid == self.person.uidconcert){
        return 4;
    }
    return 3;
}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mycell"];
//    cell.textLabel.text = self.arrSectiontitle[indexPath.row];
//    // Configure the cell...
//
//    return cell;
//}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


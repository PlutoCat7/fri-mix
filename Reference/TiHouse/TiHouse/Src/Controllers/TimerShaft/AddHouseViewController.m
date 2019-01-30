//
//  AddHouseViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/16.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "AddHouseViewController.h"
#import "AddHouseTableHeaderView.h"
#import "AddHouseTableViewCell.h"
#import "RelationView.h"
#import "SelectHouseTypeViewController.h"
#import "RelationViewController.h"
#import "AddressViewController.h"
#import "HXPhotoPicker.h"
#import "AddresManager.h"
#import "TOCropViewController.h"
#import "House.h"
#import "AnimationBtnLogin.h"
#import "Login.h"
#import "SDPhotoBrowser.h"
#import "XWAlertView.h"
#import "InvitationCodeViewController.h"

#import "BudgetDetailsViewController.h"

@interface AddHouseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HXAlbumListViewControllerDelegate,UIImagePickerControllerDelegate,HXCustomCameraViewControllerDelegate,TOCropViewControllerDelegate,SDPhotoBrowserDelegate>
{
    BOOL ClickHeaderIcon;
    NSArray * editValues;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AddHouseTableHeaderView *TableHeader;
@property (nonatomic, strong) UIView *tableFooter;
@property (nonatomic, strong) NSArray *UIModels;
@property (nonatomic, strong) NSMutableDictionary *HouseTypeDic;
@property (nonatomic, strong) HXPhotoManager *manager;
@property (nonatomic, strong) AddresManager *addres;
@property (nonatomic, assign) NSInteger relation;
@property (nonatomic, retain) TOCropViewController *cropController;
@property (nonatomic, retain) HXCustomNavigationController *nav;
@property (nonatomic, retain) AnimationBtnLogin *BtnLogin;

@end

@implementation AddHouseViewController

#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = YES;
    if (_addHouse) {
        if (_isNoHouse) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(doLogout)];
        }
        self.title = @"添加房屋";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
        _myHouse = [[House alloc]init];
        self.myHouse.numroom = 1;
        self.myHouse.numhall = 1;
        self.myHouse.numkichen = 1;
        self.myHouse.numtoilet = 1;
        self.myHouse.numbalcony = 1;
    }else{
        if (_myHouse.uidcreater != [[Login curLoginUser] uid]) {
            self.title = @"房屋信息";
        } else {
            self.title = @"编辑房屋";
        }

        [self wr_setNavBarTitleColor:[UIColor whiteColor]];
        [self wr_setNavBarTintColor:[UIColor whiteColor]];
        [self wr_setNavBarBarTintColor:[UIColor colorWithWhite:0 alpha:0]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        UIImage *rightImage = [[UIImage imageNamed:@"navBar_edir"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *barBtn1=[[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
        self.navigationItem.rightBarButtonItem = barBtn1;
        NSString *areaStr = [NSString stringWithFormat:@"%ldm²",(long)self.myHouse.area];
        NSString *houseType = [NSString stringWithFormat:@"%ld室%ld厅%ld厨%ld卫%ld阳台",(long)self.myHouse.numroom,(long)self.myHouse.numhall,(long)self.myHouse.numkichen,(long)self.myHouse.numtoilet,(long)self.myHouse.numbalcony];
        NSString *addrdetailStr = self.myHouse.addrdetail;
        NSString *addrname = self.myHouse.addrname;
        editValues = @[self.myHouse.housename,self.myHouse.residentname,areaStr,houseType,addrdetailStr,addrname];
        
        [self.TableHeader.Icon sd_setImageWithURL:[NSURL URLWithString:self.myHouse.urlfront]];
        [self.TableHeader.bgImageV sd_setImageWithURL:[NSURL URLWithString:self.myHouse.urlback]];
        _BtnLogin= [[AnimationBtnLogin alloc]init];
    }
    self.UIModels = [UIHelp getAddHouseUI];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [(BaseNavigationController *)self.navigationController  hideNavBottomLine];
    if (!_addHouse) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return  [_UIModels[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _UIModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIModel *uimodel = _UIModels[indexPath.section][indexPath.row];
    cell.TextField.placeholder = uimodel.TextFieldPlaceholder;
    
    if (!_addHouse && _myHouse.uidcreater != [[Login curLoginUser] uid]) {
        cell.Title.text = [uimodel.Title substringWithRange:NSMakeRange(1, 2)];
    } else {
        cell.Title.text = uimodel.Title;
    }
    
    
    if ((indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 5) && indexPath.section == 0) {
        [cell.TextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    if (indexPath.row ==  0) {
        cell.topLineStyle = CellLineStyleFill;
        if (indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.TextField.userInteractionEnabled = NO;
            cell.Title.width = cell.superview.width;
            cell.bottomLineStyle = CellLineStyleFill;
            
            if (!_addHouse) {
                cell.bottomLineStyle = CellLineStyleNone;
                cell.topLineStyle = CellLineStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.userInteractionEnabled = NO;
                cell.Title.hidden = YES;
                cell.TextField.hidden = YES;
                cell.backgroundColor = [UIColor clearColor];
                cell.userInteractionEnabled = YES;
                
                UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [saveBtn setTitle:@"保存修改" forState:UIControlStateNormal];
                [saveBtn setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
                saveBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:20];
                saveBtn.backgroundColor = kTiMainBgColor;
                saveBtn.layer.cornerRadius = kRKBHEIGHT(25);
                saveBtn.layer.masksToBounds = YES;
//                saveBtn.hidden = !_myHouse.isedit;
                [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
                if (_myHouse.uidcreater == [[Login curLoginUser] uid]) {
                    [cell.contentView addSubview:saveBtn];
                    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@(kRKBHEIGHT(50)));
                        make.width.equalTo(@(cell.contentView.width - 86));
                        make.centerX.equalTo(cell.mas_centerX);
                        make.centerY.equalTo(cell.mas_centerY);
                    }];

                }
                
            }
        }
    }
    if (indexPath.row ==  5) {
        cell.bottomLineStyle = CellLineStyleFill;
    }
    if (indexPath.row ==  2) {
        cell.TextField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.TextField.delegate = self;
        [cell.TextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    if (indexPath.row ==  3 || indexPath.row ==  4) {
        if (_myHouse.uidcreater != [[Login curLoginUser] uid]) {
            cell.accessoryType = UITableViewCellAccessoryNone;

        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.TextField.userInteractionEnabled = NO;
    }
    if (!_addHouse) {
        cell.userInteractionEnabled = _myHouse.isedit;
        cell.TextField.text = editValues[indexPath.row];
    }
    
    if (indexPath.row == 5 && !_addHouse) {
        NSString *detailAddress = editValues[5];
        if (!(detailAddress.length > 0)) {
            cell.TextField.text = _myHouse.isedit ? @"" : @" ";
        }
    }
    
    if (indexPath.row == 3 && _addHouse)
    {
        cell.TextField.text = [NSString stringWithFormat:@"%ld室%ld厅%ld厨%ld卫%ld阳台",self.myHouse.numroom,self.myHouse.numhall, self.myHouse.numkichen,self.myHouse.numtoilet,self.myHouse.numbalcony];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_addHouse) {
        if (indexPath.section == 0) {
            return kRKBHEIGHT(50);
        }else{
            return kRKBHEIGHT(100);
        }
    }
    
    return kRKBHEIGHT(50);
}
// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 0 ? 15 : 0.01;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_myHouse.uidcreater != [[Login curLoginUser] uid] && !_addHouse) {
        return;
    }
    if (indexPath.row == 3) {

        SelectHouseTypeViewController *houseTypeVC = [SelectHouseTypeViewController new];
        WEAKSELF
        houseTypeVC.SelectedHouseType = ^(NSMutableDictionary *dic) {
            _HouseTypeDic = dic;
            AddHouseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            weakSelf.myHouse.numroom = [dic[@"room"] integerValue];
            weakSelf.myHouse.numhall = [dic[@"hall"] integerValue];
            weakSelf.myHouse.numkichen = [dic[@"kitchen"] integerValue];
            weakSelf.myHouse.numtoilet = [dic[@"toilet"] integerValue];
            weakSelf.myHouse.numbalcony = [dic[@"balcony"] integerValue];
            cell.TextField.text = [NSString stringWithFormat:@"%@室%@厅%@厨%@卫%@阳台",dic[@"room"],dic[@"hall"],dic[@"kitchen"],dic[@"toilet"],dic[@"balcony"]];
        };
        _HouseTypeDic = [[NSMutableDictionary alloc] init];
        _HouseTypeDic[@"room"] = [NSString stringWithFormat:@"%ld",_myHouse.numroom];
        _HouseTypeDic[@"hall"] = [NSString stringWithFormat:@"%ld",_myHouse.numhall];
        _HouseTypeDic[@"kitchen"] = [NSString stringWithFormat:@"%ld",_myHouse.numkichen];
        _HouseTypeDic[@"toilet"] = [NSString stringWithFormat:@"%ld",_myHouse.numtoilet];
        _HouseTypeDic[@"balcony"] = [NSString stringWithFormat:@"%ld",_myHouse.numbalcony];
        houseTypeVC.ValuesDic = _HouseTypeDic;
        [self.navigationController pushViewController:houseTypeVC animated:YES];
    }
    if (indexPath.row == 4) {
        AddressViewController *addRess = [AddressViewController new];
        //        addRess.addres = _addres;
        WEAKSELF
        addRess.finishAddres = ^(AddresManager *addres) {
            weakSelf.addres = addres;
            weakSelf.myHouse.regionid = addres.region.regionid;
            AddHouseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.TextField.text = [NSString stringWithFormat:@"%@ %@ %@",addres.province.provname ? addres.province.provname : @"",addres.city.cityname ? addres.city.cityname : @"",addres.region.regionname ? addres.region.regionname : @""];
        };
        [self addChildViewController:addRess];
        addRess.view.frame = self.view.bounds;
        [self.view addSubview:addRess.view];
        [addRess showContent];
    }
    if (indexPath.row == 0 & indexPath.section == 1) {
        RelationViewController *relation = [[RelationViewController alloc]init];
        relation.house = _myHouse;
        relation.selectedBtn = _relation;
        WEAKSELF
        relation.finishBolck = ^(NSString *ValueStr, NSInteger item) {
            AddHouseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.TextField.text = ValueStr;
            weakSelf.relation = item;
            weakSelf.myHouse.typerelation = item;
        };
        [self.navigationController pushViewController:relation animated:YES];
    }
}

-(void)selectImage{

    WEAKSELF
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"用户相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf hx_presentAlbumListViewControllerWithManager:weakSelf.manager delegate:weakSelf];
    }];
    [action setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf GoToCameraView];
    }];
    [action1 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *lookPhoto = [UIAlertAction actionWithTitle:@"查看大图" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = 0;
        photoBrowser.imageCount = 1;
        [photoBrowser show];
    }];
    [lookPhoto setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [action2 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    

    if (!_addHouse) {
        if (_myHouse.houseisself == 1) {
            [alert addAction:action];
            [alert addAction:action1];
        }
        [alert addAction:lookPhoto];
    } else {
        [alert addAction:action];
        [alert addAction:action1];
    }
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - CustomDelegate
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    return ClickHeaderIcon ? _TableHeader.Icon.image : _TableHeader.bgImageV.image;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = @"";
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.text.length) {
        _myHouse.area = [textField.text integerValue];
        textField.text = [NSString stringWithFormat:@"%@m²",textField.text];
    }
    return YES;
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    WEAKSELF
    if (photoList.count > 0) {
        HXPhotoModel *model = photoList.firstObject;
        if (ClickHeaderIcon) {
            weakSelf.TableHeader.Icon.image = model.previewPhoto;
            weakSelf.myHouse.halfurlfront = @"";
            weakSelf.myHouse.front = model.previewPhoto;
        }else{
            weakSelf.TableHeader.bgImageV.image = model.previewPhoto;
            weakSelf.myHouse.halfurlback = @"";
            weakSelf.myHouse.back = model.previewPhoto;
        }
        
    }else if (videoList.count > 0) {
        
    }
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    if (ClickHeaderIcon) {
        _TableHeader.Icon.image = image;
        _myHouse.halfurlfront = @"";
        _myHouse.front = image;
    }else{
        _TableHeader.bgImageV.image = image;
        _myHouse.halfurlback = @"";
        _myHouse.back = image;
    }
    [cropViewController.navigationController popViewControllerAnimated:YES];
}


#pragma mark - event response
//前往相机
-(void)GoToCameraView{
    WEAKSELF
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                HXCustomCameraViewController *vc = [[HXCustomCameraViewController alloc] init];
                vc.delegate = weakSelf;
                vc.manager = weakSelf.manager;
                HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
                nav.isCamera = YES;
                nav.supportRotation = self.manager.configuration.supportRotation;
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle hx_localizedStringForKey:@"无法使用相机"] message:[NSBundle hx_localizedStringForKey:@"请在设置-隐私-相机中允许访问相机"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:[NSBundle hx_localizedStringForKey:@"取消"] style:UIAlertActionStyleDefault handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:[NSBundle hx_localizedStringForKey:@"设置"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }]];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        });
    }];
    
}

//点击完成
-(void)finish{
    
    WEAKSELF
    if (!_addHouse) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *reset = [UIAlertAction actionWithTitle:@"重置邀请码" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf resetCode];
        }];
        [reset setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf removeHouse];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [cancel setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
        
        UIAlertAction *cancelAttention = [UIAlertAction actionWithTitle:@"取消关注" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf cancelAttention];
        }];

        
        if (_myHouse.houseisself == 1) {
            [alertVC addAction:reset];
            [alertVC addAction:delete];
        } else {
            [alertVC addAction:cancelAttention];
        }
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return;
    }
    
    AddHouseTableViewCell *housenamecell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _myHouse.housename = housenamecell.TextField.text;
    AddHouseTableViewCell *residentnamecell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    _myHouse.residentname = residentnamecell.TextField.text;
    AddHouseTableViewCell *addrnamecell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    _myHouse.addrname = addrnamecell.TextField.text;
    
    //不能输入特殊符号
    if ([NSString stringContainsEmoji:_myHouse.housename] || [NSString stringContainsEmoji:_myHouse.residentname] || [NSString stringContainsEmoji:_myHouse.addrname]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"错误" message:@"不支持输入表情等特殊符号，请重新输入" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cation = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:cation];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    // 限制房屋名称长度
    if (_myHouse.housename.length > 10) {
        [NSObject showHudTipStr:@"房屋名称不能超过十位"];
        return;
    }
    
    if (_myHouse.typerelation == 0) {
        [NSObject showHudTipStr:@"请选择您与房屋的关系"];
        return;
    }
    
    if ([_myHouse TipStr].length) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请完善您的房屋信息！" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    [NSObject showHUDQueryStr:@"上传数据"];
    [[TiHouse_NetAPIManager sharedManager]request_AddHouseWithHouse:_myHouse Block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:NO];
                if (weakSelf.finishAddHouseBlock) {
                    House *house = (House *)data;
                    house.isFirstCreate = [Login curLoginUser].userisderive == 2;
                    weakSelf.finishAddHouseBlock(house);
                }
            });
        }else{
//            [NSObject showHudTipStr:@"添加失败"];
        }
    }];
    
}

-(void)removeHouse{
    WEAKSELF
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您确定要删除房屋“%@”吗？\n这会导致您不能继续查看房屋相关内容。",_myHouse.housename] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [NSObject showHUDQueryStr:@"删除房屋"];
        [[TiHouse_NetAPIManager sharedManager] request_WithPath:@"api/inter/house/remove" Params:@{@"houseid":[NSString stringWithFormat:@"%ld",weakSelf.myHouse.houseid]} Block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                [NSObject showHudTipStr:@"删除成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [delete setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    [cancel setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    [alertVC addAction:delete];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

-(void)resetCode{
    WEAKSELF
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当您认为房屋邀请码可能泄漏或不安全时，可以重置邀请码，旧的邀请码立刻即失效。" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [[TiHouse_NetAPIManager sharedManager] request_ResetCodeinviteWithHouseid:weakSelf.myHouse.houseid Block:^(id data, NSError *error) {
            weakSelf.myHouse = (House*)data;
            XWAlertView *alert = [[XWAlertView alloc]init];
            alert.image = [UIImage imageNamed:@"alertIcon_Yes"];
            alert.message = [NSString stringWithFormat:@"重置邀请码成功，新的邀请码为：\n%@",weakSelf.myHouse.codeinvite];
            alert.BtnClikc = ^{
            };
            [alert show];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [delete setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    [cancel setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    [alertVC addAction:delete];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}


-(void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model{
    _cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.previewPhoto];
    _cropController.aspectRatioLockEnabled= YES;
    _cropController.resetAspectRatioEnabled = NO;
    _cropController.delegate = self;
    _cropController.doneButtonTitle = @"完成";
    _cropController.cancelButtonTitle = @"取消";
    if (ClickHeaderIcon) {
        _cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
    }else{
        _cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
    }
    [self.navigationController pushViewController:_cropController animated:NO];
}

#pragma mark - private methods 私有方法

-(void)save:(UIButton *)btn{
    
    
    [_BtnLogin AnimationBtnLoginWithTagView:btn];
    AddHouseTableViewCell *housenamecell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    AddHouseTableViewCell *houseMetersCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (housenamecell.TextField.text.length  > 10) {
        [NSObject showHudTipStr:@"房屋名称不能超过十位"];
        [_BtnLogin RemoveAnimationBtnLogin];
        return;
    }
    
    if (houseMetersCell.TextField.text.length == 0) {
        [NSObject showHudTipStr:@"房屋面积不能为空"];
        [_BtnLogin RemoveAnimationBtnLogin];
        return;
    }

    
    _myHouse.housename = housenamecell.TextField.text;
    AddHouseTableViewCell *residentnamecell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    _myHouse.residentname = residentnamecell.TextField.text;
    AddHouseTableViewCell *addrnamecell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    _myHouse.addrname = addrnamecell.TextField.text;
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager]request_EditHouseWithHouse:_myHouse Block:^(id data, NSError *error) {
        [weakSelf.BtnLogin RemoveAnimationBtnLogin];
        if ([data[@"is"] intValue] == 1) {
            weakSelf.myHouse = [House mj_objectWithKeyValues:data[@"data"]];
            [NSObject showHudTipStr:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf.editBlock) {
                    weakSelf.editBlock(weakSelf.myHouse);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark - getters and setters
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.automaticallyAdjustsScrollViewInsets = NO;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[AddHouseTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.estimatedRowHeight = 50;
        _tableView.tableHeaderView = self.TableHeader;
        if (_addHouse && _isNoHouse) {
            _tableView.tableFooterView = self.tableFooter;
        }
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

-(AddHouseTableHeaderView *)TableHeader{
    if (!_TableHeader) {
        _TableHeader = [[AddHouseTableHeaderView alloc]init];
        if (kDevice_Is_iPhoneX) {
            _TableHeader.frame = CGRectMake(0, 0, kScreen_Width, _addHouse ? kRKBHEIGHT(175)+88 : kRKBHEIGHT(155)+88);
        }else{
            _TableHeader.frame = CGRectMake(0, 0, kScreen_Width, _addHouse ? kRKBHEIGHT(175)+64 : kRKBHEIGHT(155)+64);
        }
        __weak typeof(self) wealself = self;
        _TableHeader.SelectPhoto = ^{
            if (_myHouse.houseisself != 1 && !_addHouse) {
                return;
            }
            wealself.manager.configuration.movableCropBox = YES;
            ClickHeaderIcon = YES;
            [wealself selectImage];
        };
        _TableHeader.SelectBgImage = ^{
            wealself.manager.configuration.movableCropBox = YES;
            ClickHeaderIcon = NO;
            [wealself selectImage];
        };
        _TableHeader.HintTest.hidden = _myHouse.houseisself != 1;
        
    }
    return _TableHeader;
}

- (UIView *)tableFooter {
    if (!_tableFooter) {
        _tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 65)];
        _tableFooter.backgroundColor = [UIColor clearColor];
        UIButton *inviteButton = [[UIButton alloc] init];
        [_tableFooter addSubview:inviteButton];
        [inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self->_tableFooter);
        }];
        [inviteButton setImage:[UIImage imageNamed:@"addHouse_icon"] forState:UIControlStateNormal];
        [inviteButton setTitle:@"    输入邀请码关注房屋" forState:UIControlStateNormal];
        inviteButton.titleLabel.font = [UIFont fontWithName:@"FZLTHK" size:13];
        [inviteButton setTitleColor:[UIColor colorWithHexString:@"0x5186aa"] forState:UIControlStateNormal];
        [inviteButton addTarget:self action:@selector(inputInviteCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableFooter;
}

- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.deleteTemporaryPhoto = NO;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.singleSelected = YES;//是否单选
        _manager.configuration.supportRotation = NO;
        _manager.configuration.cameraCellShowPreview = NO;
        _manager.configuration.ToCarpPresetSquare = YES;
        _manager.configuration.themeColor = kRKBNAVBLACK;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    AddHouseTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    AddHouseTableViewCell *courtCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    AddHouseTableViewCell *addressDetailCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSInteger kMaxLength;
    if (cell.TextField == textField) {
        kMaxLength = 10;
    } else if (courtCell.TextField == textField) {
        kMaxLength = 20;
    } else if (addressDetailCell.TextField == textField) {
        kMaxLength = 100;
    } else {
        kMaxLength = 4;
    }
    //    NSInteger kMaxLength = 20;
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

- (void)doLogout {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认退出登录?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/logout" withParams:@{@"uid": @([Login curLoginUserID])} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
            if ([data[@"is"] intValue]) {
                [NSObject showHudTipStr:data[@"msg"]];
                [Login doLogout];
                AppDelegate *appledate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appledate setRootViewController];
            } else {
                [NSObject showHudTipStr:data[@"msg"]];
            }
        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:clearAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)cancelAttention {
    NSDictionary *params = @{@"houseid": @(_myHouse.houseid),
                             @"uid": @([Login curLoginUserID])
                             };
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/house/remove" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] integerValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

// 第一次进入输入邀请码关注房屋
- (void)inputInviteCode {
    InvitationCodeViewController *codeViewController = [[InvitationCodeViewController alloc] init];
    [self.navigationController setViewControllers:@[self.navigationController.viewControllers[0], codeViewController]];
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


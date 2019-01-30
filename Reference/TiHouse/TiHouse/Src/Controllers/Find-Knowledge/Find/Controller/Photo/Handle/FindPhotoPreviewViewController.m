//
//  FindPhotoPreviewViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoPreviewViewController.h"
#import "YAHMultiPhotoViewController.h"
#import "CreateSoulViewController.h"

#import "GBSharePan.h"
#import "PhotoFavorPan.h"
#import "FindPhotoLabelContainerView.h"
#import "FindPhotoHandleLabelView.h"

#import "ModelLabelRequest.h"
#import "NotificationConstants.h"
#import "FindAssemarcInfo.h"
#import "AssemarcRequest.h"

@implementation FindPhotoPreviewModel

@end

@interface FindPhotoPreviewViewController ()<
YAHMultiPhotoViewControllerDelegate,
GBSharePanDelegate,
PhotoFavorPanDelegate>

@property (nonatomic, strong) YAHMultiPhotoViewController *multiVC;

@property (nonatomic, strong) NSMutableArray<FindPhotoPreviewModel *> *photoList;
@property (nonatomic, assign) NSInteger showIndex;
@property (nonatomic, strong) FindPhotoLabelContainerView *labelContainerView;
@property (nonatomic, assign) BOOL showLabel; //是否显示标签  默认显示
@property (nonatomic, strong) FindAssemarcInfo *arcInfo;
//分享页面
@property (strong, nonatomic)  GBSharePan *sharePan;

@property (strong, nonatomic) PhotoFavorPan *photoFavorPan;
@property (nonatomic, strong) NSMutableArray<SoulFolderInfo *> *folderList;

@end

@implementation FindPhotoPreviewViewController

- (instancetype)initWithPhotoList:(NSArray<FindPhotoPreviewModel *> *)photoList showIndex:(NSInteger)showIndex arcInfo:(FindAssemarcInfo *)arcInfo{
    
    self = [super init];
    if (self) {
        _photoList = [NSMutableArray arrayWithArray:photoList];
        _showIndex = showIndex;
        _showLabel = YES;
        _folderList = [NSMutableArray arrayWithCapacity:1];
        _arcInfo = arcInfo;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createSoul) name:Notification_Create_Soul object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self reloadLabelsView];
}

#pragma mark - Action

- (void)actionBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionLabel {
    
    self.showLabel = !self.showLabel;
    if (self.showLabel) {
        [self reloadLabelsView];
    }else {
        [_labelContainerView clear];
    }
}

- (void)actionShare {
    FindAssemarcFileJA * findAssemarcFileJA = [self findAssemarcFileJAByIndex:self.showIndex];
    
    [self.sharePan showSharePanWithDelegate:self favorState:(findAssemarcFileJA.assemarcfileiscoll?1:0)];
    
}

- (void)createSoul {
    [self loadNetworkData];
}

- (void)setupUI {
    
    [self setupPhotoView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"find_back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kDevice_Is_iPhoneX?44:20);
        make.left.equalTo(self.view);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];

    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"find_photo_pshare"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(actionShare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kDevice_Is_iPhoneX?44:20);
        make.right.equalTo(self.view).offset(-10);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    
    UIButton *labelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [labelButton setImage:[UIImage imageNamed:@"find_photo_plabel"] forState:UIControlStateNormal];
    [labelButton addTarget:self action:@selector(actionLabel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:labelButton];
    [labelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kDevice_Is_iPhoneX?44:20);
        make.right.equalTo(shareButton.mas_left).offset(-10);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
}


- (void)setupPhotoView {
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *thumbPhotos = [NSMutableArray arrayWithCapacity:1];
    for (FindPhotoPreviewModel *photoModel in _photoList) {
        
        if (photoModel.image) {
            [photos addObject:[YAHMutiZoomPhoto photoWithImage:photoModel.image]];
        }else {
            [photos addObject:[YAHMutiZoomPhoto photoWithPhotoUrl:[NSURL URLWithString:photoModel.imageUrl]]];
        }
        
        [thumbPhotos addObject:[YAHMutiZoomPhoto photoWithImage:photoModel.image]];
    }
    YAHMultiPhotoViewController *vc = [[YAHMultiPhotoViewController alloc] initWithImage:photos thumbImage:photos originFrame:nil selectIndex:self.showIndex];
    vc.autoClickToClose = NO;
    vc.delegate = self;
    vc.view.backgroundColor = [UIColor colorWithRGBHex:0xE5E5E5];
    [self.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [self addChildViewController:vc];
    
    _multiVC = vc;
    
    [self.view addSubview:self.labelContainerView];
    [self reloadLabelsView];
}

- (void)loadNetworkData {
    WEAKSELF
    [ModelLabelRequest getSoulFolderWithHandler:^(id result, NSError *error) {
        if (!error) {
            weakSelf.folderList = result;
            
            if (self.photoFavorPan != nil) {
                self.photoFavorPan.floderArray = weakSelf.folderList;
            }
        }
    }];
}

- (void)reloadLabelsView {
    
    [_labelContainerView clear];
    self.labelContainerView.frame = [self.multiVC currentImageFrame];
    if (self.showIndex >= self.photoList.count) {
        return;
    }
    for (FindAssemarcFileTagJA *fileTag in self.photoList[self.showIndex].labelModelList) {
        FindPhotoHandleLabelView *view = [FindPhotoHandleLabelView createWithLabelModel:fileTag longPressBlock:nil clickBlock:^(FindPhotoHandleLabelView *labelView) {
            //点击标签， 跳转搜索界面
        } edit:NO];
        view.center = CGPointMake(self.labelContainerView.width*fileTag.assemarcfiletagwper, self.labelContainerView.height*fileTag.assemarcfiletaghper);
        [self.labelContainerView addSubview:view];
    }
}

#pragma mark - Setter and Getter

- (FindPhotoLabelContainerView *)labelContainerView {
    
    if (!_labelContainerView) {
        _labelContainerView = [[NSBundle mainBundle] loadNibNamed:@"FindPhotoLabelContainerView" owner:self options:nil].firstObject;
        _labelContainerView.clipsToBounds = YES;
    }
    return _labelContainerView;
}

#pragma mark - YAHMultiPhotoViewControllerDelegate

- (void)scrollMultiPhotoView:(YAHMultiPhotoViewController *)vc index:(NSInteger)index {
    
    self.showIndex = index;
    if (self.showLabel) {
        [self reloadLabelsView];
    }
}

- (void)didFinishLoadCurrentViewImage {
    
    if (self.showLabel) {
        [self reloadLabelsView];
    }
}

#pragma mark - 分享功能

- (GBSharePan*)sharePan
{
    if (!_sharePan)
    {
        _sharePan = [[GBSharePan alloc] init];
        _sharePan.delegate = self;
    }
    return _sharePan;
}
// share delegate
- (void)GBSharePanAction:(GBSharePan*)pan tag:(SHARE_TYPE)tag
{
    if (tag == SHARE_TYPE_Favor || tag == SHARE_TYPE_Favored) {
        [self clickFavor];
        
    } else if (tag == SHARE_TYPE_Download) {
        [self clickDownload];
        
    } else {
        [self clickShare:tag];
    }
    
}

- (void)GBSharePanActionCancel:(GBSharePan *)pan {
}

- (void)clickShare:(SHARE_TYPE)tag {
    
    NSString *platform;
    switch (tag)
    {
        case SHARE_TYPE_WECHAT:
        {
            platform = @"1";
        }
            break;
        case SHARE_TYPE_QQ:
        {
            platform = @"2";
        }
            break;
        case SHARE_TYPE_WEIBO:
        {
            platform = @"3";
        }
            break;
        default:
        {
            platform = @"4";
        }
            break;
    }
    
    @weakify(self)
    NSString *title = @"我在【有数啦】发布了有趣的图片，快来围观吧！";
    if (tag == SHARE_TYPE_WEIBO && self.arcInfo.linkshare.length > 0) {
        title = [NSString stringWithFormat:@"%@%@", title, self.arcInfo.linkshare];
    }
//    NSString *content = @"等你来哦~";
//    [[[UMShareManager alloc]init] webShare:tag title:title content:content
//                                       url:url image:nil complete:^(NSInteger state)
    FindAssemarcFileJA * findAssemarcFileJA = [self findAssemarcFileJAByIndex:self.showIndex];
    NSString *image = findAssemarcFileJA.assemarcfileurlshare;
    [[[UMShareManager alloc]init] imageShare:tag title:title content:nil
                                            url:nil image:image complete:^(NSInteger state)
     {
         @strongify(self)
         switch (state) {
             case 0: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享成功"];
                 [self.sharePan hide:^(BOOL ok){}];
                 FindAssemarcFileJA * findAssemarcFileJA = [self findAssemarcFileJAByIndex:self.showIndex];
                 [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(10),@"typeid":@(findAssemarcFileJA.assemarcfileid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                 }];
             }break;
                 
             case 1: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享失败"];
                 [self.sharePan hide:^(BOOL ok){}];
             }break;
             default:
                 break;
         }
     }];
}

- (void)clickFavor {
    FindAssemarcFileJA * findAssemarcFileJA = [self findAssemarcFileJAByIndex:self.showIndex];
    if (findAssemarcFileJA) {
        if (findAssemarcFileJA.assemarcfileiscoll) {
            [AssemarcRequest removeSinglePhotoFavor:findAssemarcFileJA.assemarcfileid handler:^(id result, NSError *error) {
                findAssemarcFileJA.assemarcfileiscoll = !findAssemarcFileJA.assemarcfileiscoll;
            }];
            
            [NSObject showHudTipStr:@"取消收藏"];
            [self.sharePan hide:^(BOOL success) {}];
        } else {
            [AssemarcRequest addSinglePhotoFavor:findAssemarcFileJA.assemarcfileid handler:^(id result, NSError *error) {
                findAssemarcFileJA.assemarcfileiscoll = !findAssemarcFileJA.assemarcfileiscoll;
            }];
            [NSObject showHudTipStr:@"收藏成功"];
            [self.sharePan hide:^(BOOL success) {}];
//            [self.sharePan hide:^(BOOL ok){
//                self.photoFavorPan = [PhotoFavorPan showPhotoFavorPanWithDelegate:self.folderList delegate:self vc:self];
//            }];
        }
    }
    
    
}

- (FindAssemarcFileJA *)findAssemarcFileJAByIndex:(NSInteger)index {
    if (self.arcInfo == nil || self.arcInfo.assemarcfileJA.count <= index) {
        return nil;
    }
    
    return self.arcInfo.assemarcfileJA[index];
}

- (void)clickDownload {
    if (self.showIndex >= self.photoList.count) {
        return;
    }
    
    FindPhotoPreviewModel * model = self.photoList[self.showIndex];
//    void (^block)(BOOL) = ^(BOOL success) {
//        WEAKSELF
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [NSObject hideHUDQuery];
//            if (success) {
//                [NSObject showHudTipStr:@"已下载到相册"];
//            } else {
//                [NSObject showHudTipStr:@"下载失败"];
//            }
//            
//            [weakSelf.sharePan hide:^(BOOL ok){}];
//        });
//    };
    
    [NSObject showHUDQueryStr:@"正在下载"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageUrl]];
    UIImage *image = [UIImage imageWithData:data]; // 取得图片
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    
    FindAssemarcFileJA * findAssemarcFileJA = [self findAssemarcFileJAByIndex:self.showIndex];
    [AssemarcRequest addDownloadCount:findAssemarcFileJA.assemarcfileid handler:^(id result, NSError *error) {
    }];
    
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
//    dispatch_async(globalQueue, ^{
//
//       
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageUrl]];
//        UIImage *image = [UIImage imageWithData:data]; // 取得图片
//        // 文件名称
//        NSString *name = [model.imageUrl lastPathComponent];
//        // 本地沙盒目录
//        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        // 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名
//        NSString *imageFilePath = [path stringByAppendingPathComponent:name];
//        // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
//        BOOL success = [UIImageJPEGRepresentation(image, 0.5) writeToFile:imageFilePath atomically:YES];
//        if (block){
//            block(success);
//        }
//    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [NSObject hideHUDQuery];
    if (!error) {
        [NSObject showHudTipStr:@"已下载到相册"];
    } else {
        [NSObject showHudTipStr:@"下载失败"];
    }
    
    [self.sharePan hide:^(BOOL ok){}];
}

#pragma mark - PhotoFavorPanDelegate

- (void)PhotoFavorPanAction:(PhotoFavorPan*)pan index:(NSInteger)index {
    FindAssemarcFileJA * findAssemarcFileJA = [self findAssemarcFileJAByIndex:self.showIndex];
    if (index >=  self.folderList.count || findAssemarcFileJA == nil) {
        return;
    }
    
    SoulFolderInfo *soulFolderInfo = self.folderList[index];
    [NSObject showHUDQueryStr:@"正在收藏灵感相册"];
    [AssemarcRequest moveToSoulFolder:findAssemarcFileJA.assemarcfileid soulFolderId:soulFolderInfo.soulfolderid handler:^(id result, NSError *error) {
        [NSObject hideHUDQuery];
        if (error) {
            [NSObject showHudTipStr:error.domain];
        } else {
            [NSObject showHudTipStr:self.view tipStr:@"收藏成功"];
            
            [pan hide:nil];
        }
    }];
    
}

- (void)PhotoFavorPanActionCancel:(PhotoFavorPan*)pan {
    
}

- (void)PhotoFavorPanActionAdd:(PhotoFavorPan*)pan {
    [self.navigationController pushViewController:[CreateSoulViewController new] animated:YES];
}

@end

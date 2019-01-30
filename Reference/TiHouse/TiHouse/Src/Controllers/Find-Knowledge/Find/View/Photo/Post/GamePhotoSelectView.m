//
//  GamePhotoView.m
//  GB_Football
//
//  Created by yahua on 2017/10/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GamePhotoSelectView.h"
#import "GameSinglePhotoView.h"
#import "FindPhotoPostCheckViewController.h"
#import "FindPhotoHandleViewController.h"
#import "FindCloudPhotoViewController.h"

#import "HXPhotoPicker.h"
#import "TOCropViewController.h"

#define kMaxPhotoCount 7
#define kPadding kRKBWIDTH(14)

@interface GamePhotoSelectView ()<
GameSinglePhotoViewDelegate,
HXAlbumListViewControllerDelegate,
HXCustomCameraViewControllerDelegate,
TOCropViewControllerDelegate,
FindCloudPhotoViewControllerDelegate
>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, strong) HXPhotoManager *manager;
@property (nonatomic, retain) TOCropViewController *cropController;

@property (nonatomic, strong) NSMutableArray<GameSinglePhotoView *> *photoViewLsit;

@end

@implementation GamePhotoSelectView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.photoViewLsit = [NSMutableArray arrayWithCapacity:1];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.addButton.size = CGSizeMake(kGameSinglePhotoViewWidth, kGameSinglePhotoViewHeight);
    [self layoutPhotoView];
}

- (void)setPhotoModelList:(NSMutableArray<FindPhotoHandleModel *> *)photoModelList {
    
    _photoModelList = photoModelList;
    for (FindPhotoHandleModel *model in _photoModelList) {
        [self addNewPhotoView:model.photoModel.thumbPhoto];
    }
}

#pragma mark - Action

- (IBAction)actionAdd:(id)sender {
    
    [self.superViewController hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
//    WEAKSELF
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
//    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf.superViewController hx_presentCustomCameraViewControllerWithManager:weakSelf.manager delegate:weakSelf];
//    }];
//    [takePhotoAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
//    UIAlertAction *ablumAction = [UIAlertAction actionWithTitle:@"从用户相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf.superViewController hx_presentAlbumListViewControllerWithManager:weakSelf.manager delegate:weakSelf];
//    }];
//    [ablumAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
//    UIAlertAction *cloudAction = [UIAlertAction actionWithTitle:@"从云记录选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//        FindCloudPhotoViewController *vc = [[FindCloudPhotoViewController alloc] init];
//        vc.maxCount = weakSelf.maxImageCount - weakSelf.photoModelList.count;;
//        vc.delegate = weakSelf;
//        HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
//        [weakSelf.viewController presentViewController:nav animated:YES completion:nil];
//    }];
//    [cloudAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
//
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
//    [action2 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
//
//    [alert addAction:takePhotoAction];
//    [alert addAction:ablumAction];
//    [alert addAction:cloudAction];
//    [alert addAction:action2];
//    [self.superViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Setter and Getter

- (HXPhotoManager *)manager
{
    _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    _manager.configuration.openCamera = YES;
    _manager.configuration.photoMaxNum = self.maxImageCount - self.photoModelList.count;;
    _manager.configuration.videoMaxNum = 0;
    _manager.configuration.maxNum = self.maxImageCount - self.photoModelList.count;;
    _manager.configuration.cellSelectedBgColor = [UIColor clearColor];
    _manager.configuration.themeColor = kRKBNAVBLACK;
    _manager.configuration.singleSelected = NO;//是否单选
    
    return _manager;
}

#pragma mark - HXAlbumListViewControllerDelegate

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    
    @weakify(self)
    FindPhotoHandleViewController *vc = [[FindPhotoHandleViewController alloc] initWithPhotoList:photoList doneBlock:^(NSArray<FindPhotoHandleModel *> *photoModelList) {
        
        @strongify(self)
        [self addNewFindPhotoHandleModels:photoModelList];
    }];
    [self.superViewController.navigationController pushViewController:vc animated:NO];
}

#pragma mark - HXCustomCameraViewControllerDelegate

-(void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model{
    
    _cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.previewPhoto];
    _cropController.aspectRatioLockEnabled= NO;
    _cropController.resetAspectRatioEnabled = NO;
    _cropController.delegate = self;
    _cropController.doneButtonTitle = @"完成";
    _cropController.cancelButtonTitle = @"取消";
    _cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetOriginal;
    
    [self.superViewController.navigationController pushViewController:_cropController animated:NO];
}

#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    HXPhotoModel *photoModel = [[HXPhotoModel alloc] init];
    photoModel.thumbPhoto = image;
    photoModel.previewPhoto = image;
    @weakify(self)
    FindPhotoHandleViewController *vc = [[FindPhotoHandleViewController alloc] initWithPhotoList:@[photoModel] doneBlock:^(NSArray<FindPhotoHandleModel *> *photoModelList) {
        
        @strongify(self)
        [self addNewFindPhotoHandleModels:photoModelList];
    }];
    [self.superViewController.navigationController pushViewController:vc animated:NO];
}

#pragma mark - FindCloudPhotoViewControllerDelegate

- (void)findCloudPhotoViewControllerDidDone:(NSArray<FindCloudCellModel *> *)selectModels {
    
    NSMutableArray *photoList = [NSMutableArray arrayWithCapacity:1];
    for (FindCloudCellModel *cellModel in selectModels) {
        HXPhotoModel *photoModel = [[HXPhotoModel alloc] init];
        photoModel.thumbPhoto = cellModel.image;
        photoModel.previewPhoto = cellModel.image;
        [photoList addObject:photoModel];
    }
    
    @weakify(self)
    FindPhotoHandleViewController *vc = [[FindPhotoHandleViewController alloc] initWithPhotoList:[photoList copy] doneBlock:^(NSArray<FindPhotoHandleModel *> *photoModelList) {
        
        @strongify(self)
        [self addNewFindPhotoHandleModels:photoModelList];
    }];
    [self.viewController.navigationController pushViewController:vc animated:NO];
}


#pragma mark - GameSinglePhotoViewDelegate

- (void)clickWithgameSinglePhotoView:(GameSinglePhotoView *)view {
    
    NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:1];
    for (FindPhotoHandleModel *photoModel in _photoModelList) {
        
        [tmpList addObject:photoModel];
    }
 
    @weakify(self)
    FindPhotoPostCheckViewController *vc = [[FindPhotoPostCheckViewController alloc] initWithPhotoList:[tmpList copy] selectIndex:view.tag deleteBlock:^(NSInteger deleteIndex) {
        
        @strongify(self)
        GameSinglePhotoView *photoView = self.photoViewLsit[deleteIndex];
        [photoView removeFromSuperview];
        [self.photoViewLsit removeObjectAtIndex:deleteIndex];
        if (deleteIndex<self.photoModelList.count) {
            [self.photoModelList removeObjectAtIndex:deleteIndex];
        }
        [self layoutPhotoView];
    }];
    [self.superViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)addNewPhotoView:(UIImage *)image {
    
    GameSinglePhotoView *photoView = [[NSBundle mainBundle] loadNibNamed:@"GameSinglePhotoView" owner:self options:nil].firstObject;
    photoView.tag = self.photoViewLsit.count;
    photoView.delegate = self;
    [photoView setImage:image];
    [self addSubview:photoView];
    [self.photoViewLsit addObject:photoView];
    [self layoutPhotoView];
}

- (void)layoutPhotoView {
    
    //view tag 重新赋值
    NSInteger tag = 0;
    for (GameSinglePhotoView *view in self.photoViewLsit) {
        view.tag = 0;
        tag++;
    }
    //取整
    NSInteger sections = ceil((self.photoViewLsit.count)/4);
    //取余
    NSInteger complementation = self.photoViewLsit.count%4;
    self.addButton.left = kPadding + complementation*(kGameSinglePhotoViewWidth+kPadding);
    self.addButton.top = kPadding + sections*(kGameSinglePhotoViewHeight+kPadding);

    self.height = self.addButton.bottom + kPadding;
    self.contentViewHeightConstraint.constant = self.height;
    
    CGFloat posY = kPadding;
    for (NSInteger i=0; i<=sections; i++) {
        CGFloat posX = kPadding;
        for (NSInteger j=0; j<4; j++) {
            NSInteger index = j+i*4;
            if (index>=self.photoViewLsit.count) {
                break;
            }
            GameSinglePhotoView *view = self.photoViewLsit[index];
            view.tag = index;
            view.frame = CGRectMake(posX, posY, kGameSinglePhotoViewWidth, kGameSinglePhotoViewWidth);
            posX += view.width+kPadding;
        }
        posY += kPadding + kGameSinglePhotoViewHeight;
    }
    
    self.addButton.hidden = (self.photoViewLsit.count >= self.maxImageCount);
    
    if ([_delegate respondsToSelector:@selector(GamePhotoSelectViewFrameChange)]) {
        [_delegate GamePhotoSelectViewFrameChange];
    }
}

- (void)addNewFindPhotoHandleModels:(NSArray<FindPhotoHandleModel *> *)photoModelList {
    
    [self.photoModelList addObjectsFromArray:photoModelList];
    for (FindPhotoHandleModel *model in photoModelList) {
        [self addNewPhotoView:model.photoModel.thumbPhoto];
    }
    [self.superViewController.navigationController popToViewController:self.superViewController animated:YES];
}


@end

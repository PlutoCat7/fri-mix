//
//  GamePhotoView.m
//  GB_Football
//
//  Created by yahua on 2017/10/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GamePhotoSelectView.h"
#import "GBActionSheet.h"
#import "GameSinglePhotoView.h"
#import "YAHMultiPhotoViewController.h"
#import "HKJCamera.h"
#import "YAHImagePickerRootViewController.h"
#import "YAHPhotoTools.h"

#import "MatchRequest.h"

#define kMaxPhotoCount 7

@interface GamePhotoSelectView ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
GBActionSheetDelegate,
GameSinglePhotoViewDelegate,
YAHMultiPhotoViewControllerDelegate
>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *headeraView;

//静态UI
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic, strong) NSMutableArray<GameSinglePhotoView *> *photoViewLsit;

@property (nonatomic, strong) NSMutableArray<MatchGamePhotoUploadObject *> *uploadPhotoObjectList;

@end

@implementation GamePhotoSelectView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.photoViewLsit = [NSMutableArray arrayWithCapacity:1];
    self.uploadPhotoObjectList = [NSMutableArray arrayWithCapacity:1];
    
    self.titleLabel.text = LS(@"game.complete.photo.title");
    self.descLabel.text = LS(@"game.complete.photo.desc");
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.headerViewHeightConstraint.constant = 28*kAppScale;
    self.addButton.size = CGSizeMake(55*kAppScale, 55*kAppScale);
    [self layoutPhotoView];
}

- (NSArray<MatchGamePhotoUploadObject *> *)getMatchImageUploadObjectList {
    
    return [self.uploadPhotoObjectList copy];
}

#pragma mark - Action

- (IBAction)actionAdd:(id)sender {
    
    GBActionSheet *actionSheet = [GBActionSheet showWithTitle:LS(@"personal.hint.choose.method") button1:LS(@"personal.hint.take.photo") button2:LS(@"personal.hint.choose.photo") cancel:LS(@"common.btn.cancel")];
    actionSheet.delegate = self;
}

#pragma mark GBActionSheetDelegate

- (void)GBActionSheet:(GBActionSheet *)actionSheet index:(NSInteger)index {
    
    if (index == 0) {
        if (![LogicManager checkIsOpenCamera]) {
            return;
        }
        HVideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
        ctrl.takeType = HVideoTakeType_Photo;
        @weakify(self)
        ctrl.takeBlock = ^(id item) {
            if ([item isKindOfClass:[UIImage class]]) {
                @strongify(self)
                //图片
                [self addNewPhotoView:item];
                MatchGamePhotoUploadObject *object = [[MatchGamePhotoUploadObject alloc] init];
                object.type = 0;
                object.largeImage = item;
                [self.uploadPhotoObjectList addObject:object];
            } else {
                //视频url
            }
        };
        [self.superViewController presentViewController:ctrl animated:YES completion:nil];
    }else if (index == 1){
        if (![LogicManager checkIsOpenAblum]) {
            return;
        }
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        YAHImagePickerRootViewController *picker = [[YAHImagePickerRootViewController alloc] init];
        picker.maximumNumberOfSelection = kMaxPhotoCount - self.uploadPhotoObjectList.count;
        picker.imagePickerFilterType = YHImagePickerFilterTypePhotos;
        picker.dismissBlock = ^(YAHImagePickerRootViewController *vc) {
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [vc dismissViewControllerAnimated:YES completion:nil];
        };
        @weakify(self)
        picker.sucessBlock = ^(YAHImagePickerRootViewController *vc, NSArray<YAHPhotoModel *> *assets) {
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [vc dismissViewControllerAnimated:YES completion:nil];
            @strongify(self)
            for (YAHPhotoModel *model in assets) {
                MatchGamePhotoUploadObject *object = [[MatchGamePhotoUploadObject alloc] init];
                object.type = 0;
                object.thumImage = model.thumbImage;
                object.photoAsset = model.asset;
                [self.uploadPhotoObjectList addObject:object];
                
                [self addNewPhotoView:model.thumbImage];
            }
        };
        picker.failureBlock = ^(YAHImagePickerRootViewController *vc, NSError *error) {
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [vc dismissViewControllerAnimated:YES completion:nil];
        };
        [self.superViewController presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark GameSinglePhotoViewDelegate

- (void)deleteWithgameSinglePhotoView:(GameSinglePhotoView *)view {
    
    NSInteger index = view.tag;
    GameSinglePhotoView *photoView = self.photoViewLsit[index];
    [photoView removeFromSuperview];
    [self.photoViewLsit removeObjectAtIndex:index];
    if (index<self.uploadPhotoObjectList.count) {
        [self.uploadPhotoObjectList removeObjectAtIndex:index];
    }
    
    [self layoutPhotoView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaCountChange:view:)]) {
        [self.delegate mediaCountChange:NO view:self];
    }
}

- (void)clickWithgameSinglePhotoView:(GameSinglePhotoView *)view {
    
    NSInteger index = view.tag;
    NSMutableArray *frameList = [NSMutableArray arrayWithCapacity:self.photoViewLsit.count];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *thumbPhotos = [NSMutableArray arrayWithCapacity:1];
    for (GameSinglePhotoView *photoView in self.photoViewLsit) {
        CGRect toViewFrame = [photoView convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
        NSValue *value = [NSValue valueWithCGRect:toViewFrame];
        [frameList addObject:value];
        

        NSInteger index = [self.photoViewLsit indexOfObject:photoView];
        MatchGamePhotoUploadObject *object = [self.uploadPhotoObjectList objectAtIndex:index];
        if (!object.largeImage) {
            [photos addObject:[YAHMutiZoomPhoto photoWithPhotoAsset:object.photoAsset]];
        }else {
            [photos addObject:[YAHMutiZoomPhoto photoWithImage:object.largeImage]];
        }
        [thumbPhotos addObject:[YAHMutiZoomPhoto photoWithImage:photoView.image]];
    }
    YAHMultiPhotoViewController *vc = [[YAHMultiPhotoViewController alloc] initWithImage:photos thumbImage:photos originFrame:frameList selectIndex:index];
    vc.delegate = self;
    [self.superViewController presentViewController:vc animated:NO completion:nil];
}

#pragma mark - YAHMultiPhotoViewControllerDelegate

- (void)willHideMultiPhotoView:(YAHMultiPhotoViewController *)vc currentIndex:(NSInteger)cuurentIndex {
    
    NSLog(@"willHideMultiPhotoView cuurentIndex: %td",cuurentIndex);
}

- (void)didHideMultiPhotoView:(YAHMultiPhotoViewController *)vc currentIndex:(NSInteger)cuurentIndex {
    
    [vc dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"didHideMultiPhotoView cuurentIndex: %td",cuurentIndex);
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaCountChange:view:)]) {
        [self.delegate mediaCountChange:YES view:self];
    }
    
}

- (void)layoutPhotoView {
    
    //view tag 重新赋值
    NSInteger tag = 0;
    for (GameSinglePhotoView *view in self.photoViewLsit) {
        view.tag = 0;
        tag++;
    }
    
    //取整
    NSInteger sections = ceil((self.photoViewLsit.count+1)*0.2);
    //取余
    NSInteger complementation = self.photoViewLsit.count%5;
    self.addButton.left = 18*kAppScale + complementation*kGameSinglePhotoViewWidth;
    self.addButton.top = self.headeraView.height + 12.5*kAppScale + ((sections>0)?((sections-1)*kGameSinglePhotoViewHeight):0);

    self.height = self.addButton.bottom + 12.5*kAppScale;
    self.contentViewHeightConstraint.constant = self.height;
    
    sections = ceil(self.photoViewLsit.count*0.2); //单行最多显示5个
    for (NSInteger i=0; i<sections; i++) {
        CGFloat posX = 18*kAppScale;
        for (NSInteger j=0; j<5; j++) {
            NSInteger index = j+i*5;
            if (index>=self.photoViewLsit.count) {
                break;
            }
            GameSinglePhotoView *view = self.photoViewLsit[index];
            view.tag = index;
            view.frame = CGRectMake(posX, self.headeraView.height + i*kGameSinglePhotoViewHeight, kGameSinglePhotoViewWidth, kGameSinglePhotoViewWidth);
            posX += view.width;
        }
    }
    
    self.addButton.hidden = (self.photoViewLsit.count >= self.maxImageCount);
}

@end

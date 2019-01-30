//
//  GameVideoSelectView.m
//  GB_Football
//
//  Created by yahua on 2017/12/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GameVideoSelectView.h"
#import "GBActionSheet.h"
#import "GameSinglePhotoView.h"
#import "HKJCamera.h"
#import "YAHImagePickerRootViewController.h"
#import "YAHPhotoTools.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "MatchRequest.h"

@interface GameVideoSelectView ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
GBActionSheetDelegate,
GameSinglePhotoViewDelegate
>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *headeraView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic, strong) NSMutableArray<GameSinglePhotoView *> *photoViewLsit;
@property (nonatomic, strong) NSMutableArray<NSURL *> *localVideoUrlList;  //本地视频url

@end

@implementation GameVideoSelectView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.photoViewLsit = [NSMutableArray arrayWithCapacity:1];
    self.localVideoUrlList = [NSMutableArray arrayWithCapacity:1];
    self.maxVideoCount = 1;
    
    self.titleLabel.text = LS(@"game.complete.video.title");
    self.descLabel.text = LS(@"game.complete.video.desc");
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.headerViewHeightConstraint.constant = 28*kAppScale;
    self.addButton.size = CGSizeMake(55*kAppScale, 55*kAppScale);
    [self layoutPhotoView];
}

- (NSArray<MatchGamePhotoUploadObject *> *)getMatchVideoUploadObjectList {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (NSURL *url in self.localVideoUrlList) {
        MatchGamePhotoUploadObject *object = [[MatchGamePhotoUploadObject alloc] init];
        object.type = 1;
        object.videoUrl = url;
        
        [result addObject:object];
    }
    
    return [result copy];
}

#pragma mark - Action

- (IBAction)actionAdd:(id)sender {
    
    GBActionSheet *actionSheet = [GBActionSheet showWithTitle:LS(@"game.complete.select.video.title") button1:LS(@"game.complete.shoot") button2:LS(@"personal.hint.choose.photo") cancel:LS(@"common.btn.cancel")];
    actionSheet.delegate = self;
}

#pragma mark GBActionSheetDelegate

- (void)GBActionSheet:(GBActionSheet *)actionSheet index:(NSInteger)index {
    
    if (index == 0) {
        if (![LogicManager checkIsOpenCamera]) {
            return;
        }
        HVideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
        ctrl.HSeconds = 10;//设置可录制最长时间
        ctrl.takeType = HVideoTakeType_Video;
        ctrl.takeBlock = ^(id item) {
            if ([item isKindOfClass:[UIImage class]]) {
                //图片
            } else {
                //视频url
                NSURL *videoURL = item;
                [self addVideoWithUrl:videoURL];
            }
        };
        [self.superViewController presentViewController:ctrl animated:YES completion:nil];
    }else if (index == 1){
        if (![LogicManager checkIsOpenAblum]) {
            return;
        }
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        YAHImagePickerRootViewController *picker = [[YAHImagePickerRootViewController alloc] init];
        picker.maxVideoDuration = 10;
        picker.maximumNumberOfSelection = 1;
        picker.imagePickerFilterType = YHImagePickerFilterTypeVideos;
        picker.dismissBlock = ^(YAHImagePickerRootViewController *vc) {
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [vc dismissViewControllerAnimated:YES completion:nil];
        };
        picker.sucessBlock = ^(YAHImagePickerRootViewController *vc, NSArray<YAHPhotoModel *> *assets) {
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [vc dismissViewControllerAnimated:YES completion:nil];

            [self addVideoWithUrl:assets.firstObject.videoUrl];
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
    if (self.localVideoUrlList.count>index) {
        [self.localVideoUrlList removeObjectAtIndex:index];
    }
    if (self.localVideoUrlList.count > index) {
        [self.localVideoUrlList removeObjectAtIndex:index];
    }
    
    [self layoutPhotoView];
}

- (void)clickWithgameSinglePhotoView:(GameSinglePhotoView *)view {
    
    NSInteger index = [self.photoViewLsit indexOfObject:view];
    NSURL *url = [self.localVideoUrlList objectAtIndex:index];
    HAVPlayer *player = [[HAVPlayer alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds withShowInView:[UIApplication sharedApplication].keyWindow url:url];
    player.backgroundColor = [UIColor blackColor];
    player.isShowCloseButton = YES;
    [player startPlayer];
}

#pragma mark - Setter and Getter

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
    self.addButton.hidden = (self.photoViewLsit.count >= self.maxVideoCount);
}

- (void)addVideoWithUrl:(NSURL *)assetUrl {
    
    [self.localVideoUrlList addObject:assetUrl];
    UIImage *image = [YAHPhotoTools getCoverImage:assetUrl atTime:0 isKeyImage:YES];
    [self addNewPhotoView:image];
}

@end

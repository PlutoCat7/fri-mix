//
//  FindPhotoAddLabelAlertView.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoAddLabelAlertView.h"
#import "FindPhotoLabelAddViewController.h"
#import "FindPhotoLabelTagViewController.h"
#import "FindPhotoLabelStyleViewController.h"

@interface FindPhotoAddLabelAlertView ()

@property (weak, nonatomic) IBOutlet UIView *thingView;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UIView *styleView;
@property (weak, nonatomic) IBOutlet UIView *tagDisableView;
@property (weak, nonatomic) IBOutlet UIView *styleDisableView;

@property (nonatomic, weak) UINavigationController *nav;

@property (nonatomic, copy) void(^doneBlock)(FindPhotoThingInfo *info, NSArray<FindPhotoLabelInfo *> *labelList, NSArray<FindPhotoStyleInfo *> *styleList);

@end

@implementation FindPhotoAddLabelAlertView

+ (instancetype)showWithNavigation:(UINavigationController *)nav doneBlock:(void(^)(FindPhotoThingInfo *info, NSArray<FindPhotoLabelInfo *> *labelList, NSArray<FindPhotoStyleInfo *> *styleList))doneBlock {
    
    FindPhotoAddLabelAlertView *view = [[NSBundle mainBundle] loadNibNamed:@"FindPhotoAddLabelAlertView" owner:self options:nil].firstObject;
    view.frame = [UIApplication sharedApplication].keyWindow.bounds;
    view.nav = nav;
    view.doneBlock = doneBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    return view;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.thingView.layer.cornerRadius = self.thingView.width/2;
        self.tagView.layer.cornerRadius = self.tagView.width/2;
        self.styleView.layer.cornerRadius = self.styleView.width/2;
    });
}

- (IBAction)actionBg:(id)sender {
    
    if (_doneBlock) {
        _doneBlock(nil, nil, nil);
    }
    [self removeFromSuperview];
}

- (IBAction)actionThing:(id)sender {
    
    WEAKSELF
    FindPhotoLabelAddViewController *thingVC = [[FindPhotoLabelAddViewController alloc] initWithDoneBlock:^(NSString *thingName, NSString *brand, NSString *price) {
        
        if (weakSelf.doneBlock) {
            FindPhotoThingInfo *info = [[FindPhotoThingInfo alloc] init];
            info.thingname = thingName;
            info.thingbrand = brand;
            info.thingprice = price;
            weakSelf.doneBlock(info, nil, nil);
        }
    }];
    [self.nav pushViewController:thingVC animated:YES];
    [self removeFromSuperview];
}

- (IBAction)actionTag:(id)sender {
    
    WEAKSELF
    FindPhotoLabelTagViewController *vc = [[FindPhotoLabelTagViewController alloc] initWithSelectStyleList:nil doneBlock:^(NSArray<FindPhotoLabelInfo *> *selectStyleList) {
        if (weakSelf.doneBlock) {
            weakSelf.doneBlock(nil, selectStyleList, nil);
        }
    }];
    [self.nav pushViewController:vc animated:YES];
    [self removeFromSuperview];
}

- (IBAction)actionStyle:(id)sender {
    
    WEAKSELF
    FindPhotoLabelStyleViewController *vc = [[FindPhotoLabelStyleViewController alloc] initWithSelectStyleList:nil doneBlock:^(NSArray<FindPhotoStyleInfo *> *selectStyleList) {
        if (weakSelf.doneBlock) {
            weakSelf.doneBlock(nil, nil, selectStyleList);
        }
    }];
    [self.nav pushViewController:vc animated:YES];
    [self removeFromSuperview];
}

- (void)setIsSpaceVaild:(BOOL)isSpaceVaild {
    
    self.tagDisableView.hidden = isSpaceVaild;
}

- (void)setIsStyleVaild:(BOOL)isStyleVaild {
    
    self.styleDisableView.hidden = isStyleVaild;
}

@end

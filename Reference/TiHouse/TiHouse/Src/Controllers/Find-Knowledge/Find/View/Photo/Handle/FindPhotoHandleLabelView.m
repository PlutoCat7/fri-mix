//
//  FindPhotoHandleLabelView.m
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoHandleLabelView.h"
#import "FindAssemarcInfo.h"

@interface FindPhotoHandleLabelView ()

@property (nonatomic, strong) UIButton *swipeButton;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;

@property (nonatomic, strong) FindAssemarcFileTagJA *model;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation FindPhotoHandleLabelView

+ (instancetype)createWithLabelModel:(FindAssemarcFileTagJA *)model longPressBlock:(void(^)(FindPhotoHandleLabelView *labelView))longPressBlock clickBlock:(void(^)(FindPhotoHandleLabelView *labelView))clickBlock edit:(BOOL)edit {
    
    FindPhotoHandleLabelView *view = [[FindPhotoHandleLabelView alloc] initWithFrame:CGRectZero];
    view.model = model;
    view.isEdit = edit;
    view.dragEnable = edit;
    
    NSString *label1String = model.assemarcfiletagcontent;
    NSString *label2String = [model combineBrandAndPrice];
    view.view1 = [view createViewWithText:label1String tag:model.assemarcfiletagtype==1];
    view.view2 = [view createViewWithText:label2String tag:NO];
    CGFloat spacePadding = kRKBWIDTH(2);
    CGFloat buttonWidth = 30;
    view.swipeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [view.swipeButton setImage:[UIImage imageNamed:@"find_photo_handle_swipe"] forState:UIControlStateNormal];
    view.swipeButton.size = CGSizeMake(buttonWidth, view.view1.height+(view.view2?view.view2.height+spacePadding:0));
    [view.swipeButton addTarget:view action:@selector(actionSwpie) forControlEvents:UIControlEventTouchUpInside];
    view.swipeButton.enabled = edit;
    
    //布局
    [view addSubview:view.view1];
    [view addSubview:view.view2];
    [view addSubview:view.swipeButton];
    CGFloat labelWidht = MAX(view.view1.width, view.view2.width);
    CGFloat viewWidth = view.swipeButton.width*2 + labelWidht;
    CGFloat viewHeight = view.swipeButton.height;
    if (model.assemarcfiletagside == 0) {
        view.swipeButton.left = 0;
        [view.swipeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        view.view1.left = view.swipeButton.width;
    }else {
        view.swipeButton.right = viewWidth;
        [view.swipeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
        view.view1.right = view.swipeButton.left;
    }
    
    if (view.view2) {
        view.view2.left = view.swipeButton.width;
        view.view2.top = view.view1.height + spacePadding;
    }
    view.size = CGSizeMake(viewWidth, viewHeight);
    
    //拖动长按回调
    view.longPressViewBlock = ^(WMDragView *dragView) {
        if (longPressBlock) {
            longPressBlock(dragView);
        }
    };
    
    view.duringDragBlock = ^(WMDragView *dragView) {
        model.assemarcfiletagwper = dragView.centerX/dragView.superview.width;
        model.assemarcfiletaghper = dragView.centerY/dragView.superview.height;
    };
    view.endDragBlock = ^(WMDragView *dragView) {
        model.assemarcfiletagwper = dragView.centerX/dragView.superview.width;
        model.assemarcfiletaghper = dragView.centerY/dragView.superview.height;
    };
    view.clickDragViewBlock = ^(WMDragView *dragView) {
        if (clickBlock) {
            clickBlock(dragView);
        }
    };
    
    return view;
}

- (void)actionSwpie {
    
    if (self.model.assemarcfiletagside == 0) {
        self.model.assemarcfiletagside = 1;
        self.swipeButton.right = self.width;
        [self.swipeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
        self.view1.right = self.swipeButton.left;
    }else {
        self.model.assemarcfiletagside = 0;
        self.swipeButton.left = 0;
        [self.swipeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        self.view1.left = self.swipeButton.width;
    }
}

- (UIView *)createViewWithText:(NSString *)text tag:(BOOL)isTag {
    
    if (!text ||[text isEmpty]) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    CGFloat leftPadding = kRKBWIDTH(5);
    CGFloat left = leftPadding;
    CGFloat height = kRKBWIDTH(20);
    if (isTag) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_photo_handle_thing"]];
        imageView.frame = CGRectMake(left, (height - 10)/2, 10, 10);
        [view addSubview:imageView];
        
        left += leftPadding +imageView.width;
    }
    
    CGFloat labelWidth = [text getWidthWithFont:[UIFont systemFontOfSize:11.0f] constrainedToSize:CGSizeMake(200, 200)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:11.0f];
    label.frame = CGRectMake(left, 0, labelWidth, height);
    [view addSubview:label];
    
    view.size = CGSizeMake(left+label.width+leftPadding, height);
    view.masksToBounds = YES;
    view.cornerRadius = 3;
    
    return view;
}

@end

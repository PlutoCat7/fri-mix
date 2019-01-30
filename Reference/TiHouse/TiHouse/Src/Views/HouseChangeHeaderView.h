//
//  HouseChangeHeaderView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXPhotoManager;
@interface HouseChangeHeaderView : UIView<UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) UITextView *TextView;
@property (strong, nonatomic) UICollectionView *mediaView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (nonatomic, retain) HouseTweet *tweet;
@property (nonatomic, retain) UIViewController *controller;

@property (nonatomic ,copy) NSString *content;
@property (nonatomic, copy) void(^HeightBlcok)(HouseChangeHeaderView *header, CGFloat height);
@property (nonatomic, copy) void(^SelectedImages)(NSMutableArray *arr);
@property (nonatomic, copy) void(^TextViewEditing)(NSString *content);
@property (nonatomic, copy) void(^UPHeaderViewHeight)(CGFloat height);
@property (nonatomic, copy) void(^videoClick)(void);

-(instancetype)initWihtManager:(HXPhotoManager *)manager;
@property (nonatomic, assign) BOOL isEditing;

@end


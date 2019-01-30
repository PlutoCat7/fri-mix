//
//  XWDatePhotoPreviewBottomView.h
//  微博照片选择
//
//  Created by 洪欣 on 2017/10/16.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XWDatePhotoPreviewBottomView, TweetImage;
@protocol XWDatePhotoPreviewBottomViewDelegate <NSObject>
@optional
- (void)datePhotoPreviewBottomViewDidItem:(TweetImage *)model currentIndex:(NSInteger)currentIndex beforeIndex:(NSInteger)beforeIndex;
- (void)datePhotoPreviewBottomViewDidDone:(XWDatePhotoPreviewBottomView *)bottomView;
- (void)datePhotoPreviewBottomViewDidEdit:(XWDatePhotoPreviewBottomView *)bottomView;
@end

@interface XWDatePhotoPreviewBottomView : UIView
@property (strong, nonatomic) UIView *bgView;
@property (weak, nonatomic) id<XWDatePhotoPreviewBottomViewDelegate> delagate;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (assign, nonatomic) NSInteger selectCount;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) BOOL hideEditBtn;
@property (assign, nonatomic) BOOL enabled;
@property (assign, nonatomic) BOOL outside;
@property (strong, nonatomic) UIButton *doneBtn;

- (void)insertModel:(TweetImage *)model currentModelIndex:(NSInteger )index;
- (void)deleteModel:(TweetImage *)model;
- (instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)modelArray;
- (void)deselected;
- (void)deselectedWithIndex:(NSInteger)index;

- (void)reloadData;
@end


@interface XWDatePhotoPreviewBottomViewCell : UICollectionViewCell
@property (strong, nonatomic) TweetImage *model;
@property (strong, nonatomic) UIColor *selectColor;
- (void)cancelRequest;
@end

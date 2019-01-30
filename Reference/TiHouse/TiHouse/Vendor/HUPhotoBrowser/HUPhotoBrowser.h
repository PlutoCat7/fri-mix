//
//  HUPhotoBrowser.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseTweet.h"
typedef void(^DismissBlock)(UIImage*image, NSInteger index);
typedef void(^EditBlock)(UIImage*image, NSInteger index);
typedef void(^Dismiss)(void);

@interface HUPhotoBrowser : UIView

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 * @param index        点击的图片在所有要展示图片中的位置
 */

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings atIndex:(NSInteger)index;

/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param index        点击的图片在所有要展示图片中的位置
 */

+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images atIndex:(NSInteger)index;

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param dismiss      photoBrowser消失的回调
 */
+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block;

/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param dismiss      photoBrowser消失的回调
 */
+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block;

+ (instancetype)showCollectionView:(UICollectionView *)collectionView withImages:(NSMutableArray *)images placeholderImage:(TweetImage *)image atIndex:(NSInteger)index Animation:(BOOL)animation dismiss:(DismissBlock)block;

+ (instancetype)showMoveCollectionView:(UICollectionView *)collectionView withImages:(NSMutableArray *)images placeholderImage:(TweetImage *)image atIndex:(NSInteger)index Animation:(BOOL)animation dismiss:(DismissBlock)block;

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, copy) EditBlock edit;
@property (nonatomic, copy) Dismiss dismiss;

@end

@interface HUPhotoBrowserBottom : UIView

@property (nonatomic, strong) NSMutableArray *images;

@end

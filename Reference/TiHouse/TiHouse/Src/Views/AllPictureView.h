//
//  AllPictureView.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllPictureViewDelegate<NSObject>

- (void)AddToSoulFolder;
- (void)cancelCollection;

@end

@interface AllPictureView : UIView

- (void)reloadSelectedPictures:(NSInteger)count; // 更新选中情况下的图片数量
@property (nonatomic, assign) id<AllPictureViewDelegate> delegate;

@end

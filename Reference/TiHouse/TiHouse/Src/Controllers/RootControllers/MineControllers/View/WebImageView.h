//
//  WebImageView.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebImageView : UIImageView

- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder;

@end

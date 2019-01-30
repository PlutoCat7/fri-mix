//
//  HouseChangeImageCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Folder;
@interface FileCell : UICollectionViewCell

@property (nonatomic, retain) UIImageView *imageV;
@property (nonatomic, retain) UITextField *title;
@property (nonatomic, retain) Folder *folder;
@property (nonatomic, assign ) BOOL eidt;
@property (nonatomic, copy ) void(^titleChange)(FileCell *cell);
@property (nonatomic, copy ) void(^deleFile)(FileCell *cell);

@end

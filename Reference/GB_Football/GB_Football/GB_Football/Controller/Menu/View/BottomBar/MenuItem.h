//
//  MenuItem.h
//  GB_Football
//
//  Created by Pizza on 2016/11/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tipImageIcon;
@property (strong,nonatomic) NSString *imageName;
@property (assign,nonatomic) BOOL isSelect;
@end

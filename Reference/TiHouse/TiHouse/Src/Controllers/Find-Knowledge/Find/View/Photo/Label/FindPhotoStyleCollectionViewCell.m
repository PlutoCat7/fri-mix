//
//  FindPhotoStyleCollectionViewCell.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoStyleCollectionViewCell.h"

@interface FindPhotoStyleCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FindPhotoStyleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshWithName:(NSString *)name isSelect:(BOOL)isSelect {
    
    self.backgroundColor = isSelect?[UIColor colorWithRGBHex:0xFBEF85]:[UIColor colorWithRGBHex:0xf5f5f5];
    self.nameLabel.text = name;
}

@end

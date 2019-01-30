//
//  MenuItem.m
//  GB_Football
//
//  Created by Pizza on 2016/11/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MenuItem.h"
#import "UIImage+RTTint.h"

@interface MenuItem()
@property (strong,nonatomic) IBOutlet UIImageView *imageIcon;

@end

@implementation MenuItem

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

-(void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    self.imageIcon.image = [UIImage imageNamed:imageName];
}

-(void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (_isSelect == YES)
    {
        self.imageIcon.image = [self.imageIcon.image rt_tintedImageWithColor:[UIColor greenColor] level:1.0];
    }
    else
    {
        self.imageIcon.image = [self.imageIcon.image rt_tintedImageWithColor:[UIColor colorWithHex:0x585858] level:1.0];
    }
}

-(void)setup
{

}

@end

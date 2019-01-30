//
//  GBFieldCell.m
//  GB_Football
//
//  Created by Pizza on 16/8/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFieldCell.h"

@interface GBFieldCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIView *leftBack;
@property (weak, nonatomic) IBOutlet UIView *rightBack;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation GBFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCourtName:(NSString *)name address:(NSString *)address {
    
    self.nameLabel.text = name;
    self.adressLabel.text = address;
}

-(void)setIsNew:(BOOL)isNew
{
    _isNew = isNew;
    if (_isNew) {
        [UIView animateWithDuration:0 animations:^{
            self.leftBack.alpha     = _isNew?1.0:0;
            self.rightBack.alpha    = _isNew?1.0:0;
            self.logo.alpha         = _isNew?1.0:0;
            self.nameLabel.textColor    = _isNew?[UIColor blackColor]:[UIColor whiteColor];
            self.adressLabel.textColor  = _isNew?[UIColor blackColor]:[UIColor colorWithHex:0x909090];
        }completion:^(BOOL finished){
            self.leftBack.alpha     = _isNew?1.0:0;
            self.rightBack.alpha    = _isNew?1.0:0;
            self.logo.alpha         = _isNew?1.0:0;
            self.nameLabel.textColor    = _isNew?[UIColor blackColor]:[UIColor whiteColor];
            self.adressLabel.textColor  = _isNew?[UIColor blackColor]:[UIColor colorWithHex:0x909090];
        }];
    }
}
@end

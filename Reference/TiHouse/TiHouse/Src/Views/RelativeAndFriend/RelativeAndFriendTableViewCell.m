//
//  RelativeAndFriendTableViewCell.m
//  TiHouse
//
//  Created by guansong on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RelativeAndFriendTableViewCell.h"
#import "NSDate+Extend.h"

@implementation RelativeAndFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setIsLastRow:(BOOL)isLastRow{
    _isLastRow = isLastRow;
    if (isLastRow) {
        self.leftLayout.constant = 0;
        self.rightLatout.constant = -33;
    }else{
        self.leftLayout.constant = 12;
        self.rightLatout.constant = 0;
    }
}

- (void) loadViewWtithModel:(Houseperson *)model
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.urlhead]];
    self.masterTitle.text = [NSString stringWithFormat:@"%@( %@ )",IF_NULL_TO_STRINGSTR(model.nickname, @"-"), IF_NULL_TO_STRINGSTR([model typerelationName], @"-")];
    
    NSDate *date = [NSDate dateFromTimestamp:model.updatetime/1000];
    NSString *strDate = [NSDate stringWithDate:date format:@"MM-dd hh:mm"];
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    self.detailLable.text =[NSString stringWithFormat:@"最近：%@",strDate];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

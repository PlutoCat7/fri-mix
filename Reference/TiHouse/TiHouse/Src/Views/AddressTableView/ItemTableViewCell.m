//
//  ItemTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/17.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "Province.h"
#import "City.h"
#import "Region.h"

@interface ItemTableViewCell()

@property (nonatomic ,retain) UIImageView *selectIcon;//被选择的图标
@property (nonatomic ,retain) ItemModel *curModel;

@end

#define SelectedColor [UIColor orangeColor]
#define UnSelectedColor [UIColor grayColor]

@implementation ItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineStyle = CellLineStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.selectIcon];
        [self.contentView addSubview:self.Title];
        _curModel = [[ItemModel alloc]init];
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    _selectIcon.frame = CGRectMake(10, 0, self.contentView.height/2, self.contentView.height/2);
    _selectIcon.centerY = self.contentView.centerY;
    
    _Title.frame = CGRectMake(CGRectGetMaxX(_selectIcon.frame), 0, self.contentView.width - CGRectGetMaxX(_selectIcon.frame)-60, self.contentView.height/2);
    _Title.centerY = self.contentView.centerY;
    
}


-(void)setModel:(id )model{
    
    _model = model;
    
    if ([model isKindOfClass:[Province class]]) {
        Province *pro = model;
        _curModel.Title = pro.provname;
        _curModel.isSelect = pro.isSelect;
        _curModel.modleid = pro.provid;
    }
    if ([model isKindOfClass:[City class]]) {
        City *pro = model;
        _curModel.Title = pro.cityname;
        _curModel.isSelect = pro.isSelect;
        _curModel.modleid = pro.cityid;
    }
    if ([model isKindOfClass:[Region class]]) {
        Region *pro = model;
        _curModel.Title = pro.regionname;
        _curModel.isSelect = pro.isSelect;
        _curModel.modleid = pro.regionid;
    }
    
    _Title.text = _curModel.Title;
    if (_curModel.isSelect) {
        _Title.textColor = SelectedColor;
        _selectIcon.hidden = NO;
    }else{
        _Title.textColor = UnSelectedColor;
        _selectIcon.hidden = YES;
    }
    
}


-(UIImageView *)selectIcon{
    
    if (!_selectIcon) {
        _selectIcon = [[UIImageView alloc]init];
        _selectIcon.contentMode = UIViewContentModeScaleAspectFill;
        _selectIcon.image = [UIImage imageNamed:@"Add_Icon"];
        _selectIcon.hidden = YES;
    }
    return _selectIcon;
}

-(UILabel *)Title{
    if (!_Title) {
        _Title = [[UILabel alloc]init];
        _Title.textColor = UnSelectedColor;
        _Title.font = [UIFont systemFontOfSize:14];
    }
    return _Title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

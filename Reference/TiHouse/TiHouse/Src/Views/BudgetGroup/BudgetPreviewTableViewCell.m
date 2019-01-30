//
//  BudgetPreviewTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetPreviewTableViewCell.h"
#import "BudgetDetailsPreviewCell.h"
#import "BudgetOneClass.h"
#import "BudgetTwoClass.h"
#import "BudgetThreeClass.h"

@interface BudgetPreviewTableViewCell()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *tableHeaderView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *particulars;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation BudgetPreviewTableViewCell




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.topLineStyle = CellLineStyleFill;
        self.bottomLineStyle = CellLineStyleFill;
        self.contentView.backgroundColor = XWColorFromHex(0xf8f8f8);
        
    }
    return self;
}

-(void)setOneClass:(BudgetOneClass *)oneClass{
    _oneClass = oneClass;
//    [self tableView];
    [self.tableView reloadData];
    _title.text = _oneClass.cateonename;
    _particulars.text = [NSString stringWithFormat:@"-总费用%@，占比%.0f%%",
                         [self moneyFormat:[NSString stringWithFormat:@"%0.f",_oneClass.oneAmount / 100.0f]],_oneClass.percentage*100];
    [_icon sd_setImageWithURL:[NSURL URLWithString:_oneClass.urlicon] placeholderImage:[UIImage imageNamed:@"88"]];
}



#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _oneClass.catetwoList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BudgetTwoClass *twoClass = _oneClass.catetwoList[section];
    return twoClass.sortList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BudgetDetailsPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BudgetTwoClass *twoClass = _oneClass.catetwoList[indexPath.section];
    cell.threeClass = twoClass.sortList[indexPath.row];
    cell.lineShow = YES;
    cell.bottomLineStyle = CellLineStyleNone;
    if (indexPath.row == twoClass.catethreeList.count-1) {
        cell.lineShow = NO;
        cell.bottomLineStyle = CellLineStyleFill;
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    BudgetTwoClass *twoClass = _oneClass.catetwoList[section];
    UIView *Header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, 50)];
    Header.clipsToBounds = YES;
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 24, 24)];
    [icon sd_setImageWithURL:[NSURL URLWithString:twoClass.catetwourlicon]];
    icon.centerY = Header.height/2;
//    [icon sd_setImageWithURL:[NSURL URLWithString:_oneClass.urlicon] placeholderImage:[UIImage imageNamed:@"slidingBlock"]];
    [Header addSubview:icon];
    //二级名称
    UILabel *title = [[UILabel alloc]init];
    title.text = twoClass.catetwoname;
    title.font = [UIFont systemFontOfSize:17];
    [title sizeToFit];
    title.x = CGRectGetMaxX(icon.frame)+8;
    title.centerY = icon.centerY;
    title.textColor = kColor666;
    [Header addSubview:title];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, Header.height-0.5, Header.width-24, 0.5)];
    line.backgroundColor = kLineColer;
    [Header addSubview:line];
    
    return Header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    BudgetTwoClass *twoClass = _oneClass.catetwoList.firstObject;
    if(!twoClass.catetwostatus){
        return 0.01f;
    }
    return 50.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - <懒加载>
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[BudgetDetailsPreviewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.estimatedRowHeight = 50;
        _tableView.scrollEnabled = NO;
        _tableView.bounces = NO;
        [self.contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(0, 0, 5, 0));
        }];
    }
    return _tableView;
}


-(UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, 50)];
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 24, 24)];
        _icon.centerY = _tableHeaderView.height/2;
        [_icon sd_setImageWithURL:[NSURL URLWithString:_oneClass.urlicon] placeholderImage:[UIImage imageNamed:@"88"]];
        [_tableHeaderView addSubview:_icon];
        //一级名称
        _title = [[UILabel alloc]init];
        _title.text = _oneClass.cateonename;
        _title.font = [UIFont systemFontOfSize:17 weight:20];
        [_title sizeToFit];
        _title.x = CGRectGetMaxX(_icon.frame)+8;
        _title.centerY = _icon.centerY;
        _title.textColor = kColor666;
        [_tableHeaderView addSubview:_title];
        //详情
        NSString *particularsStr = [NSString stringWithFormat:@"-总费用%@，占比%.0f%%",
                                [self moneyFormat:[NSString stringWithFormat:@"%0.f",_oneClass.oneAmount]],_oneClass.percentage*100];

//        NSString *particularsStr = [NSString stringWithFormat:@"-总费用%.0f，占比%.0f%%",_oneClass.oneAmount,_oneClass.percentage*100];
        _particulars = [[UILabel alloc]init];
        _particulars.text = particularsStr;
        _particulars.backgroundColor = [UIColor clearColor];
        _particulars.font = [UIFont systemFontOfSize:17];
        [_particulars sizeToFit];
        _particulars.textColor = kColor666;
        _particulars.frame = CGRectMake(CGRectGetMaxX(_title.frame), 0, kScreen_Width, _particulars.frame.size.height);
        _particulars.centerY = _icon.centerY;
        [_tableHeaderView addSubview:_particulars];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, kScreen_Width, 0.5)];
        line.backgroundColor = kLineColer;
        [_tableHeaderView addSubview:line];        
    }
    return _tableHeaderView;
}

+(CGFloat)GetCellHightWhitOneClass:(BudgetOneClass *)oneClass{
    
    CGFloat hight = 0;
    hight += 50; //表头
    BudgetTwoClass *twoClass = oneClass.catetwoList.firstObject;
    if(twoClass.catetwostatus){
        hight += oneClass.catetwoList.count * 50;
    }else{
        hight += 0;
    }
    __block CGFloat cellHight = 0;
    [oneClass.catetwoList enumerateObjectsUsingBlock:^(BudgetTwoClass  *twoClass, NSUInteger idx, BOOL * _Nonnull stop) {
        cellHight += twoClass.sortList.count *50;
    }];
    hight +=cellHight;
    
    return hight+5;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)moneyFormat:(NSString *)money{
    NSArray *moneys = [money componentsSeparatedByString:@"."];
    if (moneys.count > 2) {
        return money;
    }
    else if (moneys.count < 2) {
        return [self stringFormatToThreeBit:money];
    }
    else {
        NSString *frontMoney = [self stringFormatToThreeBit:moneys[0]];
        if([frontMoney isEqualToString:@""]){
            frontMoney = @"0";
        }
        return [NSString stringWithFormat:@"%@.%@", frontMoney,moneys[1]];
    }
}

// 千分位无小数点
- (NSString *)stringFormatToThreeBit:(NSString *)string{
    if (string.length <= 0) {
        return @"".mutableCopy;
    }
    
    NSString *tempRemoveD = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSMutableString *stringM = [NSMutableString stringWithString:tempRemoveD];
    NSInteger n = 2;
    for (NSInteger i = tempRemoveD.length - 3; i > 0; i--) {
        n++;
        if (n == 3) {
            [stringM insertString:@"," atIndex:i];
            n = 0;
        }
    }
    
    return stringM;
}

@end

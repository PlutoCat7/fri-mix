//
//  LookTransformViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "LookTransformViewCell.h"
#import "BudgetLookTransformCell.h"
#import "Logbudgetope.h"
#import "NSDate+Extend.h"

@interface LookTransformViewCell()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *tableHeader;

@end

@implementation LookTransformViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.topLineStyle = CellLineStyleFill;
        self.bottomLineStyle =CellLineStyleFill;
        [self tableHeader];
        [self tableView];
    }
    return self;
}

-(void)setModels:(NSMutableArray *)models{
    _models = models;
    Logbudgetope *logbuget = models.firstObject;
    _tableHeader.text = [self MDFormat:[NSDate dateWithTimeIntervalSince1970:logbuget.budgetopetime/1000]];
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BudgetLookTransformCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.logbudgetope = _models[indexPath.row];
    cell.lineShow = YES;
    if (indexPath.row == _models.count-1) {
        cell.lineShow = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Logbudgetope *budgetope = _models[indexPath.row];
    return budgetope.proremark.length > 0 ? 90 : 70;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - <懒加载>
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 90;
        [_tableView registerClass:[BudgetLookTransformCell class] forCellReuseIdentifier:@"cell"];
        [self.contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(22, 0, 0, 0));
        }];
    }
    return _tableView;
}

+(CGFloat)getCellHeight:(NSArray *)arr{
    
    __block CGFloat Height = 0;
    [arr enumerateObjectsUsingBlock:^(Logbudgetope *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.proremark.length > 0) {
            Height += 90;
        }else{
            Height += 70;
        }
    }];
    
    return Height+22;
}

- (NSString *)MDFormat:(NSDate *)date{

    NSDateFormatter *forma = [[NSDateFormatter alloc]init];
    [forma setDateFormat:@"MM月 dd日  HH:mm"];
    return [forma stringFromDate:date];;
}


-(UITextField *)tableHeader{
    if (!_tableView) {
        _tableHeader = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 22)];
        _tableHeader.backgroundColor = XWColorFromHex(0xfcfcfc);
        _tableHeader.userInteractionEnabled = NO;
        _tableHeader.textColor = kColor999;
        _tableHeader.font = [UIFont systemFontOfSize:11];
        UIView *aa =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 13, 1)];
        _tableHeader.leftView = aa;
        _tableHeader.leftViewMode = UITextFieldViewModeAlways;
        [self.contentView addSubview:_tableHeader];
    }
    return _tableHeader;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

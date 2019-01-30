//
//  TimerShaftTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//


#define kTreetCell_LinePadingLeft 18.0
#define kTreetMedia_MediaItem_Pading 5.0
#define kTreetMedia_Wtith kScreen_Width - kTreetCell_LinePadingLeft - 11 - 24
#define  kTreet_ContentFont [UIFont systemFontOfSize:15]
#define BOTTOMHEIGHT 30

#import "TimerShaftTallysCell.h"
#import "NSDate+Common.h"
#import "BudgetCell.h"
#import "modelTallys.h"
#import "TweetTallypro.h"
@interface TimerShaftTallysCell()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic ,retain) UIView *line;//时光轴的线
@property (nonatomic ,retain) UIView *bottomline;//按钮分割线线
@property (nonatomic ,retain) UIView *contentsView;//容器
@property (nonatomic ,retain) UITableView *tableView;//预算详情
@property (nonatomic ,strong) UILabel *dateView,*budgetTitleView ,*budgetNameView, *timeView ;
@property (nonatomic, retain) UIButton *checkBudget;//查看预算
@property (nonatomic, retain) UIButton *checkRevamp;//查修改



@end

@implementation TimerShaftTallysCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineStyle = CellLineStyleNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self topView];
        [self icon];
        [self line];
        [self contentsView];
        [self budgetTitleView];
        [self budgetNameView];
        [self tableView];
        [self timeView];
        [self dateView];
        [self checkBudget];
        [self checkRevamp];
        [self bottomline];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    _dateView.hidden = _icon.hidden;
    if (_icon.hidden) {
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_icon.mas_centerX);
            make.top.equalTo(_icon.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(1));
        }];
    }else{
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_icon.mas_centerX);
            make.top.equalTo(_icon.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(1));
        }];
    }
    [_line.superview layoutIfNeeded];
}

- (void)setmodelmodelTallys:(modelTallys *)modelTallys needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView{
    _modelTallys = modelTallys;
    
    _topView.height = needTopView ? 20 : 0;
    _icon.y = CGRectGetMaxY(_topView.frame);
    
    _dateView.text = [[NSDate dateWithTimeIntervalSince1970:_modelTallys.latesttime/1000] stringDisplay_MMdd];
    _dateView.size = [_dateView sizeThatFits:CGSizeMake(20, 20)];
    _dateView.x = CGRectGetMaxX(_icon.frame)+6;
    _dateView.centerY = _icon.centerY;
    
    _contentsView.x = CGRectGetMaxX(_line.frame) +11;
    _contentsView.y = CGRectGetMaxY(_icon.frame)+9;
    
    if ([_modelTallys.listModelLogtallyope count] > 0) {
        _budgetTitleView.text = @"账本有了新动态: ";
    } else {
        _budgetTitleView.text = @"添加了一个新账本: ";
    }
    [_budgetTitleView sizeToFit];

    _budgetNameView.text = _modelTallys.tallyname;
    [_budgetNameView sizeToFit];
    _budgetNameView.centerY = _budgetTitleView.centerY;
    _budgetNameView.x = CGRectGetMaxX(_budgetTitleView.frame);
    
    //记账内容
    _tableView.height = _modelTallys.listModelLogtallyope.count * 35;
    _tableView.y = CGRectGetMaxY(_budgetNameView.frame) + 15;
    
    //用户名及发布时间
    NSString *timeViewStr = [NSString stringWithFormat:@"%@，%@",_modelTallys.nickname,[[NSDate dateWithTimeIntervalSince1970:_modelTallys.latesttime/1000] stringDisplay_HHmm]];
    _timeView.text = timeViewStr;
    _timeView.y = CGRectGetMaxY(_tableView.frame);
    _timeView.x = 9;
    _bottomline.frame = CGRectMake(_timeView.x, CGRectGetMaxY(_timeView.frame), _tableView.width, 0.5);
    
    _checkBudget.y = CGRectGetMaxY(_timeView.frame);
    _checkBudget.x = 0;
    _checkBudget.width = _contentsView.width/2;
    
    _checkRevamp.x = _contentsView.width/2;
    _checkRevamp.y = CGRectGetMaxY(_timeView.frame);
    _checkRevamp.width = _contentsView.width/2;
    

    _contentsView.height = CGRectGetMaxY(_checkRevamp.frame);
    [_tableView reloadData];
}


#pragma mark Collection M
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelTallys.listModelLogtallyope.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BudgetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BudgetCell"];
    TweetTallypro *tallypeo = _modelTallys.listModelLogtallyope[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *transformStr;
    NSString *image;
    switch (tallypeo.tallyopetype) {
        case 1:
            transformStr = @"添加了：";
            image = @"jia_icon";
            break;
        case 2:
            transformStr = @"修改了：";
            image = @"cha_icon";
            break;
        case 3:
            transformStr = @"删除了：";
            image = @"shan_icon";
            break;
        case 4:
            transformStr = @"设置了星标项目：";
            image = @"buyIcon";
            break;
        case 5:
            transformStr = @"设置了已购项目：";
            image = @"moey_icon";
            
            break;
            
        default:
            break;
    }
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@%@",transformStr,tallypeo.tallyprocatename];
    cell.moneyLabel.text = [NSString stringWithFormat:@"¥%@",[NSString strmethodComma:[NSString stringWithFormat:@"%ld",tallypeo.amountzj/100]]];
    cell.icon.image = [UIImage imageNamed:image];
    if (tallypeo.tallyprotype == 2) {
        cell.moneyLabel.textColor = XWColorFromHex(0x25c059);
    }else{
        cell.moneyLabel.textColor = XWColorFromHex(0xfbc33b);
    }
    if (indexPath.row == _modelTallys.listModelLogtallyope.count -1) {
        cell.bottomLineStyle = CellLineStyleNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
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




+ (CGFloat)cellHeightWithmodelTallys:(modelTallys *)modelTallys needTopView:(BOOL)needTopView  needBottomView:(BOOL)needBottomView{

    CGFloat cellHeight = 0;
    cellHeight += needTopView ? 20 : 0;
    cellHeight += 11.0;//时间轴图标高度
    cellHeight += 13.0;//内容top边距
    cellHeight += 20.0;//标题高度
    cellHeight += 20.0;//表top边距高度
    cellHeight += 35*modelTallys.listModelLogtallyope.count;
    cellHeight += 34;
    cellHeight += 49 + 8;//按钮高度
    cellHeight += needBottomView ? BOTTOMHEIGHT : 0;
    
    return ceilf(cellHeight);
}




#pragma mark - getters and setters
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
        [self.contentView addSubview:_topView];
    }
    return _topView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
        [self.contentView addSubview:_bottomView];
    }
    return _bottomView;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(kTreetCell_LinePadingLeft, CGRectGetMaxY(_topView.frame), 11, 11)];
        _icon.image = [UIImage imageNamed:@"timerShaft_lock"];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

-(UILabel *)dateView{
    if (!_dateView) {
        _dateView = [[UILabel alloc]initWithFrame:CGRectZero];
        _dateView.textColor = XWColorFromHex(0x44444b);
        _dateView.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_dateView];
    }
    return _dateView;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(_icon.centerX, CGRectGetMaxY(_icon.frame), 1, self.contentView.height)];
        _line.backgroundColor = kLineColer;
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_icon.mas_centerX);
            make.top.equalTo(_icon.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(1));
        }];
    }
    return _line;
}


-(UIView *)contentsView{
    if (!_contentsView) {
        _contentsView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_line.frame)+11, CGRectGetMaxY(_icon.frame)+9, kTreetMedia_Wtith, 0)];
        _contentsView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_contentsView];
    }
    return _contentsView;
}


-(UILabel *)budgetTitleView{
    if (!_budgetTitleView) {
        _budgetTitleView = [[UILabel alloc]initWithFrame:CGRectMake(9, 20, 0, 0)];
        _budgetTitleView.textColor = XWColorFromHex(0x95989a);
        _budgetTitleView.font = [UIFont systemFontOfSize:15];
        _budgetTitleView.text = @"";
        [_budgetTitleView sizeToFit];
        _budgetTitleView.x = 9;
        _budgetTitleView.y = 20;
        [_contentsView addSubview:_budgetTitleView];
    }
    return _budgetTitleView;
}

-(UILabel *)budgetNameView{
    if (!_budgetNameView) {
        _budgetNameView = [[UILabel alloc]initWithFrame:CGRectMake(9, 20, 0, 0)];
        _budgetNameView.textColor = XWColorFromHex(0x5186aa);
        _budgetNameView.font = [UIFont systemFontOfSize:15 weight:20];
        [_contentsView addSubview:_budgetNameView];
    }
    return _budgetTitleView;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(9, 0, kTreetMedia_Wtith - 18, 0) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[BudgetCell class] forCellReuseIdentifier:@"BudgetCell"];
        _tableView.scrollEnabled = NO;
        [_contentsView addSubview:_tableView];
    }
    return _tableView;
}


-(UILabel *)timeView{
    if (!_timeView) {
        _timeView = [[UILabel alloc]initWithFrame:CGRectMake(_tableView.x, 0, _contentsView.width-18, 34)];
        _timeView.textColor = XWColorFromHex(0xbfbfbf);
        _timeView.font = [UIFont systemFontOfSize:11];
        [_contentsView addSubview:_timeView];
    }
    return _timeView;
}


-(UIButton *)checkBudget{
    if (!_checkBudget) {
        _checkBudget = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBudget setTitle:@"查看账本" forState:(UIControlStateNormal)];
        [_checkBudget setTitleColor:XWColorFromHex(0x5186aa) forState:UIControlStateNormal];
        _checkBudget.frame = CGRectMake(0, 0, kTreetMedia_Wtith/2, 49);
        _checkBudget.tag = 1;
        [_checkBudget addTarget:self action:@selector(lockBuggetClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentsView addSubview:_checkBudget];
    }
    return _checkBudget;
}



-(UIButton *)checkRevamp{
    if (!_checkRevamp) {
        _checkRevamp = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkRevamp setTitle:@"查看记账" forState:(UIControlStateNormal)];
        [_checkRevamp setTitleColor:XWColorFromHex(0x5186aa) forState:UIControlStateNormal];
        _checkRevamp.frame = CGRectMake(kTreetMedia_Wtith/2, 0, kTreetMedia_Wtith/2, 49);
        [_checkRevamp addTarget:self action:@selector(lockBuggetClick:) forControlEvents:UIControlEventTouchUpInside];
        _checkRevamp.tag = 2;
        [_contentsView addSubview:_checkRevamp];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 19, 1, 12)];
        line.backgroundColor = kLineColer;
        [_checkRevamp addSubview:line];
    }
    return _checkRevamp;
}


-(UIView *)bottomline{
    if (!_bottomline) {
        _bottomline = [[UIView alloc]initWithFrame:CGRectMake(_tableView.x, 0, _tableView.width, 0)];
        _bottomline.backgroundColor = kLineColer;
        [_contentsView addSubview:_bottomline];
    }
    return _bottomline;
}


-(void)lockBuggetClick:(UIButton *)btn{
    if (self.CellBlockClick) {
        self.CellBlockClick(btn.tag);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

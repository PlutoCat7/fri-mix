//
//  TitleBarView.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/17.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "TitleBarView.h"
#import "AddresManager.h"

//static int MuneBtnCount = 1;
@interface  TitleBarView()
{
    UIView *lastView;
}
@property (nonatomic, retain) UIView *highlightLine;
@property (nonatomic, retain) UIView *bottomLine;
@property (nonatomic, retain) UILabel *Title;
@property (nonatomic, retain) UIButton *closeBtn;
@property (nonatomic, retain) NSMutableArray *muneBtnArr;

@end

@implementation TitleBarView


-(instancetype)init{
    
    if (self = [super init]) {
        
        _muneBtnArr = [NSMutableArray new];
        [self addSubview:self.Title];
        [self addSubview:self.bottomLine];
        [self addSubview:self.closeBtn];
        [self addSubview:self.selectBtn];
        [self addSubview:self.highlightLine];
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
}



#pragma mark - private methods 私有方法

-(void)selectClick:(UIButton *)btn{
    
    [_highlightLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
        make.centerX.equalTo(btn.mas_centerX);
        make.width.equalTo(@(btn.width));
    }];
    [UIView animateWithDuration: 0.3 animations:^{
        [self layoutIfNeeded];
    }];
    if (_SelectBtnBlock) {
        _SelectBtnBlock(btn.tag);
    }
    
}


//添加菜单按钮
-(void)addMenu{
    
    lastView = _muneBtnArr.lastObject;
    UIButton *MenuBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    ItemModel *model = _Addres.item;
    [MenuBtn setTitle:model.Title forState:UIControlStateNormal];
    MenuBtn.backgroundColor = [UIColor whiteColor];
    MenuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    MenuBtn.tag = _muneBtnArr.count+1;
    [MenuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [MenuBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [MenuBtn sizeToFit];
    [self addSubview:MenuBtn];
    [MenuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-1);
        if (_muneBtnArr.count == 0) {
            make.left.equalTo(@(0)).offset(20);
        }else{
            make.left.equalTo(lastView.mas_right).offset(20);
        }
        make.size.mas_equalTo(CGSizeMake(MenuBtn.width, 50));
    }];
    [_muneBtnArr addObject:MenuBtn];
    [self bringSubviewToFront:_selectBtn];

    
}

-(void)closeClick{

    if (_CloseBlock) {
        _CloseBlock();
    }
}


#pragma mark - getters and setters
-(UILabel *)Title{
    if (!_Title) {
        _Title = [[UILabel alloc]init];
        _Title.textColor = [UIColor grayColor];
        _Title.textAlignment = NSTextAlignmentCenter;
        _Title.text = @"所在地区";
        [self addSubview:_Title];
        [_Title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self);
            make.height.equalTo(@(40));
            make.top.equalTo(self).offset(10);
        }];
    }
    return _Title;
}

-(void)addMuneBtn:(NSInteger )item{
    if (_muneBtnArr.count>0) {
        NSArray *revm = [_muneBtnArr subarrayWithRange:NSMakeRange(item, _muneBtnArr.count-item)];
        //    _Addres.titles = [NSMutableArray arrayWithArray:[_Addres.titles subarrayWithRange:NSMakeRange(item, _muneBtnArr.count-item)]];
        [revm enumerateObjectsUsingBlock:^(UIButton  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_muneBtnArr removeObject:obj];
            [obj removeFromSuperview];
            obj = nil;
        }];
    }
    [self addMenu];
    lastView = _muneBtnArr.lastObject;
    [self layoutIfNeeded];
    [_selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-1);
        make.left.equalTo(lastView.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(_selectBtn.width, 50));
    }];
    [_highlightLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
        make.left.equalTo(lastView.mas_right).offset(20);
        make.width.equalTo(@(_selectBtn.width));
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    
}

-(void)setAddres:(AddresManager *)Addres{
    _Addres = Addres;
    WEAKSELF
    if (Addres.address.count > 0) {
        [Addres.address enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf addMuneBtn:idx+1];
        }];
        _selectBtn.hidden = YES;
        [weakSelf selectClick:(UIButton *)lastView];
    }
    
}

- (UIView *) bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        [_bottomLine setBackgroundColor:XWColorFromRGB(235, 235, 235)];
        [_bottomLine setAlpha:1];
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self);
            make.height.equalTo(@(0.5));
        }];
    }
    return _bottomLine;
}

- (UIButton *) closeBtn
{
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return _closeBtn;
}
- (UIButton *) selectBtn
{
    if (_selectBtn == nil) {
        _selectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_selectBtn setTitle:@"请选择" forState:UIControlStateNormal];
        _selectBtn.backgroundColor = [UIColor whiteColor];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn sizeToFit];
        _selectBtn.tag = 99;
        [self addSubview:_selectBtn];
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-1);
            make.left.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(_selectBtn.width, 50));
        }];
    }
    return _selectBtn;
}


- (UIView *) highlightLine
{
    if (_highlightLine == nil) {
        _highlightLine = [[UIView alloc] init];
        _highlightLine.height =0.5f;
        [_highlightLine setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:_highlightLine];
        [_highlightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.height.equalTo(@(0.5));
            make.centerX.equalTo(_selectBtn.mas_centerX);
            make.width.equalTo(@(_selectBtn.width));
        }];
    }
    return _highlightLine;
}


@end

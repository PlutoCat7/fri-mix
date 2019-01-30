//
//  RelationView.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/16.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "RelationView.h"
#import "FSCustomButton.h"
#import "House.h"

@interface RelationView()
{
    NSArray *titles;
}
@property (nonatomic, retain) FSCustomButton *oldSelected;

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation RelationView

-(instancetype)init{
    
    if (self = [super init]) {
        titles = @[@"女主人",@"男主人",@"亲人",@"设计方",@"施工方",@"朋友"];
        for (int i = 0; i<titles.count; i++) {
            FSCustomButton *button = [[FSCustomButton alloc] initWithFrame:CGRectMake(100, 220, 200, 40)];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:kTitleAddHouseTitleCOLOR forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            [button setImage:[UIImage imageNamed:@"relationBtnselect"] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:@"relationBtn"] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            button.tag = 11+i;
            [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
    }
    return self;
}

-(void)layoutSubviews{
    
    __weak typeof(self) weakself = self;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[FSCustomButton class]]) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(weakself.width/3, weakself.height/2));
                make.left.equalTo(@((obj.tag-11)%3*weakself.width/3));
                make.top.equalTo(@((obj.tag-11)/3*(weakself.height-30)/2+10));
            }];
        }
        
    }];
    
    self.bottomLine.x = 0;
    self.bottomLine.y = self.frame.size.height - _bottomLine.height;
    self.bottomLine.width = self.frame.size.width;
    self.topLine.x = 0;
    self.topLine.width = self.frame.size.width;

}

- (UIView *) bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.height =0.5f;
        [_bottomLine setBackgroundColor:XWColorFromRGB(235, 235, 235)];
        [_bottomLine setAlpha:1];
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (UIView *) topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] init];
        _topLine.height = 0.5f;
        [_topLine setBackgroundColor:XWColorFromRGB(235, 235, 235)];
        [_topLine setAlpha:1];
        [self addSubview:_topLine];
    }
    return _topLine;
}



-(void)selected:(FSCustomButton *)btn{
    
    if (btn == _oldSelected) {
        return;
    }
    btn.selected = YES;
    _oldSelected.selected = NO;
    _oldSelected = btn;
    if (_finishBolck) {
        _finishBolck(titles[btn.tag-11],(NSInteger)(btn.tag-10));
    }
}


-(void)setSelectedBtn:(NSInteger )selectedBtn{
    _selectedBtn = selectedBtn;
    FSCustomButton *btn = [self viewWithTag:selectedBtn+10];
    [self selected:btn];
}

- (void)setHouse:(House *)house {
    _house = house;
//    UIButton *womanButton = [self viewWithTag:11];
//    womanButton.userInteractionEnabled = _house.househaswoman != 1;
//    if (_house.househaswoman == 1) {
//        [womanButton setTitleColor:[UIColor colorWithHexString:@"bfbfbf"] forState:UIControlStateNormal];
//    }
//
//    UIButton *manButton = [self viewWithTag:12];
//    manButton.userInteractionEnabled = _house.househasman != 1;
//    if (_house.househasman == 1) {
//        [manButton setTitleColor:[UIColor colorWithHexString:@"bfbfbf"] forState:UIControlStateNormal];
//    }
}

- (void)setMasters:(NSArray *)masters{
    UIButton *manButton = [self viewWithTag:11];
    UIButton *womanButton = [self viewWithTag:12];
    manButton.userInteractionEnabled = YES;
    womanButton.userInteractionEnabled = YES;
    for (Houseperson *hp in masters) {
        if (hp.typerelation == 1) {
            manButton.userInteractionEnabled = NO;
            [manButton setTitleColor:[UIColor colorWithHexString:@"bfbfbf"] forState:UIControlStateNormal];
        }
        if (hp.typerelation == 2) {
            womanButton.userInteractionEnabled = NO;
            [womanButton setTitleColor:[UIColor colorWithHexString:@"bfbfbf"] forState:UIControlStateNormal];
        }
    }
}


@end

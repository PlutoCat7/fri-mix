//
//  BudgetDetailsTabbleHeaderView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetDetailsTabbleHeaderView.h"
#import "BudgetOneClass.h"
#import "BudgetTwoClass.h"
#import "BudgetDetailSort.h"
#import "SGTopScrollMenu.h"


@interface BudgetDetailsTabbleHeaderView()

@property (nonatomic, retain) BudgetDetailSort *sortView;

@end

@implementation BudgetDetailsTabbleHeaderView


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self sliderBar];
//        [self topScrollMenu];
        [self sortView];
    }
    return self;
}

-(void)setOneClass:(BudgetOneClass *)oneClass{
    _oneClass = oneClass;
    NSArray *twoClass = [oneClass.catetwoList copy];
    NSMutableArray *twoNames = [NSMutableArray new];
    [twoClass enumerateObjectsUsingBlock:^(BudgetTwoClass *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [twoNames addObject:obj.catetwoname];
    }];
//    self.topScrollMenu.titlesArr = twoNames;
    _sliderBar.itemArray = twoNames;
    _sliderBar.isMoniteScroll = NO;
    NSString *money = [NSString strmethodComma:[NSString stringWithFormat:@"%.0f",_oneClass.oneAmount / 100.0f]];
    _sortView.titleView.text = [NSString stringWithFormat:@"%@总费用¥ %@",_oneClass.cateonename,money];
    [_oneClass addObserver:self forKeyPath:@"oneAmount" options:(NSKeyValueObservingOptionNew) context:nil];
}

//  KVO 监听值变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    if ([keyPath isEqualToString:@"oneAmount"]) {
        NSString *money = [NSString strmethodComma:[NSString stringWithFormat:@"%.0f",[[change valueForKey:NSKeyValueChangeNewKey] floatValue] / 100.0f]];
        _sortView.titleView.text = [NSString stringWithFormat:@"%@总费用¥ %@",_oneClass.cateonename,money];
    }
}

-(void)dealloc{
    [_oneClass removeObserver:self forKeyPath:@"oneAmount" context:nil];
}




-(ZXCategorySliderBar *)sliderBar{
    if (!_sliderBar) {
        _sliderBar = [[ZXCategorySliderBar alloc]initWithFrame:CGRectMake(0, 50, kScreen_Width, 50)];
        [self.contentView addSubview:_sliderBar];
    }
   return _sliderBar;
}

-(BudgetDetailSort *)sortView{
    if (!_sortView) {
        _sortView = [[BudgetDetailSort alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
        _sortView.backgroundColor = [UIColor whiteColor];
        [_sortView.sortBtn addTarget:self action:@selector(sort) forControlEvents:UIControlEventTouchUpInside];
        [_sortView.screenBtn addTarget:self action:@selector(screen) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sortView];
    }
    return _sortView;
}

-(SGTopScrollMenu *)topScrollMenu{
    if (!_topScrollMenu) {
        _topScrollMenu = [SGTopScrollMenu topScrollMenuWithFrame:CGRectMake(0, 50, kScreen_Width, 50)];
        _topScrollMenu.backgroundColor = XWColorFromHex(0xfcfcfc);
        [self.contentView addSubview:_topScrollMenu];
    }
    return _topScrollMenu;
}

#pragma mark - event response
//价格排序
-(void)sort{
    if (_sortBlock) {
        _sortBlock();
    }
}
//筛选
-(void)screen{
    if (_screenBlock) {
        _screenBlock();
    }
}




@end

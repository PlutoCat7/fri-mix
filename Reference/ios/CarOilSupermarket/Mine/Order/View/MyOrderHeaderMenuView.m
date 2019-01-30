//
//  MyOrderHeaderMenuView.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/16.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "MyOrderHeaderMenuView.h"

@interface MyOrderHeaderMenuView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonList;
@property (nonatomic, strong) NSMutableArray<UIView *> *lineList;

@end

@implementation MyOrderHeaderMenuView

- (void)setTitles:(NSArray<NSString *> *)titles {
    
    for (UIView *view in self.buttonList) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.lineList) {
        [view removeFromSuperview];
    }
    self.buttonList = [NSMutableArray arrayWithCapacity:1];
    self.lineList = [NSMutableArray arrayWithCapacity:1];
    
    CGFloat width = kUIScreen_Width/titles.count;
    CGFloat height = 55;
    CGFloat posX = 0;
    CGFloat linePosY = 14;
    CGFloat lineHeight = 26;
    for (NSInteger index=0; index<titles.count; index++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.frame = CGRectMake(posX, 0, width, height);
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button setTitle:titles[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHex:0x4d4e4f] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHex:0x14b0ff] forState:UIControlStateSelected];
        @weakify(self)
        [button addActionHandler:^(NSInteger tag) {
            
            @strongify(self)
            self.selectIndex = tag;
            for (UIButton *button in self.buttonList) {
                button.selected = NO;
            }
            self.buttonList[tag].selected = YES;
            if ([self.delegate respondsToSelector:@selector(menuDidSelectWithIndex:)]) {
                [self.delegate menuDidSelectWithIndex:tag];
            }
        }];
        [self addSubview:button];
        [self.buttonList addObject:button];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(posX+width, linePosY, 0.5, lineHeight)];
        line.backgroundColor = [UIColor colorWithHex:0xeff0f4];
        [self addSubview:line];
        [self.lineList addObject:line];
        
        posX += width;
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    
    _selectIndex = selectIndex;
    for (UIButton *button in self.buttonList) {
        button.selected = NO;
    }
    self.buttonList[selectIndex].selected = YES;
}

@end

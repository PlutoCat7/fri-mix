//
//  CommonTableViewCell.m
//  app
//
//  Created by 融口碑 on 2017/9/18.
//  Copyright © 2017年 王小伟. All rights reserved.
//

#import "CommonTableViewCell.h"

@implementation CommonTableViewCell


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
     
        _topLineStyle = CellLineStyleNone;
        _bottomLineStyle = CellLineStyleDefault;
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.topLine.y = 0;
    self.bottomLine.y = self.frame.size.height - _bottomLine.height;
    [self setBottomLineStyle:_bottomLineStyle];
    [self setTopLineStyle:_topLineStyle];
    
}

- (void) setTopLineStyle:(CellLineStyle)style
{
    
    _topLineStyle = style;
    if (style == CellLineStyleDefault) {
        self.topLine.left = _leftFreeSpace;
        self.topLine.width = self.width - _leftFreeSpace - _rightFreeSpace;
        [self.topLine setHidden:NO];
    }
    else if (style == CellLineStyleFill) {
        self.topLine.x = 0;
        self.topLine.width = self.frame.size.width;
        [self.topLine setHidden:NO];
    }
    else if (style == CellLineStyleNone) {
        [self.topLine setHidden:YES];
    }
}

- (void) setBottomLineStyle:(CellLineStyle)style
{
    _bottomLineStyle = style;
    if (style == CellLineStyleDefault) {
        self.bottomLine.x = _leftFreeSpace;
        self.bottomLine.width = self.width - _leftFreeSpace - _rightFreeSpace;
        [self.bottomLine setHidden:NO];
    }
    else if (style == CellLineStyleFill) {
        self.bottomLine.x = 0;
        self.bottomLine.width = self.width;
        [self.bottomLine setHidden:NO];
    }
    else if (style == CellLineStyleNone) {
        [self.bottomLine setHidden:YES];
    }
}

- (UIView *) bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.height =0.5f;
        [_bottomLine setBackgroundColor:kLineColer];
        [_bottomLine setAlpha:1];
        [self.contentView addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (UIView *) topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] init];
        _topLine.height = 0.5f;
        [_topLine setBackgroundColor:kLineColer];
        [_topLine setAlpha:1];
        [self.contentView addSubview:_topLine];
    }
    return _topLine;
}



@end

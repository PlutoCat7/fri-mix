//
//  GBPositionTinyLabel.m
//  GB_Football
//
//  Created by Pizza on 16/8/9.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPositionTinyLabel.h"
#import "XXNibBridge.h"
#import "LogicManager.h"

@interface GBPositionTinyLabel()<XXNibBridge>
@property (weak, nonatomic) IBOutlet UILabel *posNameLabel;
@property (weak, nonatomic) IBOutlet UIView *colorBar;
@end

@implementation GBPositionTinyLabel
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI
{
    self.posNameLabel.text = [LogicManager englishPositonWithIndex:self.tag];
    self.colorBar.backgroundColor = [LogicManager positonColorWithIndex:self.tag];
}

#pragma mark - Getter and Setter

@end

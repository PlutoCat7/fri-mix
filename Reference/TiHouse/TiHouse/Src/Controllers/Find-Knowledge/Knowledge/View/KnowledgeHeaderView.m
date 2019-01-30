//
//  KnowledgeHeaderView.m
//  TiHouse
//
//  Created by weilai on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "KnowledgeHeaderView.h"

@interface KnowledgeHeaderView()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation KnowledgeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.bgView.layer setMasksToBounds:YES];
    [self.bgView.layer setCornerRadius:5.f];
}

- (IBAction)actionSearch:(id)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end

//
//  TacticeHeaderView.m
//  GB_Football
//
//  Created by yahua on 2017/12/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TacticeHeaderView.h"

@interface TacticeHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation TacticeHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (CGSize)intrinsicContentSize {
    
    return CGSizeMake(200, 44);
}

- (IBAction)actionAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddStep)]) {
        [self.delegate didClickAddStep];
    }
}

- (IBAction)deleteAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDeleteStep)]) {
        [self.delegate didClickDeleteStep];
    }
}

@end

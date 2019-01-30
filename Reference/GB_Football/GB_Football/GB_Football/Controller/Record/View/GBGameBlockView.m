//
//  GBGameBlockView.m
//  GB_Football
//
//  Created by Pizza on 16/8/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBGameBlockView.h"
#import "GBPointBlock.h"
#import "XXNibBridge.h"

@interface GBGameBlockView()<XXNibBridge>
@property (strong, nonatomic) IBOutletCollection(GBPointBlock) NSArray *positionBlock;
@end

@implementation GBGameBlockView

-(void)showWithPositionTag:(NSInteger)tag
{
    [self animation:tag];
}

-(void)animation:(NSInteger)index
{
    GBPointBlock* block = self.positionBlock[index];
    block.alpha = 1.0f;
}
@end

//
//  GBPositionCourtView.m
//  GB_Football
//
//  Created by Pizza on 16/8/9.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPositionCourtView.h"
#import "XXNibBridge.h"
#import "GBPositionTinyLabel.h"

@interface GBPositionCourtView()<XXNibBridge>
@property (strong, nonatomic) IBOutletCollection(GBPositionTinyLabel) NSArray *collectionItem;
@end

@implementation GBPositionCourtView
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}
-(void)setupUI
{
    
}

-(void)showPostionWithTag:(NSInteger)tag
{
    for (GBPositionTinyLabel *label in self.collectionItem)
    {
        label.hidden = YES;
        if (label.tag == tag) {
            label.hidden = NO;
        }
    }
}

@end

//
//  GBSortPan.m
//  GB_Team
//
//  Created by Pizza on 2016/11/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSortPan.h"
#import "XXNibBridge.h"

@interface GBSortPan()<XXNibBridge>

@property (strong, nonatomic) IBOutletCollection(UIView)        NSArray *backViews;
@property (strong, nonatomic) IBOutletCollection(UILabel)       NSArray *labels;
@property (strong, nonatomic) IBOutletCollection(UIImageView)   NSArray *imageViews;

@end

@implementation GBSortPan

-(void)awakeFromNib
{
    [super awakeFromNib];
}


-(void)setIndex:(NSInteger)index
{
    _index = index;
    [self setup:index];
}

-(void)setup:(NSInteger)index
{
    for (int i = 0 ; i < 3; i++)
    {
        if (i == index)
        {
            ((UIView*)self.backViews[i]).backgroundColor = [UIColor colorWithHex:0x2d2f35];
            ((UIImageView*)self.imageViews[i]).image = [UIImage imageNamed:@"ranking_p"];
            ((UILabel*)self.labels[i]).textColor = [UIColor greenColor];
        }
        else
        {
            ((UIView*)self.backViews[i]).backgroundColor = [UIColor colorWithHex:0x171717];
            ((UIImageView*)self.imageViews[i]).image = [UIImage imageNamed:@"ranking_n"];
            ((UILabel*)self.labels[i]).textColor = [UIColor whiteColor];
        }
    }
}
- (IBAction)actionPressed:(id)sender
{
    UIButton* button = (UIButton*)sender;
    _index = button.tag;
    [self setup:button.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(GBSortPan:index:)])
    {
        [self.delegate GBSortPan:self index:_index];
    }
}

@end

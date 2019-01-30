//
//  GBAxiBar.m
//  GB_Football
//
//  Created by Pizza on 2017/1/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBAxiBar.h"
#import "GBAxi.h"

@interface GBAxiBar()
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@end


@implementation GBAxiBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.width = self.frame.size.width;
        self.height = self.frame.size.height;
    }
    return self;
}

-(void)showWithTitles:(NSArray<NSString*>*)titles
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:titles];
    array = (NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
    for (int i = 0; i < [array count]; i++){
        GBAxi *axi = [[[NSBundle mainBundle] loadNibNamed:@"GBAxi" owner:nil options:nil] lastObject];
        axi.frame = CGRectMake(0,self.height/[array count]*i,self.width, self.height/[array count]);
        axi.axiLabel.text = array[i];
        [self addSubview:axi];
    }
}

@end

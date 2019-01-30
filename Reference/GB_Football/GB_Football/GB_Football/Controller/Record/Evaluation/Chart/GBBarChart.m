//
//  GBBarChart.m
//  GB_Football
//
//  Created by Pizza on 2017/1/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBarChart.h"
#import "GBBar.h"

#define kBottomGap 10
#define kLine      0.5f

@interface GBBarChart()
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign) CGFloat gapWidth;
@property (nonatomic,assign) CGFloat barWidth;
@property (nonatomic,strong) NSMutableArray<NSNumber*> *progressArray;
@property (nonatomic,strong) NSMutableArray<GBBar*>    *barArray;
@end

@implementation GBBarChart

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.width      = self.frame.size.width;
        self.height     = self.frame.size.height;
        self.progressArray = [[NSMutableArray alloc]init];
        self.barArray   = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)showWithTopValue:(NSArray<NSString*>*)topValue
            bottomValue:(NSArray<NSString*>*)bottomValue
               progress:(NSArray<NSNumber*>*)progress
{
    self.barWidth   = (self.width/((1.25f*([progress count]+1)+[progress count])*1.f));
    self.gapWidth   = 1.25f*self.barWidth;
    for(int i = 0 ; i < [progress count] ;i++)
    {
        GBBar *bar = [[[NSBundle mainBundle] loadNibNamed:@"GBBar" owner:nil options:nil] lastObject];
        bar.frame = CGRectMake(self.gapWidth+i*(self.barWidth+self.gapWidth),0,self.barWidth,self.height);
        bar.topLabel.text = topValue[i];
        bar.topLabel.minimumScaleFactor = 0.1f;
        bar.topLabel.adjustsFontSizeToFitWidth = YES;
        bar.axiLabel.text = bottomValue[i];
        bar.axiLabel.minimumScaleFactor = 0.1f;
        bar.axiLabel.adjustsFontSizeToFitWidth = YES;
        bar.progress.constant = 0;
        [self.barArray addObject:bar];
        [self.progressArray addObject:@(self.height*[progress[i] floatValue])];
        [self addSubview:bar];
    }
    UIView *lineLeft = [[UIView alloc]initWithFrame:CGRectMake(0,kBottomGap,kLine,self.height-2*kBottomGap-kLine)];
    lineLeft.backgroundColor = [UIColor blackColor];
    lineLeft.alpha = kLine;
    [self addSubview:lineLeft];
    UIView *lineHorizon = [[UIView alloc]initWithFrame:CGRectMake(0,self.height-kBottomGap-kLine,self.width,kLine)];
    lineHorizon.backgroundColor = [UIColor blackColor];
    lineHorizon.alpha = kLine;
    [self addSubview:lineHorizon];
}

-(void)showProgressWithAnimation
{
    for (int i = 0 ; i < [self.barArray count]; i++) {
        GBBar *bar = (GBBar*)self.barArray[i];
        bar.progress.constant = [self.progressArray[i] floatValue];
    }
    [UIView animateWithDuration:1.5f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
         [self layoutIfNeeded];
    } completion:^(BOOL ok){}];
}

-(void)resetProgressWithAnimation
{
    for (int i = 0 ; i < [self.barArray count]; i++) {
        GBBar *bar = (GBBar*)self.barArray[i];
        bar.progress.constant = 0;
    }
}

@end

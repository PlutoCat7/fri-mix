//
//  GBEvaluationBoardViewController.m
//  GB_Football
//
//  Created by Pizza on 2017/1/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBEvaluationBoardViewController.h"
#import "GBEvaluationBoard.h"
#import "GBAchievementViewController.h"

@interface GBEvaluationBoardViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet GBEvaluationBoard *evaluationBoard;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@end

@implementation GBEvaluationBoardViewController

-(void)initLoadData{
    [self.evaluationBoard showBarChartAnimation];
}

-(void)setupUI{

}

- (UIImage *)getViewShareImage {
    
    UIScrollView *scrollView =  self.scrollerView;
    if (!scrollView) {
        return nil;
    }
    
    CGFloat oldheight = scrollView.height;
    CGPoint oldContentOffset = scrollView.contentOffset;
    
    scrollView.height = fmaxf(scrollView.contentSize.height, oldheight);
    scrollView.contentOffset = CGPointMake(0, 0);
    UIImage *shareImage = [LogicManager getImageWithHeadImage:nil subviews:@[scrollView] backgroundImage:[UIImage imageWithColor:[UIColor blackColor]]];
    
    scrollView.height = oldheight;
    scrollView.contentOffset = oldContentOffset;
    
    return shareImage;
}

-(void)drawWithChart:(BarChartModel*)chartModel matchInfo:(MatchInfo*)matchInfo playerId:(NSInteger)playerId {
    CGFloat heightBase = ([UIScreen mainScreen].bounds.size.width * 880.f/750.f)+200.f;
    BOOL isHaverow5 = matchInfo.globalData.consume < 106.47 ? NO:YES;
    self.contentHeight.constant = heightBase+(isHaverow5?5*111.f:4*111.f);
    [self.scrollerView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width,self.contentHeight.constant)];
    @weakify(self)
    self.evaluationBoard.actionClickAchivement = ^{
        @strongify(self)
        UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
        GBAchievementViewController *vc = [[GBAchievementViewController alloc] initWithAchieve:matchInfo.achieve isShowShare:(playerId == userInfo.userId)];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    };
    [self.evaluationBoard reloadTableWith:matchInfo];
    [self.evaluationBoard drawChartWithBarChartModel:chartModel];
}
    
    
@end

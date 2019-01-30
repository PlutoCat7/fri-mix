//
//  GBGameTimeDivisionCompletePreview.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameTimeDivisionCompletePreview.h"
#import <pop/POP.h>
#import "GBBoxButton.h"
#import "GBTimeDivisionCompletePreviewTableViewCell.h"

@interface GBGameTimeDivisionCompletePreview ()<UITableViewDelegate,
UITableViewDataSource>

// 弹出框背景（动画用）
@property (weak, nonatomic) IBOutlet UIView *tipBack;
// 弹出框   （动画用）
@property (weak, nonatomic) IBOutlet UIView *boxView;

@property (weak, nonatomic) IBOutlet UILabel *gameTime;

@property (weak, nonatomic) IBOutlet UITableView *sectionTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *partitionViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boxViewConstraint;

@property (weak, nonatomic) IBOutlet UILabel *weScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherScore;

// 静态国际化标签
@property (weak, nonatomic) IBOutlet UILabel *titleStLabel;
@property (weak, nonatomic) IBOutlet UILabel *wholeStLabel;
@property (weak, nonatomic) IBOutlet UILabel *ourStLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppStLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreStLabel;
@property (weak, nonatomic) IBOutlet GBBoxButton *cancelStButton;
@property (weak, nonatomic) IBOutlet GBBoxButton *okStButton;

@property (nonatomic, copy) void(^completeBlock)(NSInteger index);
@property (nonatomic, strong) NSArray<NSArray<NSDate *> *> *sectionDateList;

@end

@implementation GBGameTimeDivisionCompletePreview

-(void)localizeUI{
    
    self.titleStLabel.text = LS(@"post.popbox.title");
    self.wholeStLabel.text = LS(@"post.popbox.label.whole");
    self.ourStLabel.text = LS(@"post.popbox.label.our");
    self.oppStLabel.text = LS(@"post.popbox.label.opp");
    self.scoreStLabel.text = LS(@"post.popbox.label.score");
    [self.cancelStButton setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.okStButton setTitle:LS(@"common.btn.yes") forState:UIControlStateNormal];
    
}
+ (void)showWithComplete:(void(^)(NSInteger index))complete
         sectionDateList:(NSArray<NSArray<NSDate *> *> *)sectionDateList
                 weScore:(NSInteger)wescore
                oppScore:(NSInteger)oppScore {
    
    if (sectionDateList.count <= 0 ) {
        return;
    }
    
    NSArray *xibArray= [[NSBundle mainBundle]loadNibNamed:@"GBGameTimeDivisionCompletePreview" owner:nil options:nil];
    GBGameTimeDivisionCompletePreview *preView = [xibArray firstObject];
    preView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [preView localizeUI];
    preView.sectionDateList = sectionDateList;
    [preView.sectionTableView reloadData];
    preView.completeBlock = complete;
    NSInteger gameTime = 0;
    for (NSArray *dateList in sectionDateList) {
        gameTime += [dateList.lastObject minutesAfterDate:dateList.firstObject];
    }
    preView.gameTime.text = @(gameTime).stringValue;
    preView.weScoreLabel.text = @(wescore).stringValue;
    preView.otherScore.text = @(oppScore).stringValue;
    [[UIApplication sharedApplication].keyWindow addSubview:preView];
    [preView showPopBox];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setupTableView];
    [self localizeUI];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self resetTableViewHeight];
}

- (void)setupTableView {
    
    [self.sectionTableView registerNib:[UINib nibWithNibName:@"GBTimeDivisionCompletePreviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"GBTimeDivisionCompletePreviewTableViewCell"];
    self.sectionTableView.delegate = self;
    self.sectionTableView.dataSource = self;
    self.sectionTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.sectionTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self resetTableViewHeight];
}

- (void)resetTableViewHeight {
    
    self.tableViewConstraint.constant = 26*self.sectionDateList.count*kAppScale;
    self.contentViewConstraint.constant = 130*kAppScale + 20 + self.tableViewConstraint.constant;
    self.boxViewConstraint.constant = 43*kAppScale + 74*kAppScale + self.contentViewConstraint.constant;
    if (self.sectionDateList.count == 1) {
        self.partitionViewConstraint.constant = 26*kAppScale;
    }
}

#pragma mark - Action

- (IBAction)cancelEvent:(id)sender {
    
    [self hidePopBox];
    BLOCK_EXEC(self.completeBlock, 0);
}

- (IBAction)okEvent:(id)sender {
    
    [self hidePopBox];
    BLOCK_EXEC(self.completeBlock, 1);
}


#pragma mark - Private

- (void)showPopBox {
    
    self.tipBack.alpha = 0;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(1.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = NO;
        self.tipBack.alpha = 1.f;
        [self.tipBack pop_removeAnimationForKey:@"alpha"];
    };
    [self.tipBack pop_addAnimation:anim forKey:@"alpha"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
    scaleAnimation.toValue   = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 15.f;
    scaleAnimation.completionBlock = ^(POPAnimation * animation, BOOL finish){
        [self.boxView.layer pop_removeAnimationForKey:@"scaleAnim"];
    };
    [self.boxView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void)hidePopBox
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(0.0);    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = YES;
        self.tipBack.alpha = 0.f;
        [self.tipBack pop_removeAnimationForKey:@"alpha"];
        [self removeFromSuperview];
    };
    [self.tipBack pop_addAnimation:anim forKey:@"alpha"];
}

-(void)dealloc
{
    [self.boxView.layer pop_removeAllAnimations];
    [self.tipBack pop_removeAllAnimations];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sectionDateList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 26*kAppScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray<NSDate *> *list = self.sectionDateList[indexPath.row];
    NSString *startTime = [NSString stringWithFormat:@"%02zd:%02zd", list.firstObject.hour, list.firstObject.minute];
    NSString *endTime = [NSString stringWithFormat:@"%02zd:%02zd",list.lastObject.hour, list.lastObject.minute];
    
    GBTimeDivisionCompletePreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBTimeDivisionCompletePreviewTableViewCell"];
    cell.beginTimeLabel.text = startTime;
    cell.endTimeLabel.text = endTime;
    NSDictionary *chineseDic = @{@"0":LS(@"multi-section.section.one"),
                                 @"1":LS(@"multi-section.section.two"),
                                 @"2":LS(@"multi-section.section.three"),
                                 @"3":LS(@"multi-section.section.four"),
                                 @"4":LS(@"multi-section.section.five")};
    cell.sectionNameLabel.text = chineseDic[@(indexPath.row).stringValue];
    return cell;
}

@end

//
//  PhotoFavorPan.m
//  TiHouse
//
//  Created by weilai on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PhotoFavorPan.h"
#import "PhotoFavorTableViewCell.h"

#import <objc/runtime.h>
#import <pop/POP.h>


@interface PhotoFavorPan() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgMaskView;
@property (weak, nonatomic) IBOutlet UIView *panView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containLayoutConstraint;

@property (weak, nonatomic) FindKnowledgeBaseViewController *vc;

@end


@implementation PhotoFavorPan

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

// 界面展示
+(PhotoFavorPan*)showPhotoFavorPanWithDelegate:(NSArray <SoulFolderInfo *> *)folderArray delegate:(id<PhotoFavorPanDelegate>)delegate vc:(FindKnowledgeBaseViewController *)vc{
    PhotoFavorPan *sharePan = [ [[NSBundle mainBundle]loadNibNamed:@"PhotoFavorPan" owner:nil options:nil] firstObject];
    sharePan.frame = [UIApplication sharedApplication].keyWindow.bounds;
    sharePan.delegate = delegate;
    sharePan.floderArray = [NSMutableArray arrayWithArray:folderArray];
    sharePan.vc = vc;

//    [[UIApplication sharedApplication].keyWindow addSubview:sharePan];
    [sharePan.vc.view addSubview:sharePan];
    [sharePan animationShow];
    return sharePan;
}

// 直接界面移除
-(void)hide:(void(^)(BOOL success))complete
{
//    UIView *view = [UIApplication sharedApplication].keyWindow;
//    NSArray *subViewsArray = view.subviews;
    NSArray *subViewsArray = self.vc.view.subviews;
    Class hudClass = [PhotoFavorPan class];
    for (UIView *aView in subViewsArray)
    {
        if ([aView isKindOfClass:hudClass])
        {
            PhotoFavorPan *hud = (PhotoFavorPan *)aView;
            [hud animationHide:^(BOOL success){
                complete(success);
            }];
        }
    }
}

- (IBAction)actionCancel:(id)sender {
    [self animationHide:^(BOOL success){
        if ([self.delegate respondsToSelector:@selector(PhotoFavorPanActionCancel:)])
        {
            [self.delegate PhotoFavorPanActionCancel:self];
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(PhotoFavorPanActionWillHide:)])
    {
        [self.delegate PhotoFavorPanActionWillHide:self];
    }
}
- (IBAction)actionBgCancel:(id)sender {
    [self animationHide:^(BOOL success){
        if ([self.delegate respondsToSelector:@selector(PhotoFavorPanActionCancel:)])
        {
            [self.delegate PhotoFavorPanActionCancel:self];
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(PhotoFavorPanActionWillHide:)])
    {
        [self.delegate PhotoFavorPanActionWillHide:self];
    }
}
- (IBAction)actionCreateFolder:(id)sender {
    if ([self.delegate respondsToSelector:@selector(PhotoFavorPanActionAdd:)]) {
        [self.delegate PhotoFavorPanActionAdd:self];
    }
}


#pragma Getter & Setter
- (void)setFloderArray:(NSMutableArray<SoulFolderInfo *> *)floderArray {
    _floderArray = floderArray;
    
    CGFloat height = _floderArray.count * 50 + 180;
    if (height > kScreen_Height) {
        self.containLayoutConstraint.constant = kScreen_Height;
        self.tableView.scrollEnabled = YES;
    } else {
        self.containLayoutConstraint.constant = height;
        self.tableView.scrollEnabled = NO;
    }

    [self.tableView reloadData];
}

#pragma --
#pragma mark 动画


- (void)animationShow
{
    if ([self.delegate respondsToSelector:@selector(PhotoFavorPanActionWillShow:)])
    {
        [self.delegate PhotoFavorPanActionWillShow:self];
    }
    
    // 半透明背景
    self.bgMaskView.alpha = 0;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(1.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = NO;
        self.bgMaskView.alpha = 1.f;
        [self.bgMaskView pop_removeAnimationForKey:@"alpha"];
    };
    [self.bgMaskView pop_addAnimation:anim forKey:@"alpha"];
    
    // 推出弹框
    self.panView.top = self.panView.superview.height;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.panView.top = self.panView.superview.height - self.panView.height;
    } completion:nil];
    
}

-(void)animationHide:(void(^)(BOOL success))complete
{
    // 半透明背景
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(0.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = YES;
        self.bgMaskView.alpha = 0.f;
        [self.bgMaskView pop_removeAnimationForKey:@"alpha"];
        [self removeFromSuperview];
        complete(finish);
    };
    [self.bgMaskView pop_addAnimation:anim forKey:@"alpha"];
    // 推出弹框
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @([UIScreen mainScreen].bounds.size.height+self.panView.size.height/2);
    [self.panView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished){
            [self.panView.layer pop_removeAnimationForKey:@"positionAnimation"];
        }};
}

// 根据手机上是否安装客户端几种情况控制布局
-(void)setup {
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoFavorTableViewCell" bundle:nil] forCellReuseIdentifier:@"PhotoFavorTableViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.floderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoFavorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoFavorTableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    [cell refreshWithSoulFolder:self.floderArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(PhotoFavorPanAction:index:)]) {
        [self.delegate PhotoFavorPanAction:self index:indexPath.row];
    }
}

@end

//
//  ArrangeViewController.m
//  TiHouse
//
//  Created by weilai on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ArrangeViewController.h"
#import "SADataListViewController.h"
#import "SAFavorViewController.h"
#import "SASearchViewController.h"

@interface ArrangeViewController ()
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet UIView *favorButtonShadowView;
@end

@implementation ArrangeViewController

- (void)setupUI {
    
    self.title = @"家居风水";
    
    [self.searchView.layer setMasksToBounds:YES];
    [self.searchView.layer setCornerRadius:5.f];
    
    [self.favorButton.layer setMasksToBounds:YES];
    [self.favorButton.layer setCornerRadius:25.f];
    CALayer *sublayer =[CALayer layer];
    sublayer.backgroundColor = [UIColor colorWithRGBHex:0xFDF086].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius = 5.0;
    sublayer.shadowColor =[UIColor colorWithRGBHex:0xF2DF90].CGColor;
    sublayer.shadowOpacity = 1.0;
    sublayer.frame = CGRectMake(0, 0, kScreen_Width-90, self.favorButtonShadowView.height);
    sublayer.cornerRadius = 25.0;
    [self.favorButtonShadowView.layer addSublayer:sublayer];
}

#pragma mark - Action

- (IBAction)actionSearch:(id)sender {
    SASearchViewController *viewController = [[SASearchViewController alloc] initWithKnowType:KnowType_None knowTypeSub:KnowTypeSub_Arrange];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)actionFavor:(id)sender {
    SAFavorViewController *viewController = [[SAFavorViewController alloc] initWithKnowType:KnowType_None knowTypeSub:KnowTypeSub_Arrange];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)actionLiveRoom:(id)sender {
    [self openDetailViewController:KnowType_FLiveroom];
}

- (IBAction)actionRoom:(id)sender {
    [self openDetailViewController:KnowType_FRoom];
}

- (IBAction)actionToliet:(id)sender {
    [self openDetailViewController:KnowType_FToilet];
}

- (IBAction)actionKitchen:(id)sender {
    [self openDetailViewController:KnowType_FKitchen];
}

- (IBAction)actionRestaurant:(id)sender {
    [self openDetailViewController:KnowType_FRestaurant];
}

- (IBAction)actionOther:(id)sender {
    [self openDetailViewController:KnowType_FOther];
}

#pragma mark - private
- (void)openDetailViewController:(KnowType)knowType {
    SADataListViewController *viewController = [[SADataListViewController alloc] initWithKnowType:knowType knowTypeSub:KnowTypeSub_Arrange];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end

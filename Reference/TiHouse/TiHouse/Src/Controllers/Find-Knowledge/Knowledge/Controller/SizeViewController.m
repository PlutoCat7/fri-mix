//
//  SizeViewController.m
//  TiHouse
//
//  Created by weilai on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SizeViewController.h"
#import "SADataListViewController.h"
#import "SAFavorViewController.h"
#import "SASearchViewController.h"

@interface SizeViewController ()

@property (weak, nonatomic) IBOutlet UIView *favorButtonShadowView;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@end

@implementation SizeViewController

- (void)setupUI {
    
    self.title = @"尺寸宝典";
    
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
    SASearchViewController *viewController = [[SASearchViewController alloc] initWithKnowType:KnowType_None knowTypeSub:KnowTypeSub_Size];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)actionFavor:(id)sender {
    SAFavorViewController *viewController = [[SAFavorViewController alloc] initWithKnowType:KnowType_None knowTypeSub:KnowTypeSub_Size];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)actionFurniture:(id)sender {
    [self openDetailViewController:KnowType_SFurniture];
}

- (IBAction)actionIndoor:(id)sender {
    [self openDetailViewController:KnowType_SIndoor];
}

- (IBAction)actionLiveRoom:(id)sender {
    [self openDetailViewController:KnowType_SLiveroom];
}

- (IBAction)actionRestaurant:(id)sender {
    [self openDetailViewController:KnowType_SRestaurant];
}

- (IBAction)actionRoom:(id)sender {
    [self openDetailViewController:KnowType_SRoom];
}

- (IBAction)actionKitchen:(id)sender {
    [self openDetailViewController:KnowType_SKitchen];
}

#pragma mark - private
- (void)openDetailViewController:(KnowType)knowType {
    SADataListViewController *viewController = [[SADataListViewController alloc] initWithKnowType:knowType knowTypeSub:KnowTypeSub_Size];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end

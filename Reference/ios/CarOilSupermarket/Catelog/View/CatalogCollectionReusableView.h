//
//  CatalogCollectionReusableView.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/11.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CatalogCollectionReusableView;
@protocol CatalogCollectionReusableViewDelegate <NSObject>

- (void)didClickCatalogCollectionReusableView:(CatalogCollectionReusableView *)view;

@end

@interface CatalogCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *catalogTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (nonatomic, weak) id<CatalogCollectionReusableViewDelegate> delegate;
@property (nonatomic, assign) NSInteger section;

@end

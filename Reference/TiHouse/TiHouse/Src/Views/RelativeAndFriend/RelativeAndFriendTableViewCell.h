//
//  RelativeAndFriendTableViewCell.h
//  TiHouse
//
//  Created by guansong on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Houseperson.h"
@interface RelativeAndFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailLable;
@property (weak, nonatomic) IBOutlet UILabel *masterTitle;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLatout;

@property (assign, nonatomic) BOOL isLastRow;

-(void)loadViewWtithModel:(Houseperson *) model;

@end

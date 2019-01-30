//
//  RelativeAndFriendHeadView.h
//  TiHouse
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"
#import "Houseperson.h"
#import "House.h"

typedef void(^RelativeAndFriendHeadViewBlock)(Houseperson *per);

@interface RelativeAndFriendHeadView : BaseView

@property (weak, nonatomic) IBOutlet UIImageView *fHead;
@property (weak, nonatomic) IBOutlet UIImageView *mHead;
@property (weak, nonatomic) IBOutlet UIImageView *mMe;
@property (weak, nonatomic) IBOutlet UIImageView *fMe;
@property (weak, nonatomic) IBOutlet UILabel *manLabel;
@property (weak, nonatomic) IBOutlet UILabel *womanLabel;

@property (nonatomic, strong) House *house;


@property (weak, nonatomic) IBOutlet UILabel *fTime;
@property (weak, nonatomic) IBOutlet UILabel *mTime;

@property (nonatomic,copy) RelativeAndFriendHeadViewBlock  callback;

@property (nonatomic,strong) NSArray * masters;

@end

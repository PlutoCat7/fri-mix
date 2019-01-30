//
//  InvitationCodeViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/17.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"

@protocol InvitationCodeViewControllerDelegate;

@interface InvitationCodeViewController : BaseViewController

@property (nonatomic, weak  ) id<InvitationCodeViewControllerDelegate> delegate;

@end

@protocol InvitationCodeViewControllerDelegate<NSObject>

- (void)invitationCodeViewController:(InvitationCodeViewController *)controller createRelationShipSuccessedWithHouseId:(NSInteger)houseId;

@end

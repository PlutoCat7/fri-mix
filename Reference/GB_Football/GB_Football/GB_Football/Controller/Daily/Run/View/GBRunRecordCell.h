//
//  GBRunRecordCell.h
//  GB_Football
//
//  Created by gxd on 17/7/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBRunRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceUnitLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *durationLbl;
@property (weak, nonatomic) IBOutlet UILabel *calorieLbl;
@property (weak, nonatomic) IBOutlet UILabel *speedLbl;

@end

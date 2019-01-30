//
//  TeamDataNoDataView.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamDataNoDataView.h"

@interface TeamDataNoDataView ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation TeamDataNoDataView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.tipsLabel.text = LS(@"team.data.no.data.tips");
}

@end

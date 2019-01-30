//
//  GameRecordTableViewCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GameRecordTableViewCell.h"
#import "RecordListCellModel.h"

@interface GameRecordTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *proceessingLogo;


@end

@implementation GameRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self localizeUI];
}

-(void)localizeUI{
    self.nameTitleLabel.text = LS(@"record.label.name");
    self.addressTitleLabel.text = LS(@"record.label.loaction");
    self.typeTitleLabel.text = LS(@"record.label.type");
    BOOL isEnglish = [[LanguageManager sharedLanguageManager] isEnglish];
    self.proceessingLogo.image = isEnglish?[UIImage imageNamed:@"processing_en"]:[UIImage imageNamed:@"processing_ch"];
}

- (void)refreshWithModel:(RecordListCellModel *)model {
    
    self.dateDayLabel.text = model.dayString;
    self.dateMonthLabel.text = model.yearMonthString;
    self.nameLabel.text = model.matchName;
    self.addressLabel.text = model.matchAddress;
    self.typeLabel.text = model.matchTypeString;
    self.isWating = model.isWating;
}

-(void)setIsWating:(BOOL)isWating
{
    _isWating = isWating;
    if (_isWating) {
        self.waitingView.alpha = 1.f;
    } else{
        self.waitingView.alpha = 0.f;
    }
}

@end

//
//  AddTallyViewDateSynchroCell.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddTallyViewDateSynchroCell.h"

@interface AddTallyViewDateSynchroCell()

@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UISwitch *synchroSwitch;
@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation AddTallyViewDateSynchroCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = YES;
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(containDeteStr:)
                              name:@"ContainDeteStrNotification" object:nil];
        
        UIImageView *iconImageView = [UIImageView new];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@15);
            make.leading.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(16.5);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = XWColorFromHex(0x646464);
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumScaleFactor = 0.5;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.leading.equalTo(iconImageView.mas_trailing).offset(10);
        }];
        
        UISwitch *synchroSwitch = [UISwitch new];
        [synchroSwitch setOn:NO];
        [self.contentView addSubview:synchroSwitch];
        self.synchroSwitch = synchroSwitch;
        [synchroSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@52);
            make.height.equalTo(@30);
            make.trailing.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
            make.leading.equalTo(titleLabel.mas_trailing);
        }];
        
        self.titleLabel.text = @"发现事项中包含日期，是否同步到日程？";
        self.titleLabel.textColor = XWColorFromHex(0xFFC125);
        self.iconImageView.image = [UIImage imageNamed:@"Tally_add_icon_calendar"];
    }
    return self;
}

- (void)containDeteStr:(NSNotification *)notification {
    if (notification.userInfo[@"containDeteStr"]) {
        BOOL iscontainDete = [notification.userInfo[@"containDeteStr"] boolValue];
        [self setCellInfo:iscontainDete];
    }
}

- (void)setCellInfo:(BOOL)containDeteStr {
    [self refreshCellHeight:containDeteStr?50:0];
}

- (void)refreshCellHeight:(CGFloat)height {
    _cellHeight = height;
    
    id<AddTallyViewDateSynchroCellDelegate> delegate = (id<AddTallyViewDateSynchroCellDelegate>)self.tableView.delegate;
    
    CGFloat newHeight = [self cellHeight];
    CGFloat oldHeight = [delegate tableView:self.tableView heightForRowAtIndexPath:self.indexPath];
    if (fabs(newHeight - oldHeight) > 0.01) {
        
        // update the height
        if ([delegate respondsToSelector:@selector(tableView:updatedHeight:atIndexPath:)]) {
            [delegate tableView:self.tableView
                  updatedHeight:newHeight
                    atIndexPath:self.indexPath];
        }
        
        // refresh
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

- (IBAction)switchValueChangedAction:(UISwitch *)sender {
    if (!sender.isOn) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(addTallyViewDateSynchroCellTimeSynchro:)]) {
        [_delegate addTallyViewDateSynchroCellTimeSynchro:self];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation UITableView (AddTallyViewDateSynchroCell)

- (AddTallyViewDateSynchroCell *)addTallyViewDateSynchroCellWithId:(NSString *)cellId {
    AddTallyViewDateSynchroCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[AddTallyViewDateSynchroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tableView = self;
    return cell;
}
@end

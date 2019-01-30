//
//  GBBindPlayerCell.m
//  GB_Team
//
//  Created by weilai on 16/9/27.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBindPlayerCell.h"
#import "GBPositionLabel.h"
#import "UIImageView+WebCache.h"

@interface GBBindPlayerCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel1;
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *unbindLbl;
@property (weak, nonatomic) IBOutlet UILabel *unselectLbl;
@property (weak, nonatomic) IBOutlet UILabel *wristNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *findWristLbl;
@property (weak, nonatomic) IBOutlet UIButton *unbindButton;
@property (weak, nonatomic) IBOutlet UIButton *findWristButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *findIndicator;
@property (weak, nonatomic) IBOutlet UIButton *starSearchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *starSearchIndicator;

@property (strong, nonatomic) PlayerBindInfo *playerBindInfo;

@end

@implementation GBBindPlayerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.clipsToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionUnbindWrist:(id)sender {
    if (self.unbindHandler) {
        self.unbindHandler(self.playerBindInfo);
    }
}

- (IBAction)actionFindWrist:(id)sender {
    if (self.checkWristbandHandler) {
        self.checkWristbandHandler(self.playerBindInfo);
    }
}

- (void)refreshWithPlayerBindInfo:(PlayerBindInfo *)playerBindInfo selected:(BOOL)selected {
    if (playerBindInfo == nil || playerBindInfo.playerInfo == nil) {
        return;
    }
    self.playerBindInfo = playerBindInfo;
    
    PlayerInfo *playerInfo = playerBindInfo.playerInfo;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:playerInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"portrait_placeholder"]];
    self.nameLbl.text = playerInfo.playerName;
    self.numberLbl.text = [NSString stringWithFormat:@"%td号", playerInfo.playerNum];
    
    NSArray<NSString*> *selectList = @[];
    if (![NSString stringIsNullOrEmpty:playerInfo.position]) {
        selectList = [playerInfo.position componentsSeparatedByString:@","];
    }
    if (selectList.count > 0) {
        self.positionLabel1.hidden = NO;
        self.positionLabel1.index = selectList.firstObject.integerValue;
    } else {
        self.positionLabel1.hidden = YES;
    }
    if (selectList.count > 1) {
        self.positionLabel2.hidden = NO;
        self.positionLabel2.index = selectList.lastObject.integerValue;
    } else {
        self.positionLabel2.hidden = YES;
    }
    
    if (selected) {
        [self.nameLbl setTextColor:[ColorManager styleColor]];
        [self.numberLbl setTextColor:[ColorManager styleColor]];
    } else {
        [self.nameLbl setTextColor:[UIColor whiteColor]];
        [self.numberLbl setTextColor:[UIColor whiteColor]];
    }
    
    WristbandInfo *wristbandInfo = playerBindInfo.wristbandInfo;
    if (wristbandInfo) {
        self.selectedImageView.hidden = YES;
        self.unselectLbl.hidden = YES;
        
        self.unbindLbl.hidden = NO;
        self.unbindButton.hidden = NO;
        self.wristNameLbl.hidden = NO;
        self.findWristLbl.hidden = NO;
        self.findWristButton.hidden = NO;
        
        self.wristNameLbl.text = wristbandInfo.name;
        [self starSearchIdle];
    } else {
        self.selectedImageView.hidden = NO;
        self.unselectLbl.hidden = NO;
        
        self.unbindLbl.hidden = YES;
        self.unbindButton.hidden = YES;
        self.wristNameLbl.hidden = YES;
        self.findWristLbl.hidden = YES;
        self.findWristButton.hidden = YES;
        self.selectedImageView.image = selected ? [UIImage imageNamed:@"bind_selected"] : [UIImage imageNamed:@"bind_unselect"];
        [self starSearchHiden];
    }
}

- (void)startSearchWrist {
    
    self.findIndicator.hidden = NO;
    [self.findIndicator startAnimating];
    self.findWristLbl.hidden = YES;
    self.findWristButton.hidden = YES;
}

- (void)stopSearchWrist {
    
    [self.findIndicator stopAnimating];
    self.findWristLbl.hidden = NO;
    self.findWristButton.hidden = NO;
}


#pragma mark -
#pragma mark 加速搜星

-(void)setSearchState:(STAR_SEARCH_STATE)searchState
{
    _searchState = searchState;
    switch (searchState)
    {
        case STAR_SEARCH_STATE_HIDDEN:
        {
            [self starSearchHiden];
        }
            break;
        case STAR_SEARCH_STATE_IDLE:
        {
            [self starSearchIdle];
        }
            break;
        case STAR_SEARCH_STATE_ING:
        case STAR_SEARCH_STATE_FINISH:
        {
            [self starSearching];
        }
            break;
        case STAR_SEARCH_STATE_COMPLETE:
        {
            [self starSearchFinished];
        }
            break;
        case STAR_SEARCH_STATE_FAILED:
        {
            [self starSearchFaied];
        }
            break;
        default:
            break;
    }
}

// 加速搜星，隐藏状态
-(void)starSearchHiden
{
    [self.starSearchIndicator stopAnimating];
    self.starSearchIndicator.hidden = YES;
    self.starSearchButton.hidden    = YES;
    self.starSearchButton.userInteractionEnabled = NO;
    self.starSearchButton.tag = 0;
    [self.starSearchButton setTitle:LS(@"") forState:UIControlStateNormal];
}

// 加速搜星,空闲状态
-(void)starSearchIdle
{
    [self.starSearchIndicator stopAnimating];
    self.starSearchIndicator.hidden = YES;
    self.starSearchButton.hidden    = NO;
    self.starSearchButton.userInteractionEnabled = YES;
    self.starSearchButton.tag = 0;
    [self.starSearchButton setTitle:LS(@"加速搜星") forState:UIControlStateNormal];
    [self.starSearchButton setTitleColor:[UIColor colorWithHex:0x54F5FF] forState:UIControlStateNormal];
}
// 加速搜星,已加速
-(void)starSearchFinished
{
    [self.starSearchIndicator stopAnimating];
    self.starSearchIndicator.hidden = YES;
    self.starSearchButton.hidden    = NO;
    self.starSearchButton.userInteractionEnabled = NO;
    self.starSearchButton.tag = 0;
    [self.starSearchButton setTitle:LS(@"成功") forState:UIControlStateNormal];
    [self.starSearchButton setTitleColor:[UIColor colorWithHex:0x3f3f3f] forState:UIControlStateNormal];
}

// 加速搜星,重新加速
-(void)starSearchFaied
{
    [self.starSearchIndicator stopAnimating];
    self.starSearchIndicator.hidden = YES;
    self.starSearchButton.hidden    = NO;
    self.starSearchButton.userInteractionEnabled = YES;
    self.starSearchButton.tag = 1;
    [self.starSearchButton setTitle:LS(@"重新加速") forState:UIControlStateNormal];
    [self.starSearchButton setTitleColor:[UIColor colorWithHex:0xFF0000] forState:UIControlStateNormal];
}
// 加速搜星，加速中
-(void)starSearching
{
    self.starSearchIndicator.hidden = NO;
    [self.starSearchIndicator startAnimating];
    self.starSearchButton.hidden    = YES;
    self.starSearchButton.userInteractionEnabled = NO;
}

// 按下加速搜星按钮
- (IBAction)actionPressStarSearch:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (self.starSearchHandler)
    {
        self.starSearchHandler(button.tag);
    }
}


@end

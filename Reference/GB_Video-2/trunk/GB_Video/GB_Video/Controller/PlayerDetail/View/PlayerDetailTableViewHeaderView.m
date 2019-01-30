//
//  PlayerDetailTableViewHeaderView.m
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "PlayerDetailTableViewHeaderView.h"
#import "PlayerDetailHeaderModel.h"

@interface PlayerDetailTableViewHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;

@end

@implementation PlayerDetailTableViewHeaderView

- (void)refreshWithModel:(PlayerDetailHeaderModel *)model {
    
    self.videoNameLabel.text = model.videoName;
    self.watchCountLabel.text = @(model.watchCount).stringValue;
    self.praiseButton.selected = model.isPraise;
    self.collectionButton.selected = model.isCollection;
}

#pragma mark - Delegate

- (IBAction)actionPraise:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(praiseWithPlayerDetailTableViewHeaderView:)]) {
        [_delegate praiseWithPlayerDetailTableViewHeaderView:self];
    }
}

- (IBAction)actionCollection:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(collectionWithPlayerDetailTableViewHeaderView:)]) {
        [_delegate collectionWithPlayerDetailTableViewHeaderView:self];
    }
}
@end

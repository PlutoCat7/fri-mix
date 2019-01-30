//
//  ArticlePreHeadherView.m
//  TiHouse
//
//  Created by yahua on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ArticlePreHeadherView.h"
#import "FindDraftSaveModel.h"
#import "Login.h"
#import "FindAssemarcInfo.h"

@interface ArticlePreHeadherView ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *editDateLabel;

@end

@implementation ArticlePreHeadherView

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userAvatorImageView.layer.cornerRadius = self.userAvatorImageView.height/2;
    });
}

- (void)refreshWithDraftModel:(FindDraftSaveModel *)model {
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverFullImageUrl]];
    self.titleLabel.text = model.title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.editTimeInterval];
    self.editDateLabel.text = [NSString stringWithFormat:@"%td.%02td.%02td", date.year, date.month, date.day];
    [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:[Login curLoginUser].urlhead] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    self.userNameLabel.text = [Login curLoginUser].username;
}

- (void)refreshWithAssemarcInfo:(FindAssemarcInfo *)info {
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:info.urlindex]];
    self.titleLabel.text = info.assemarctitle;
    self.editDateLabel.text = info.createtimeStr;
    [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:info.urlhead] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    self.userNameLabel.text = info.username;
}

+ (CGFloat)defaultHeight:(NSString *)content{
    
    CGFloat titleHeigt = [content getHeightWithFont:[UIFont systemFontOfSize:18.f] constrainedToSize:CGSizeMake(kRKBWIDTH(331), CGFLOAT_MAX)];
   
    return titleHeigt + kRKBWIDTH(190) + 100;
    
}



@end

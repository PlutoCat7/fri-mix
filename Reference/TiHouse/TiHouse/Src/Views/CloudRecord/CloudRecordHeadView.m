//
//  CloudRecordHeadView.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CloudRecordHeadView.h"
#import "CloudReListCountModel.h"
#import "MonthDairyModel.h"

@interface CloudRecordHeadView ()
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property (weak, nonatomic) IBOutlet UIImageView *recentImg;
@property (weak, nonatomic) IBOutlet UIImageView *allPhotoImg;
@property (weak, nonatomic) IBOutlet UILabel *allPhotoCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allVideoImg;
@property (weak, nonatomic) IBOutlet UILabel *allVideoCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *collectImg;
@property (weak, nonatomic) IBOutlet UILabel *collectCountLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CloudRecordHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bgView.layer setMasksToBounds:YES];
    [self.bgView.layer setCornerRadius:5.f];
}

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel {
    CloudRecordHeadView * cloudRecordHeadView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    return cloudRecordHeadView;
}

/**
 * 设置头部信息
 */
-(void)setCloudRecordHeadViewInfo:(NSArray *)dataArray {
    for (int i = 0; i < dataArray.count; i++) {
        MonthDairyModel * model = dataArray[i];
        if ([model.dairymonthfileJA[0] filetype] == 4) {
            //最近上传
            [self.recentImg sd_setImageWithURL:[NSURL URLWithString:[model.dairymonthfileJA[0] fileurlsmall]] placeholderImage:nil];
            
        } else if ([model.dairymonthfileJA[0] filetype] == 1) {
            //图片
            [self.allPhotoImg sd_setImageWithURL:[NSURL URLWithString:[model.dairymonthfileJA[0] fileurlsmall]] placeholderImage:nil];
//            if (model.dairymonthnum > 0) {
                self.allPhotoCountLabel.text = [NSString stringWithFormat:@"%ld张图片",model.dairymonthnum];
//                [self.allPhotoCountLabel setHidden:NO];
//            } else {
//                [self.allPhotoCountLabel setHidden:YES];
//            }
            
        } else if ([model.dairymonthfileJA[0] filetype] == 2) {
            //视频
            [self.allVideoImg sd_setImageWithURL:[NSURL URLWithString:[model.dairymonthfileJA[0] fileurlsmall]] placeholderImage:nil];
//            if (model.dairymonthnum > 0) {
                self.allVideoCountLabel.text = [NSString stringWithFormat:@"%ld个视频",model.dairymonthnum];
//                [self.allVideoCountLabel setHidden:NO];
//            } else {
//                [self.allVideoCountLabel setHidden:YES];
//            }
            
        } else {
            //收藏
            [self.collectImg sd_setImageWithURL:[NSURL URLWithString:[model.dairymonthfileJA[0] fileurlsmall]] placeholderImage:nil];
//            if (model.dairymonthnum > 0) {
                self.collectCountLabel.text = [NSString stringWithFormat:@"%ld次收藏",model.dairymonthnum];
//                [self.collectCountLabel setHidden:NO];
//            } else {
//                [self.collectCountLabel setHidden:YES];
//            }
        }
    }
}

- (IBAction)headTapAction:(UITapGestureRecognizer *)sender {
    
    if (sender.view.tag == 1) {
        //最近上传
    } else if (sender.view.tag == 2) {
        //图片
    } else if (sender.view.tag == 3) {
        //视频
    } else {
        //收藏
    }
    
    if (_CloudReHeadImgClickBlock) {
        _CloudReHeadImgClickBlock((int)sender.view.tag);
    }
}

- (IBAction)searchBarTapAction:(UITapGestureRecognizer *)sender {
    if (_CloudReSearchBarClickBlock) {
        _CloudReSearchBarClickBlock();
    }
}

- (IBAction)actionSearch:(id)sender {
    if (_clickBlock) {
        _clickBlock();
    }
}
@end

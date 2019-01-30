//
//  MineFindMainActionCell.m
//  TiHouse
//
//  Created by admin on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineFindMainActionCell.h"
#import "MineArticleViewController.h"
#import "MinePictureViewController.h"
#import "FSCustomButton.h"

@interface MineFindMainActionCell()
@property (nonatomic, strong) FSCustomButton *picBtn, *articleBtn;
@end

@implementation MineFindMainActionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineStyle = CellLineStyleFill;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self picBtn];
        [self articleBtn];
    }
    return self;
}

-(FSCustomButton *)picBtn {
    if (!_picBtn) {
        _picBtn = [[FSCustomButton alloc] init];
        _picBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _picBtn.buttonImagePosition = FSCustomButtonImagePositionTop;
        [_picBtn setTitle:@"图片 3" forState:UIControlStateNormal];
        [_picBtn setTitleColor:XWColorFromHex(0x999999) forState:UIControlStateNormal];
        _picBtn.backgroundColor = XWColorFromHex(0xFFFFFF);
        [_picBtn setImage:[UIImage imageNamed:@"mine_picture"] forState:UIControlStateNormal];
        _picBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _picBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        _picBtn.tag = _user.uid;
        [self.contentView addSubview:_picBtn];
        [_picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(30));
            make.width.equalTo(@kRKBWIDTH(150));
            make.height.equalTo(@kRKBHEIGHT(50));
            make.centerY.equalTo(self.contentView);
        }];
        [_picBtn addTarget:self action:@selector(goPic) forControlEvents:UIControlEventTouchUpInside];
    }
    return _picBtn;
}

-(FSCustomButton *)articleBtn {
    if (!_articleBtn) {
        _articleBtn = [[FSCustomButton alloc] init];
        _articleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _articleBtn.buttonImagePosition = FSCustomButtonImagePositionTop;
        [_articleBtn setTitle:@"文章 3" forState:UIControlStateNormal];
        [_articleBtn setTitleColor:XWColorFromHex(0x999999) forState:UIControlStateNormal];
        _articleBtn.backgroundColor = XWColorFromHex(0xFFFFFF);
        [_articleBtn setImage:[UIImage imageNamed:@"mine_article"] forState:UIControlStateNormal];
        _articleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _articleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        _articleBtn.tag = _user.uid;
        [self.contentView addSubview:_articleBtn];
        [_articleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-kRKBWIDTH(30));
            make.width.equalTo(@kRKBWIDTH(150));
            make.height.equalTo(@kRKBHEIGHT(50));
            make.centerY.equalTo(self.contentView);
        }];
        [_articleBtn addTarget:self action:@selector(goArticle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _articleBtn;
}

-(void)setUser:(User *)user {
    _user = user;
    [_picBtn setTitle:[NSString stringWithFormat:@"图片 %d", user.countassemarctype2] forState:UIControlStateNormal];
    [_articleBtn setTitle:[NSString stringWithFormat:@"文章 %d", user.countassemarctype1] forState:UIControlStateNormal];
}

-(void)goPic {
    
    MinePictureViewController *mpVC = [MinePictureViewController new];
    
    mpVC.uid = _user.uid;
    mpVC.u = _user;
    [self.findViewController.navigationController pushViewController:mpVC animated:YES];
}

-(void)goArticle {
    MineArticleViewController *maVC = [MineArticleViewController new];
    maVC.uid = _user.uid;
    maVC.u = _user;
    [self.findViewController.navigationController pushViewController:maVC animated:YES];

}

@end


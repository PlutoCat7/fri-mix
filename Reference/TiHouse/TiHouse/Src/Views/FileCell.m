//
//  HouseChangeImageCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FileCell.h"
#import "Folder.h"
@interface FileCell()<UITextFieldDelegate>

@property (nonatomic, retain) UIButton *deleteBtn;

@end

@implementation FileCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _eidt = NO;
        
        [self deleteBtn];
        [self imageV];
        [self title];
        [self.contentView bringSubviewToFront:_deleteBtn];

    }
    return self;
}

-(void)setEidt:(BOOL)eidt{
    
    _eidt = eidt;
    if (eidt) {
        _deleteBtn.hidden = NO;
        _title.userInteractionEnabled = YES;
        _title.backgroundColor = XWColorFromHex(0xebebeb);
        _title.textColor = XWColorFromHex(0xbfbfbf);
    }else{
        _deleteBtn.hidden = YES;
        _title.userInteractionEnabled = NO;
        _title.backgroundColor = [UIColor whiteColor];
        _title.textColor = [UIColor blackColor];
    }
    
}

-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.image = [UIImage imageNamed:@"file_icon_all"];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
        [self.contentView addSubview:_imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_deleteBtn).offset(11.5f);
            make.top.equalTo(_deleteBtn).offset(11.5f);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@(56));
        }];
    }
    return _imageV;
}

-(UITextField *)title{
    if (!_title) {
        _title = [[UITextField alloc]init];
        _title.backgroundColor = [UIColor whiteColor];
        _title.layer.cornerRadius = 6.f;
        _title.font = [UIFont systemFontOfSize:13];
        _title.userInteractionEnabled = NO;
        _title.delegate = self;
        _title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageV.mas_bottom).offset(6.0f);
            make.left.equalTo(_imageV);
            make.right.equalTo(_imageV);
            make.height.equalTo(@(22));
        }];
    }
    return _title;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.hidden = YES;
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(delegatefile) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(23, 23));
        }];
    }
    return _deleteBtn;
}

-(void)setFolder:(Folder *)folder{
    _folder = folder;
    _title.text = folder.foldername;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (_titleChange) {
        _titleChange(self);
    }
    return YES;
}

-(void)delegatefile{
    if (_deleFile) {
        _deleFile(self);
    }
}

@end

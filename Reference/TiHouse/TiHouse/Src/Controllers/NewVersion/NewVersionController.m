//
//  NewVersionController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "NewVersionController.h"
#import "Login.h"

#define UILABEL_LINE_SPACE 0

@interface NewVersionController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *meowImageView;
@property (nonatomic, strong) UILabel *newVersionLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation NewVersionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self setupSubViews];
//    [self getVersionInfo];
    [self reloadUI:_currentModel];
}

- (void)setupSubViews {
    [self meowImageView];
    [self newVersionLabel];
    [self versionLabel];
    [self line];
    [self tableView];
    [self updateButton];
    [self verticalLine];
    [self closeButton];
}


- (UIImageView *)meowImageView {
    if (!_meowImageView) {
        _meowImageView = [[UIImageView alloc] init];
        [self.view addSubview:_meowImageView];
        [_meowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@280);
            make.height.equalTo(@407);
            make.top.equalTo(@(kRKBHEIGHT(105.5)));
        }];
        _meowImageView.image = [UIImage imageNamed:@"meow"];
        _meowImageView.userInteractionEnabled = YES;
    }
    return _meowImageView;
}

- (UILabel *)newVersionLabel {
    if (!_newVersionLabel) {
        _newVersionLabel = [[UILabel alloc] init];
        [_meowImageView addSubview:_newVersionLabel];
        [_newVersionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_meowImageView);
            make.top.equalTo(@150);
            make.height.equalTo(@18);
        }];
        _newVersionLabel.text = @"发现新版本";
        _newVersionLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        _newVersionLabel.textColor = [UIColor colorWithHexString:@"0x2c2c2c"];
    }
    return _newVersionLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        [_meowImageView addSubview:_versionLabel];
        [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_meowImageView);
            make.top.equalTo(_newVersionLabel.mas_bottom).offset(4.5);
            make.height.equalTo(@22);
        }];
        _versionLabel.layer.cornerRadius = 10;
        _versionLabel.layer.masksToBounds = YES;
        _versionLabel.backgroundColor = kTiMainBgColor;
        _versionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        [_meowImageView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_meowImageView);
            make.height.equalTo(@1);
            make.left.equalTo(@22.5);
            make.top.equalTo(_versionLabel.mas_bottom).offset(8);
        }];
        _line.backgroundColor = [UIColor colorWithHexString:@"0xf0f1f2"];
    }
    return _line;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_meowImageView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_meowImageView);
            make.left.equalTo(@22.5);
            make.top.equalTo(_line.mas_bottom).offset(6.5);
            make.bottom.equalTo(self.updateButton.mas_top).offset(-6.5);
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)updateButton {
    if (!_updateButton) {
        _updateButton = [[UIButton alloc] init];
        [_meowImageView addSubview:_updateButton];
        [_updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_meowImageView);
            make.height.equalTo(@50);
            make.left.equalTo(@32.5);
            make.bottom.equalTo(@-21);
        }];
        _updateButton.layer.cornerRadius = 25;
        _updateButton.layer.masksToBounds = YES;
        _updateButton.backgroundColor = [UIColor colorWithHexString:@"fb8524"];
        [_updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
        _updateButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [_updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_updateButton addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateButton;
}

- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        [self.view addSubview:_verticalLine];
        [_verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@1);
            make.height.equalTo(@40);
            make.top.equalTo(_meowImageView.mas_bottom);
        }];
        _verticalLine.backgroundColor = [UIColor whiteColor];
    }
    return _verticalLine;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [self.view addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_verticalLine.mas_bottom);
            make.size.equalTo(@30);
        }];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"mine_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - target action
- (void)update {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%9C%89%E6%95%B0%E5%95%A6/id1358579360?l=en&mt=8"]];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentModel.versioncontentJA.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getSpaceLabelHeight:[NSString stringWithFormat:@"%ld、 %@",
                                      [_currentModel.versioncontentJA[indexPath.row] index],
                                      [_currentModel.versioncontentJA[indexPath.row] content]]
                            withFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]
                           withWidth:235] + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"0x2c2c2c"];
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLabelSpace:cell.textLabel
              withValue:[NSString stringWithFormat:@"%ld、 %@",
                                                  [_currentModel.versioncontentJA[indexPath.row] index],
                                                  [_currentModel.versioncontentJA[indexPath.row] content]]
               withFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    return cell;
}

//- (void)getVersionInfo {
//    NSDictionary *params = @{@"versionno": @0,
//                             @"uid": @([Login curLoginUserID])
//                             };
//    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/outer/version/getLatest" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
//        if ([data[@"is"] integerValue]) {
//            _currentModel = [NewVersionModel mj_objectWithKeyValues:data[@"data"]];
//            _currentModel.labelWidth = [_currentModel.versioncode getWidthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToSize:CGSizeMake(MAXFLOAT, 22)] + 20;
//
//            [self reloadUI:_currentModel];
//        } else {
//            [NSObject showHudTipStr:data[@"msg"]];
//        }
//    }];
//}

- (void)reloadUI:(NewVersionModel *)model {
    _versionLabel.text = model.versioncode;
    [_versionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(model.labelWidth));
    }];
    [_tableView reloadData];
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    
    label.attributedText = attributeStr;
    
}

-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height;
    
}
@end

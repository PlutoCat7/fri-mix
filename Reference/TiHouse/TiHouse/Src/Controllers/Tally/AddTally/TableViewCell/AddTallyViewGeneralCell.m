//
//  AaddTallyViewTextCell.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddTallyViewGeneralCell.h"


@interface AddTallyViewGeneralCell()
@property (weak, nonatomic) UILabel *titleLabel;


@end

@implementation AddTallyViewGeneralCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *iconImageView = [UIImageView new];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@15);
            make.leading.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(16.5);
        }];
        
        UIImageView *menu_arrow = [UIImageView new];
        [self.contentView addSubview:menu_arrow];
        menu_arrow.image = [UIImage imageNamed:@"Tally_add_icon_accessory"];
        self.menu_arrow = menu_arrow;
        [menu_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@9);
            make.height.equalTo(@14);
            make.trailing.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
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
        
        UIView *imgsContainer = [UIView new];
        [self.contentView addSubview:imgsContainer];
        self.imgsContainer = imgsContainer;
        [imgsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView.mas_trailing).offset(10);
            make.trailing.and.top.and.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setCellTextInfo:(NSString *)imageName title:(NSString *)text {
    self.titleLabel.hidden = NO;
    self.menu_arrow.hidden = NO;
    [self.imgsContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.iconImageView.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = text;
    
    // 默认文字则默认颜色
    self.titleLabel.textColor = XWColorFromHex(0xb3b3b3);
    
    if (self.indexPath.row == 5) {
        // 图片默认高度刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self refreshCellHeight:50];
        });
    }
    
}

- (void)setActivate:(BOOL)activate {
    self.titleLabel.textColor = activate?XWColorFromHex(0x656565) : XWColorFromHex(0xb3b3b3);
}

- (void)setCellImagesInfo:(NSArray *)imgs showAdd:(BOOL)show {
    self.titleLabel.hidden = YES;
    self.menu_arrow.hidden = YES;
    [self.imgsContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat x = 0, y = 15, w = 70, space = 10;
    NSInteger index = 0;
    UIImageView *last = nil;
    
    for (id img in imgs) {
        UIImageView *imgView = [UIImageView new];
        [imgView setTag:56];
        [imgView setUserInteractionEnabled:YES];
        if ([img isKindOfClass:[UIImage class]]) {
            imgView.image = img;
        } else if ([img isKindOfClass:[NSString class]]) {
            if (((NSString *)img).length == 0) {
                continue;
            }
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"user_icon"]];
        }
        
        imgView.clipsToBounds = YES;
        imgView.layer.cornerRadius = 3;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clickBtn setTitle:@"" forState:UIControlStateNormal];
        [clickBtn setBackgroundColor:[UIColor clearColor]];
        [clickBtn addTarget:self action:@selector(clickImg) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:clickBtn];
        
        [self.imgsContainer addSubview:imgView];
        
        imgView.frame = CGRectMake(x, y, w, w);
        [clickBtn setFrame:imgView.bounds];
        index++;
        x += w+space;
        
        // 换行
        if (index % 4 == 0) {
//            y += w+space;
//            x = 0;
            break;
        }
        
        last = imgView;
    }
    
    if ((index < 4) && show) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"" forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"account_addphoto"] forState:UIControlStateNormal];
        [addBtn setBackgroundColor:XWColorFromRGB(245, 245, 245)];
        [addBtn addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];
        addBtn.frame = CGRectMake(x, y, w, w);
        addBtn.layer.cornerRadius = 3;
        [self.imgsContainer addSubview:addBtn];
    }
    
    
    // 下方间隔15
    CGFloat height = CGRectGetMaxY(last.frame)+15;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshCellHeight:height];
    });
}

-(void)setDisabled:(BOOL)disabled {
    [self.menu_arrow setHidden:disabled];
}

- (void)refreshCellHeight:(CGFloat)height {
    _cellHeight = height;
    
    id<AddTallyViewGeneralCellDelegate> delegate = (id<AddTallyViewGeneralCellDelegate>)self.tableView.delegate;
    
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

- (void)clickImg{
    
    if (_delegate) {
        [_delegate showImagesBrower];
    }
}

- (void)clickAdd{
    
    if (_delegate) {
        [_delegate addImage];
    }
}


@end

@implementation UITableView (AddTallyViewGeneralCell)

- (AddTallyViewGeneralCell *)addTallyViewGeneralCellWithId:(NSString *)cellId {
    AddTallyViewGeneralCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[AddTallyViewGeneralCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tableView = self;
    return cell;
}

@end

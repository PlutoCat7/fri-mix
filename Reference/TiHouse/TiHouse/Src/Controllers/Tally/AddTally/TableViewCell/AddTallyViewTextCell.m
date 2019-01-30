//
//  AddTallyViewTextCell.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddTallyViewTextCell.h"
#import "MyTextView.h"

#define kPadding 5

@interface AddTallyViewTextCell()<UITextViewDelegate>
@property (strong, nonatomic) MyTextView *textView;
@property (strong, nonatomic) UIButton *soundBtn;
@end

@implementation AddTallyViewTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *iconImageView = [UIImageView new];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@15);
            make.leading.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(15);
        }];
        
        [self.contentView addSubview:self.textView];
    }
    return self;
}


- (UIButton *)soundBtn {
    if (_soundBtn == nil) {
        _soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_soundBtn setImage:[UIImage imageNamed:@"Tally_add_sound_play"] forState:UIControlStateNormal];
        CGRect cellFrame = self.contentView.bounds;
        _soundBtn.frame = CGRectMake(cellFrame.size.width - 37, 13, 22, 22);
        [_soundBtn addTarget:self action:@selector(soundBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _soundBtn;
}

- (MyTextView *)textView {
    if (_textView == nil) {
        CGRect cellFrame = self.contentView.bounds;
        cellFrame.origin.y += kPadding;
        cellFrame.size.height -= kPadding;
        cellFrame.origin.x = 30 + kPadding;
        cellFrame.size.width -= (30 + kPadding + 15);
        
        _textView = [[MyTextView alloc] initWithFrame:cellFrame];
        _textView.delegate = self;
        
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:14.0f];
        _textView.textColor = XWColorFromHex(0x656565);
        _textView.placeholder = @"添加备注";
        _textView.placeholderTextColor = XWColorFromHex(0xb3b3b3);
        
        _textView.scrollEnabled = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}

- (void)setText:(NSString *)text {
    _text = text;
    // update the UI
    self.textView.text = text;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self textViewDidChange:self.textView];
    });
    
}

// 检测是否包含日期
- (void)checkContentContainDate {
    // 判断是否包含月日期
    [[TiHouse_NetAPIManager sharedManager] request_RecognSynchronWidthParams:@{@"text":self.textView.text} BlocRk:^(id data, NSError *error) {
        
        BOOL isContainDate = [data[@"identifyresult"] integerValue] > 0;

        // 通知其相关cell
        NSNotification *notification = [NSNotification notificationWithName:@"ContainDeteStrNotification" object:nil userInfo:@{@"containDeteStr":@(isContainDate)}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }];
   
}

- (CGFloat)cellHeight {
    return [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)].height + kPadding * 2;
}

- (void)soundBtnAction:(UIButton *)sender {
    NSLog(@"播放音频");
}

- (void)setIsFromVoice:(BOOL)isFromVoice {
    _isFromVoice = isFromVoice;
    if (isFromVoice) {
        [self.contentView addSubview:self.soundBtn];
        
        // 调整输入框
        CGRect textViewFrame = self.textView.frame;
        textViewFrame.size.width -= (CGRectGetMaxX(self.iconImageView.frame) + kPadding + 35);
        self.textView.frame = textViewFrame;
    }
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (self.textView.text.length > 60){
        _text = [self.textView.text substringWithRange:NSMakeRange(0, 60)];
        self.textView.text = _text;
    } else {
        _text = self.textView.text;
    }
    
    if ([_delegate respondsToSelector:@selector(addTallyViewTextCell:textViewDidChange:)]) {
        [_delegate addTallyViewTextCell:self textViewDidChange:self.textView.text];
    }

    id<AddTallyViewTextCellDelegate> delegate = (id<AddTallyViewTextCellDelegate>)self.tableView.delegate;
    
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"test");
    
    // 检测是否包含日期
    [self checkContentContainDate];
}

-(void)setDisabled:(BOOL)disabled {
    self.userInteractionEnabled = !disabled;
}

@end

@implementation UITableView (AddTallyViewTextCell)

- (AddTallyViewTextCell *)addTallyViewTextCellWithId:(NSString *)cellId {
    AddTallyViewTextCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[AddTallyViewTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tableView = self;
    return cell;
}

@end

//
//  UIComboBox.m
//  UIComboBox
//
//  Created by abc123 on 14-12-24.
//  Copyright (c) 2014 Ralph Shane. All rights reserved.
//

#import "UIComboBox.h"

#define __USING_ANIMATE__ 0

#define kComboBoxHeight 160.0

//========================== PassthroughView =============================================

@interface PassthroughView : UIView
@property (nonatomic, copy) NSArray *passViews;
@property(nonatomic, strong) void(^doPassthrough)(BOOL isPass);
@end

@implementation PassthroughView {
    BOOL _testHits;
}

- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (_testHits) {
        return nil;
    }
    if (!self.passViews || (self.passViews && self.passViews.count==0)) {
        return nil;
    }
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        _testHits = YES;
        CGPoint superPoint = [self.superview convertPoint:point fromView:self];
        UIView *superHitView = [self.superview hitTest:superPoint withEvent:event];
        _testHits = NO;
        BOOL pass = [self isPassthroughView:superHitView];
        if (pass) {
            hitView = superHitView;
        }
        if (_doPassthrough) {
            _doPassthrough(pass);
        }
    }
    return hitView;
}

- (BOOL) isPassthroughView:(UIView *)view {
    if (view == nil) {
        return NO;
    }
    if ([self.passViews containsObject:view]) {
        return YES;
    }
    return [self isPassthroughView:view.superview];
}

@end


//========================== UIComboBox =============================================


@interface UIComboBox () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation UIComboBox {
    UITableViewCell *_textLabel;
    UIImageView *_rightView;
    UITableView *_tableView;
    CGRect _cachedTableViewFrame;
    PassthroughView *_passthroughView;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"UIComboBox instance %0xd", (int)self];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype) init {
    if (self = [super initWithFrame:CGRectMake(58, 102, 165, 37)]) {
        [self initSubviews];
    }
    return self;
}

- (void) setSelectedItem:(NSUInteger)selectedItem {
    _selectedItem = selectedItem;
    if (_entries.count == 0) {
        return;
    }
    id obj = _entries[_selectedItem];
    
    if ([obj respondsToSelector:@selector(description)]) {
        _textLabel.textLabel.text = [obj performSelector:@selector(description)];
    }
    if ([obj respondsToSelector:@selector(image)]) {
        _textLabel.imageView.image = [obj performSelector:@selector(image)];
    }
    
    if (_tableView) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedItem inSection:0];
        [_tableView selectRowAtIndexPath:path
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void) setEnabled:(BOOL)enabled {
    //_textLabel.textLabel.enabled = enabled;
    _textLabel.textLabel.textColor = enabled?[UIColor blackColor]:[UIColor grayColor];
    _rightView.highlighted = !enabled;
    [super setEnabled:enabled];
}

- (UIFont *) font {
    return _textLabel.textLabel.font;
}

- (void) setFont:(UIFont *)font {
    _textLabel.textLabel.font = font;
    if (_tableView) {
        [_tableView reloadData];
    }
}

- (void) initSubviews {

    _textLabel = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _textLabel.textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_textLabel];
    
    _rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"combobox_down"]];
    _rightView.highlightedImage = [UIImage imageNamed:@"combobox_down_highlighed"];
    [self addSubview:_rightView];
    
    [self addTarget:self action:@selector(tapHandle) forControlEvents:UIControlEventTouchUpInside];
    self.userInteractionEnabled = YES;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect rc = CGRectZero; rc.size = self.frame.size;
    
    CGRect rcRight = rc;
    rcRight.size.width = rc.size.height;
    rcRight.origin.x = rc.origin.x + rc.size.width -rcRight.size.width;
    
    CGRect rcLabel = rc;
    rcLabel.size.width = rc.size.width - rcRight.size.width;
    
    rcLabel = CGRectInset(rcLabel, 3, 3);
    rcRight = CGRectInset(rcRight, 3, 3);
    
    _textLabel.frame = rcLabel;
    _rightView.frame = rcRight;
}

- (void) adjustPopupViewFrame {
    CGRect frame = self.frame;
    frame.origin.y += self.frame.size.height + 2.0;
    frame.size.height = 0.0;

    if (self.tableViewOnTop) {
        frame.origin.y = self.frame.origin.y - 2.0 - kComboBoxHeight;
    }

    _tableView.frame = frame;
    _cachedTableViewFrame = frame;
}

- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.enabled) {
        if (CGRectContainsPoint(_textLabel.frame, point)) {
            if (_tableView.superview == nil) {
                [self tapHandle];
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - firstResponder
- (void) tapHandle {
    UIView *topView = [UIComboBox topMostView:self];
    NSAssert(topView, @"Can not obtain the most-top leave view.");
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    
    [self adjustPopupViewFrame];
    
    if (_tableView.superview == nil) {
        _rightView.image = [UIImage imageNamed:@"combobox_up"];
        _rightView.highlightedImage = [UIImage imageNamed:@"combobox_up_highlighed"];
        
        CGRect frame = [self.superview convertRect:_cachedTableViewFrame toView:topView];
        _rightView.frame = frame;
        frame.size.height = kComboBoxHeight;
        [topView addSubview:_tableView];
        _tableView.frame = frame;
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedItem inSection:0];
        if (_entries.count) {
            [_tableView selectRowAtIndexPath:path
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionMiddle];
        }
        
        if (_passthroughView == nil) {
            CGRect rc = [[UIApplication sharedApplication] keyWindow].frame;
            
            _passthroughView = [[PassthroughView alloc] initWithFrame:rc];
            _passthroughView.passViews = [NSArray arrayWithObjects:self, _tableView, nil];
            
            __weak typeof(self) weakSelf = self;
            [_passthroughView setDoPassthrough:^(BOOL isPass) {
                __strong typeof(self) strongSelf = weakSelf;
                if (!isPass) {
                    [strongSelf doClearup];
                }
            }];
        }
        [topView addSubview:_passthroughView];
    } else {
        [self doClearup];
    }
}

#pragma mark - change state when highlighed

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    _rightView.highlighted = highlighted; // change button to highlighed state
    _textLabel.highlighted = highlighted; // change label to highlighed state
    UIColor *shadowColor = highlighted ? [UIColor lightGrayColor] : nil;
    _textLabel.textLabel.shadowColor = shadowColor;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_entries count];
}


#define kTableViewCellHeight 32.0f

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"UIComboBoxCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.font = _textLabel.textLabel.font;
    
    id obj = [_entries objectAtIndex:[indexPath row] ];
    
    if ([obj respondsToSelector:@selector(description)]) {
        cell.textLabel.text = [obj performSelector:@selector(description)];
    }
    if ([obj respondsToSelector:@selector(image)]) {
        cell.imageView.image = [obj performSelector:@selector(image)];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int selectedItem = (int) indexPath.row;
    self.selectedItem = selectedItem;
    [self doClearup];
    
    if (_onItemSelected) {
        _onItemSelected(selectedItem);
    }
}

- (void) doClearup {
#if __USING_ANIMATE__
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = _tableView.frame;
        frame.size.height = 0.0;
        _tableView.frame = frame;
    } completion:^(BOOL finished) {
        [_tableView removeFromSuperview];
        [_passthroughView removeFromSuperview];
    }];
#else
    [_tableView removeFromSuperview];
    [_passthroughView removeFromSuperview];
#endif
    _rightView.image = [UIImage imageNamed:@"combobox_down"];
    _rightView.highlightedImage = [UIImage imageNamed:@"combobox_down_highlighed"];
}

#pragma mark -

+ (UIView *) topMostView:(UIView *)view {
    UIView *superView = view.superview;
    if (superView) {
        return [self topMostView:superView];
    } else {
        return view;
    }
}


@end

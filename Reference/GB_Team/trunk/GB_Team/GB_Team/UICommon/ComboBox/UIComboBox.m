//
//  UIComboBox.m
//  UIComboBox
//
//  Created by abc123 on 14-12-24.
//  Copyright (c) 2014 Ralph Shane. All rights reserved.
//

#import "UIComboBox.h"
#import "UIComboBoxCell.h"

#define __USING_ANIMATE__ 0

#define kComboBoxHeight 160.0
#define kTableViewCellHeight 48.0f

//========================== PassthroughView =============================================

@protocol PassthroughViewDelegate <NSObject>
-(void)doPassthrough:(BOOL)isPass;
@end


@interface PassthroughView : UIView
@property (nonatomic, copy) NSArray *passViews;
@property(nonatomic, assign) id<PassthroughViewDelegate> delegate;
@end


@implementation PassthroughView {
    BOOL _testHits;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
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
        [self.delegate doPassthrough:pass];
    }
    return hitView;
}

-(BOOL)isPassthroughView:(UIView *)view {
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


@interface UIComboBox () <UITableViewDelegate, UITableViewDataSource, PassthroughViewDelegate>
@end

@implementation UIComboBox {
    UITextField *_textLabel;
    UIImageView *_rightView;
    CGRect _cachedTableViewFrame;
    PassthroughView *_passthroughView;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"UIComboBox instance %0xd", (int)self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(58, 102, 165, 37)];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)setSelectedItem:(NSUInteger)selectedItem {
    _selectedItem = selectedItem;
    if (_entries.count == 0 || _selectedItem == -1) {
        return;
    }
    id obj = _entries[_selectedItem];

    if ([obj respondsToSelector:@selector(description)]) {
        _textLabel.text = [obj performSelector:@selector(description)];
    }
    
    if (_tableView) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedItem inSection:0];
        [_tableView selectRowAtIndexPath:path
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)setEntries:(NSArray *)entries {
    _entries = entries;
    if (_tableView) {
        [_tableView reloadData];
    }
}

-(void)setEnabled:(BOOL)enabled {
    //_textLabel.textLabel.enabled = enabled;
    _textLabel.textColor = enabled?[UIColor blackColor]:[UIColor grayColor];
    _rightView.highlighted = !enabled;
    [super setEnabled:enabled];
}

- (void) setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (UIFont *) font {
    return _textLabel.font;
}

- (void) setFont:(UIFont *)font {
    _textLabel.font = font;
    if (_tableView) {
        [_tableView reloadData];
    }
}

-(void)initSubviews {
    _borderColor = [UIColor colorWithCGColor:self.layer.borderColor];
    
    _textLabel = [[UITextField alloc] init];
    [_textLabel setTextColor:[UIColor whiteColor]];
    [_textLabel setBackgroundColor:[UIColor clearColor]];
    [_textLabel setTextAlignment:NSTextAlignmentLeft];
    [_textLabel setFont:[UIFont systemFontOfSize:20.f]];
    [_textLabel setPlaceholder:LS(@"选择球队")];
    [_textLabel setUserInteractionEnabled:NO];
    
     UIColor *color = [UIColor colorWithHex:0x585858];
    _textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LS(@"球队选择") attributes:@{NSForegroundColorAttributeName: color}];
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _textLabel.borderStyle=UITextBorderStyleNone;

    [self addSubview:_textLabel];
    
    _rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"combobox_down"]];
    [self addSubview:_rightView];
    
    [self addTarget:self action:@selector(tapHandle) forControlEvents:UIControlEventTouchUpInside];
    self.userInteractionEnabled = YES;
    
    _selectedItem = 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rc = CGRectZero; rc.size = self.frame.size;
    
    CGRect rcRight = rc;
    rcRight.size.width = rc.size.height;
    rcRight.origin.x = rc.origin.x + rc.size.width -rcRight.size.width;
    
    CGRect rcLabel = rc;
    rcLabel.size.width = rc.size.width - rcRight.size.width;
    
    rcLabel = CGRectInset(rcLabel, 20, 10);
    rcRight = CGRectInset(rcRight, 3, 3);
    
    _textLabel.frame = rcLabel;
    _rightView.frame = CGRectInset(rcRight, (rcRight.size.width-18)/2, (rcRight.size.height-9)/2);
}

- (void) adjustPopupViewFrame {
    CGRect frame = self.frame;
    frame.origin.y += (_topShow ? -2.0 : (self.frame.size.height + 2.0));
    frame.size.height = 0.0;

    _tableView.frame = frame;
    _cachedTableViewFrame = frame;
}

#pragma mark - firstResponder
- (void)tapHandle {
    UIView *topView = [UIComboBox topMostView:self];
    NSAssert(topView, @"Can not obtain the most-top leave view.");
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.layer.borderColor = self.borderColor.CGColor;
        _tableView.backgroundColor=[UIColor colorWithHex:0x171717];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"UIComboBoxCell" bundle:nil] forCellReuseIdentifier:@"UIComboBoxCell"];
    }

    [self adjustPopupViewFrame];

    if (_tableView.superview == nil) {
        
        CGRect frame = [self.superview convertRect:_cachedTableViewFrame toView:topView];
        _rightView.frame = frame;
        
        CGFloat boxHeight = 0.f;
        if (_entries.count == 0) {
            boxHeight = kTableViewCellHeight;
        } else if (_entries.count >= 4) {
            boxHeight = kTableViewCellHeight * 4;
        } else {
            boxHeight = kTableViewCellHeight * _entries.count;
        }
        
        frame.size.height = boxHeight;
        if (_topShow) {
            frame.origin.y -= boxHeight;
        }
        [topView addSubview:_tableView];
        
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _rightView.layer.transform = CATransform3DMakeRotation((_topShow ? 0 : M_PI), 0, 0, 1);
        } completion:NULL];
        
#if __USING_ANIMATE__
        [UIView animateWithDuration:0.5 animations:^{
            _tableView.frame = frame;
        } completion:^(BOOL finished) {
            //
        }];
#else
        _tableView.frame = frame;
#endif
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedItem inSection:0];
        if (_entries.count && path) {
            [_tableView selectRowAtIndexPath:path
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionMiddle];
        }

        if (_passthroughView == nil) {
            CGRect rc = [[UIApplication sharedApplication] keyWindow].frame;
            
            _passthroughView = [[PassthroughView alloc] initWithFrame:rc];
            _passthroughView.passViews = [NSArray arrayWithObjects:self, _tableView, nil];
            _passthroughView.delegate = self;
        }
        [topView addSubview:_passthroughView];
    } else {
        [self doClearup];
    }
}

#pragma mark - change state when highlighed

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    _rightView.highlighted = highlighted; // change button to highlighed state
    _textLabel.highlighted = highlighted; // change label to highlighed state
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_entries count];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIComboBoxCell* cell = (UIComboBoxCell *)[tableView dequeueReusableCellWithIdentifier:@"UIComboBoxCell"];


    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:1];
    
    cell.teamName.font = _textLabel.font;

    id obj = [_entries objectAtIndex:[indexPath row] ];
    if ([obj respondsToSelector:@selector(description)]) {
        cell.teamName.text = [obj performSelector:@selector(description)];
    }
    if ([obj respondsToSelector:@selector(image)]) {
        cell.imageView.image = [obj performSelector:@selector(image)];
    }

    return cell;
}

- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int selectedItem = (int) indexPath.row;
    self.selectedItem = selectedItem;
    [self doClearup];
    if ([_delegate respondsToSelector:@selector(comboBox:selected:)]) {
        [_delegate comboBox:self selected:selectedItem];
    }
}

-(void) doClearup {
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
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _rightView.layer.transform = CATransform3DMakeRotation((_topShow ? M_PI : 0), 0, 0, 1);
    } completion:NULL];
    
}

- (void)resetComboBoxSelect {
    self.selectedItem = 0;
    [self doClearup];
    
    if (_textLabel) {
        _textLabel.text = @"";
    }
}

- (void)setComboBoxPlaceholder:(NSString *)placeholder color:(UIColor *)color {
    if (_textLabel) {
        if (color == nil) {
            color = [UIColor colorWithHex:0x585858];
        }
        _textLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _textLabel.borderStyle=UITextBorderStyleNone;
    }
}

- (void)setTopShow:(BOOL)topShow {
    _topShow = topShow;
    if (topShow) {
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _rightView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } completion:NULL];
    }
}


#pragma mark - PassthroughViewDelegate

-(void)doPassthrough:(BOOL)isPass {
    if (!isPass) {
        [self doClearup];
    }
}


#pragma mark -

+(UIView *) topMostView:(UIView *)view {
    UIView *superView = view.superview;
    if (superView) {
        return [self topMostView:superView];
    } else {
        return view;
    }
}


@end

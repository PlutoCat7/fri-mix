//
//  ICGVideoTrimmerView.m
//  ICGVideoTrimmer
//
//  Created by Huong Do on 1/18/15.
//  Copyright (c) 2015 ichigo. All rights reserved.
//

#import "ICGVideoTrimmerView.h"
#import "ICGThumbView.h"
#import "ICGRulerView.h"



@interface HitTestView : UIView
@property (assign, nonatomic) UIEdgeInsets hitTestEdgeInsets;
- (BOOL)pointInside:(CGPoint)point;

@end

@implementation HitTestView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self pointInside:point];
}

- (BOOL)pointInside:(CGPoint)point
{
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, _hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

@end


@interface ICGVideoTrimmerView() <UIScrollViewDelegate>

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *frameView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) AVAssetImageGenerator *imageGenerator;


@property (nonatomic ,retain) UILabel *promptView;
@property (nonatomic ,retain) UILabel *timeView;


@property (strong, nonatomic) HitTestView *leftOverlayView;
@property (strong, nonatomic) HitTestView *rightOverlayView;
@property (strong, nonatomic) ICGThumbView *leftThumbView;
@property (strong, nonatomic) ICGThumbView *rightThumbView;
@property (strong, nonatomic) UIImageView *leftMoveView;
@property (strong, nonatomic) UIImageView *rightMoveView;

@property (assign, nonatomic) BOOL isDraggingRightOverlayView;
@property (assign, nonatomic) BOOL isDraggingLeftOverlayView;


@property (strong, nonatomic) UIView *trackerView;
@property (strong, nonatomic) UIView *topBorder;
@property (strong, nonatomic) UIView *bottomBorder;

@property (nonatomic) CGFloat startTime;
@property (nonatomic) CGFloat endTime;

@property (nonatomic) CGFloat widthPerSecond;

@property (nonatomic) CGPoint leftStartPoint;
@property (nonatomic) CGPoint rightStartPoint;
@property (nonatomic) CGFloat overlayWidth;

@property (nonatomic) CGFloat prevTrackerTime;
@property (nonatomic) CGFloat offWidth;


@end

@implementation ICGVideoTrimmerView

#pragma mark - Initiation

- (instancetype)initWithFrame:(CGRect)frame
{
    NSAssert(NO, nil);
    @throw nil;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    _themeColor = [UIColor lightGrayColor];
    return [super initWithCoder:aDecoder];
}

- (instancetype)initWithAsset:(AVAsset *)asset
{
    return [self initWithFrame:CGRectZero asset:asset];
}

- (instancetype)initWithFrame:(CGRect)frame asset:(AVAsset *)asset
{
    self = [super initWithFrame:frame];
    if (self) {
        _asset = asset;
        [self resetSubviews];
    }
    return self;
}

- (void)setThemeColor:(UIColor *)themeColor {
    _themeColor = themeColor;
    
    [self.bottomBorder setBackgroundColor:_themeColor];
    [self.topBorder setBackgroundColor:_themeColor];
    self.leftThumbView.color = _themeColor;
    self.rightThumbView.color = _themeColor;
}


#pragma mark - Private methods

//- (UIColor *)themeColor
//{
//    return _themeColor ?: [UIColor lightGrayColor];
//}

- (CGFloat)maxLength
{
    return _maxLength ?: 130;
}

- (CGFloat)minLength
{
    return _minLength ?: 3;
}

- (UIColor *)trackerColor
{
    return _trackerColor ?: [UIColor whiteColor];
}

- (CGFloat)borderWidth
{
    return _borderWidth ?: 1;
}

- (CGFloat)thumbWidth
{
    return _thumbWidth ?: 7;
}

- (NSInteger) rulerLabelInterval
{
    return _rulerLabelInterval ?: 5;
}

#define EDGE_EXTENSION_FOR_THUMB 30
- (void)resetSubviews
{
    CALayer *sideMaskingLayer = [CALayer new];
    sideMaskingLayer.backgroundColor = [UIColor orangeColor].CGColor;
    sideMaskingLayer.frame = CGRectMake(0, -10, self.frame.size.width, self.frame.size.height + 20);
    self.layer.mask = sideMaskingLayer;
    
    [self setBackgroundColor:XWColorFromHexAlpha(0x44444b, 0.9)];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 40, CGRectGetWidth(self.frame)-30, 50)];
    [self addSubview:self.scrollView];
    [self.scrollView setDelegate:self];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
    [self.scrollView setContentSize:self.contentView.frame.size];
    [self.scrollView addSubview:self.contentView];
    
    //    CGFloat ratio = self.showsRulerView ? 0.7 : 1.0;
    self.frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
    [self.frameView.layer setMasksToBounds:YES];
    [self.contentView addSubview:self.frameView];
    
    [self addFrames];
    
    if (self.showsRulerView) {
        CGRect rulerFrame = CGRectMake(0, CGRectGetHeight(self.contentView.frame)*0.7, CGRectGetWidth(self.contentView.frame)+self.thumbWidth, CGRectGetHeight(self.contentView.frame)*0.3);
        ICGRulerView *rulerView = [[ICGRulerView alloc] initWithFrame:rulerFrame widthPerSecond:self.widthPerSecond themeColor:self.themeColor labelInterval:self.rulerLabelInterval];
        [self.contentView addSubview:rulerView];
    }
    
    // add borders
    self.topBorder = [[UIView alloc] init];
    [self.topBorder setBackgroundColor:self.themeColor];
    [self addSubview:self.topBorder];
    
    self.bottomBorder = [[UIView alloc] init];
    [self.bottomBorder setBackgroundColor:self.themeColor];
    [self addSubview:self.bottomBorder];
    
    // width for left and right overlay views
    self.overlayWidth =  self.thumbWidth/2;
    
    // add left overlay view
    self.leftOverlayView = [[HitTestView alloc] initWithFrame:CGRectMake(_scrollView.x, _scrollView.y, self.overlayWidth, CGRectGetHeight(self.frameView.frame))];
    //    self.leftOverlayView.hitTestEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(EDGE_EXTENSION_FOR_THUMB));
    CGRect leftThumbFrame = CGRectMake(-self.thumbWidth/2, 0, self.thumbWidth, CGRectGetHeight(self.frameView.frame));
    if (self.leftThumbImage) {
        self.leftThumbView = [[ICGThumbView alloc] initWithFrame:leftThumbFrame thumbImage:self.leftThumbImage];
    } else {
        self.leftThumbView = [[ICGThumbView alloc] initWithFrame:leftThumbFrame color:self.themeColor right:NO];
    }
    
    //    self.trackerView = [[UIView alloc] initWithFrame:CGRectMake(self.thumbWidth, -5, 3, CGRectGetHeight(self.frameView.frame) + 10)];
    //    self.trackerView.backgroundColor = self.trackerColor;
    //    self.trackerView.layer.masksToBounds = true;
    //    self.trackerView.layer.cornerRadius = 0;
    //    [self addSubview:self.trackerView];
    
    [self.leftThumbView.layer setMasksToBounds:YES];
    [self.leftOverlayView addSubview:self.leftThumbView];
    //    [self.leftOverlayView setUserInteractionEnabled:YES];
    [self.leftOverlayView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [self addSubview:self.leftOverlayView];
    
    // add right overlay view
    CGFloat rightViewFrameX = CGRectGetMaxX(_scrollView.frame) - self.thumbWidth/2;
    self.rightOverlayView = [[HitTestView alloc] initWithFrame:CGRectMake(rightViewFrameX, _scrollView.y, self.overlayWidth, CGRectGetHeight(self.frameView.frame))];
    //    self.rightOverlayView.hitTestEdgeInsets = UIEdgeInsetsMake(0, -(EDGE_EXTENSION_FOR_THUMB), 0, 0);
    
    if (self.rightThumbImage) {
        self.rightThumbView = [[ICGThumbView alloc] initWithFrame:CGRectMake(0, 0, self.thumbWidth, CGRectGetHeight(self.frameView.frame)) thumbImage:self.rightThumbImage];
    } else {
        self.rightThumbView = [[ICGThumbView alloc] initWithFrame:CGRectMake(0, 0, self.thumbWidth, CGRectGetHeight(self.frameView.frame)) color:self.themeColor right:YES];
    }
    [self.rightThumbView.layer setMasksToBounds:YES];
    [self.rightOverlayView addSubview:self.rightThumbView];
    //    [self.rightOverlayView setUserInteractionEnabled:YES];
    [self.rightOverlayView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5 ]];
    [self addSubview:self.rightOverlayView];
    
    self.leftMoveView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vdio_move_icon"]];
    self.leftMoveView.frame = CGRectMake(_scrollView.x-11, CGRectGetMaxY(_scrollView.frame), 22, 35);
    self.leftMoveView.userInteractionEnabled = YES;
    [self addSubview:self.leftMoveView];
    
    self.rightMoveView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vdio_move_icon"]];
    self.rightMoveView.frame = CGRectMake(CGRectGetMaxX(_scrollView.frame)-11, CGRectGetMaxY(_scrollView.frame), 22, 35);
    self.rightMoveView.userInteractionEnabled = YES;
    [self addSubview:self.rightMoveView];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveOverlayView:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    self.promptView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
    self.promptView.text = @"滑动选择您要剪切的片段";
    self.promptView.textColor = [UIColor whiteColor];
    self.promptView.font = [UIFont systemFontOfSize:14];
    self.promptView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.promptView];
    
    self.timeView = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftMoveView.frame)+50, _leftMoveView.y, 100, 35)];
    self.timeView.text = [NSString stringWithFormat:@"%.1f秒",self.maxLength];
    self.timeView.textColor = [UIColor whiteColor];
    self.timeView.font = [UIFont systemFontOfSize:16];
    self.timeView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeView];
    self.offWidth = _rightMoveView.x - _leftMoveView.x;
    [self updateBorderFrames];
    [self notifyDelegateOfDidChange];
}

- (void)updateBorderFrames
{
    _leftOverlayView.width = _leftMoveView.center.x -_scrollView.x + self.thumbWidth/2;
    _leftThumbView.right = _leftOverlayView.width;
    _timeView.centerX = _leftMoveView.centerX + ((_rightMoveView.x - _leftMoveView.x) / 2);
    CGFloat duration = CMTimeGetSeconds([self.asset duration]);
    _timeView.text = [NSString stringWithFormat:@"%.0f秒",round(((_rightMoveView.x - _leftMoveView.x) / self.offWidth * duration))];
    _rightOverlayView.x = _rightMoveView.center.x - self.thumbWidth/2;
    _rightOverlayView.width = CGRectGetMaxX(_scrollView.frame) - _rightMoveView.center.x + self.thumbWidth/2;
    CGFloat height = self.borderWidth;
    [self.topBorder setFrame:CGRectMake(CGRectGetMaxX(_leftOverlayView.frame), _scrollView.y, _rightOverlayView.x -CGRectGetMaxX(_leftOverlayView.frame), height)];
    [self.bottomBorder setFrame:CGRectMake(CGRectGetMaxX(_leftOverlayView.frame), CGRectGetMaxY(_scrollView.frame)-height, _rightOverlayView.x -CGRectGetMaxX(_leftOverlayView.frame), height)];
}


- (void)moveOverlayView:(UIPanGestureRecognizer *)gesture
{
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            BOOL isRight =  CGRectContainsPoint(UIEdgeInsetsInsetRect(_rightMoveView.bounds, UIEdgeInsetsMake(0, -30, 0, -30)), [gesture locationInView:_rightMoveView]);
            BOOL isLeft  =  CGRectContainsPoint(UIEdgeInsetsInsetRect(_leftMoveView.bounds, UIEdgeInsetsMake(0, -30, 0, -30)), [gesture locationInView:_leftMoveView]);
            
            _isDraggingRightOverlayView = NO;
            _isDraggingLeftOverlayView = NO;
            if (isRight){
                self.rightStartPoint = [gesture locationInView:self];
                _isDraggingRightOverlayView = YES;
                _isDraggingLeftOverlayView = NO;
            }
            else if (isLeft){
                self.leftStartPoint = [gesture locationInView:self];
                _isDraggingRightOverlayView = NO;
                _isDraggingLeftOverlayView = YES;
                
            }
            
        }    break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:self];
            //------------------------------------------------------------------------------------------------------------
            // Right
            if (_isDraggingRightOverlayView){
                
                CGFloat deltaX = point.x - self.rightStartPoint.x;
                
                CGPoint center = self.rightMoveView.center;
                center.x += deltaX;
                CGFloat newRightViewMidX = center.x;
                CGFloat minX = _leftMoveView.center.x + self.minLength * self.widthPerSecond;
                CGFloat maxX = CGRectGetMaxX(_scrollView.frame);
                if (newRightViewMidX < minX) {
                    newRightViewMidX = minX;
                } else if (newRightViewMidX > maxX) {
                    newRightViewMidX = maxX;
                }
                
                self.rightMoveView.center = CGPointMake(newRightViewMidX, self.rightMoveView.center.y);
                self.rightStartPoint = point;
            }
            else if (_isDraggingLeftOverlayView){
                
                //------------------------------------------------------------------------------------------------------------
                // Left
                CGFloat deltaX = point.x - self.leftStartPoint.x;
                
                CGPoint center = self.leftMoveView.center;
                center.x += deltaX;
                CGFloat newLeftViewMidX = center.x;
                //                CGFloat maxWidth = CGRectGetMinX(self.rightOverlayView.frame) - (self.minLength * self.widthPerSecond);
                CGFloat newLeftViewMinX = _scrollView.x;
                CGFloat newLeftViewManX = _rightMoveView.center.x - (self.minLength * self.widthPerSecond);
                if (newLeftViewMidX < newLeftViewMinX) {
                    newLeftViewMidX = newLeftViewMinX;
                } else if (newLeftViewMidX > newLeftViewManX) {
                    newLeftViewMidX = newLeftViewManX;
                }
                
                self.leftMoveView.center = CGPointMake(newLeftViewMidX, self.leftMoveView.center.y);
                self.leftStartPoint = point;
            }
            //------------------------------------------------------------------------------------------------------------
            
            [self updateBorderFrames];
            [self notifyDelegateOfDidChange];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self notifyDelegateOfEndEditing];
        }
            
        default:
            break;
    }
}


- (void)seekToTime:(CGFloat) time
{
    CGFloat duration = fabs(_prevTrackerTime - time);
    BOOL animate = (duration>1) ?  NO : YES;
    _prevTrackerTime = time;
    
    
    CGFloat posToMove = time * self.widthPerSecond + self.thumbWidth - self.scrollView.contentOffset.x;
    
    CGRect trackerFrame = self.trackerView.frame;
    trackerFrame.origin.x = posToMove;
    if (animate){
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.trackerView.frame = trackerFrame;
        } completion:nil ];
    }
    else{
        self.trackerView.frame = trackerFrame;
    }
    
}

- (void)hideTracker:(BOOL)flag
{
    if ( flag == YES ){
        self.trackerView.hidden = YES;
    }
    else{
        self.trackerView.alpha = 0;
        self.trackerView.hidden = NO;
        [UIView animateWithDuration:.3 animations:^{
            self.trackerView.alpha = 1;
        }];
    }
}

- (void)notifyDelegateOfDidChange
{
    NSLog(@"leftOverlayView:%f , rightOverlayView:%f contentOffset.x:%@", CGRectGetMaxX(self.leftOverlayView.frame) , CGRectGetMaxX(self.rightOverlayView.frame) , @(self.scrollView.contentOffset.x));
    
    
    CGFloat start = CGRectGetMaxX(self.leftOverlayView.frame) / self.widthPerSecond + (self.scrollView.contentOffset.x -self.thumbWidth) / self.widthPerSecond;
    CGFloat end = CGRectGetMinX(self.rightOverlayView.frame) / self.widthPerSecond + (self.scrollView.contentOffset.x - self.thumbWidth) / self.widthPerSecond;
    
    if (!self.trackerView.hidden && start != self.startTime) {
        [self seekToTime:start];
    }
    
    if (start==self.startTime && end==self.endTime){
        // thumb events may fire multiple times with the same value, so we detect them and ignore them.
        NSLog(@"no change");
        return;
    }
    
    self.startTime = start;
    self.endTime = end;
    
    if([self.delegate respondsToSelector:@selector(trimmerView:didChangeLeftPosition:rightPosition:)])
    {
        [self.delegate trimmerView:self didChangeLeftPosition:self.startTime rightPosition:self.endTime];
    }
}

-(void) notifyDelegateOfEndEditing
{
    if([self.delegate respondsToSelector:@selector(trimmerViewDidEndEditing:)])
    {
        [self.delegate trimmerViewDidEndEditing:self];
    }
}

- (void)addFrames
{
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
    self.imageGenerator.appliesPreferredTrackTransform = YES;
    if ([self isRetina]){
        self.imageGenerator.maximumSize = CGSizeMake(CGRectGetWidth(self.frameView.frame)*2, CGRectGetHeight(self.frameView.frame)*2);
    } else {
        self.imageGenerator.maximumSize = CGSizeMake(CGRectGetWidth(self.frameView.frame), CGRectGetHeight(self.frameView.frame));
    }
    
    CGFloat picWidth = 0;
    
    // First image
    NSError *error;
    CMTime actualTime;
    CGImageRef halfWayImage = [self.imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:&actualTime error:&error];
    UIImage *videoScreen;//第一秒的第一张截图
    if ([self isRetina]){
        videoScreen = [[UIImage alloc] initWithCGImage:halfWayImage scale:2.0 orientation:UIImageOrientationUp];
        //        UIImageWriteToSavedPhotosAlbum(videoScreen, self, nil, nil);
    } else {
        videoScreen = [[UIImage alloc] initWithCGImage:halfWayImage];
    }
    if (halfWayImage != NULL) {
        UIImageView *tmp = [[UIImageView alloc] initWithImage:videoScreen];
        CGRect rect = tmp.frame;
        rect.size.width = videoScreen.size.width;
        tmp.frame = rect;
        [self.frameView addSubview:tmp];
        picWidth = tmp.frame.size.width;
        CGImageRelease(halfWayImage);
    }
    
    Float64 duration = CMTimeGetSeconds([self.asset duration]);//视频时间
    CGFloat screenWidth = CGRectGetWidth(_frameView.frame); //
    NSInteger actualFramesNeeded;//一共多少张
    
    CGFloat factor = (duration / self.maxLength);//倍数
    factor = (factor < 1 ? 1 : factor);
    CGFloat frameViewFrameWidth = factor * screenWidth;//内容宽度
    [self.frameView setFrame:CGRectMake(0, 0, frameViewFrameWidth, CGRectGetHeight(self.frameView.frame))];
    CGFloat contentViewFrameWidth = CMTimeGetSeconds([self.asset duration]) <= self.maxLength + 0.5 ? _contentView.width : frameViewFrameWidth;
    [self.contentView setFrame:CGRectMake(0, 0, contentViewFrameWidth, CGRectGetHeight(self.contentView.frame))];
    [self.scrollView setContentSize:self.contentView.frame.size];
    NSInteger minFramesNeeded = screenWidth / picWidth + 1;//屏幕可以放多少张
    actualFramesNeeded =  factor * minFramesNeeded + 1;//一共多少张
    
    Float64 durationPerFrame = duration / (actualFramesNeeded*1.0);//每张多少时间
    self.widthPerSecond = frameViewFrameWidth / duration;//每秒多少个长度
    
    int preferredWidth = 0;
    NSMutableArray *times = [[NSMutableArray alloc] init];
    for (int i=1; i<actualFramesNeeded; i++){
        
        CMTime time = CMTimeMakeWithSeconds(i*durationPerFrame, 600);
        [times addObject:[NSValue valueWithCMTime:time]];
        
        UIImageView *tmp = [[UIImageView alloc] initWithImage:videoScreen];
        tmp.tag = i;
        
        CGRect currentFrame = tmp.frame;
        currentFrame.origin.x = i*picWidth;
        
        currentFrame.size.width = picWidth;
        preferredWidth += currentFrame.size.width;
        
        if( i == actualFramesNeeded-1){
            currentFrame.size.width-=6;
        }
        tmp.frame = currentFrame;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.frameView addSubview:tmp];
        });
        
        
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=1; i<=[times count]; i++) {
            CMTime time = [((NSValue *)[times objectAtIndex:i-1]) CMTimeValue];
            
            CGImageRef halfWayImage = [self.imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
            
            UIImage *videoScreen;
            if ([self isRetina]){
                videoScreen = [[UIImage alloc] initWithCGImage:halfWayImage scale:2.0 orientation:UIImageOrientationUp];
            } else {
                videoScreen = [[UIImage alloc] initWithCGImage:halfWayImage];
            }
            
            CGImageRelease(halfWayImage);
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                UIImageView *imageView = (UIImageView *)[self.frameView viewWithTag:i];
            //                [imageView setImage:videoScreen];
            //
            //            });
        }
    });
}

- (BOOL)isRetina
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale > 1.0));
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (CMTimeGetSeconds([self.asset duration]) <= self.maxLength + 0.5) {
        [UIView animateWithDuration:0.3 animations:^{
            [scrollView setContentOffset:CGPointZero];
        }];
    }
    [self notifyDelegateOfDidChange];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self notifyDelegateOfEndEditing];
}


@end

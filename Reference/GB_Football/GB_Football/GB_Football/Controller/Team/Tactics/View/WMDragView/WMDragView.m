//
//  WMDragView.m
//  DragButtonDemo
//
//  Created by zhengwenming on 2016/12/16.
//
//

#import "WMDragView.h"
#import "GBTacticsPlayerModel.h"
#import "YHCommon.h"

@interface WMDragView ()

@property (weak, nonatomic) IBOutlet UIView *posView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,assign) CGPoint startPoint;
//触发手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation WMDragView

#pragma mark - Setter and Getter

- (UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (!_tapGestureRecognizer) {
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureUpdated:)];
        _tapGestureRecognizer.numberOfTapsRequired = 2;
        _tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    return _tapGestureRecognizer;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    
    if (!_panGestureRecognizer) {
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureUpdated:)];
        _panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_panGestureRecognizer];
    }
    return _panGestureRecognizer;
}

- (CGRect)freeRect {
    
    return (CGRect){CGPointZero,self.superview.bounds.size};
}

- (void)setDragEnable:(BOOL)dragEnable {
    
    _dragEnable = dragEnable;
    self.tapGestureRecognizer.enabled = dragEnable;
    self.panGestureRecognizer.enabled = dragEnable;
}

- (void)setTacticsPlayerModel:(GBTacticsPlayerModel *)tacticsPlayerModel {
    
    _tacticsPlayerModel = tacticsPlayerModel;
    if (tacticsPlayerModel.image) {
        self.imageView.image = tacticsPlayerModel.image;
        self.posView.hidden = YES;
    }else {
        self.posView.backgroundColor = tacticsPlayerModel.playerColor;
        self.imageView.hidden = YES;
    }
    self.numberLabel.text = tacticsPlayerModel.playerNumber;
    self.nameLabel.text = tacticsPlayerModel.playerName;
    if ([NSString stringIsNullOrEmpty:tacticsPlayerModel.playerName]) {
        self.size = CGSizeMake(kWMDragViewWidth, kWMDragViewDefaultHeight);
    }else {
        self.size = CGSizeMake(kWMDragViewWidth, kWMDragViewWithNameHeight);
    }
    //根据圆点位置设置frame位置
    self.center = tacticsPlayerModel.playerCurrentPos;
}


#pragma mark - Init

///代码初始化
- (instancetype)init {
    
    return [[WMDragView alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
///从xib中加载
- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setUp];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.posView.layer.cornerRadius = self.posView.frame.size.width/2;
}

#pragma mark - Public


#pragma mark - Private

- (void)setUp {
    
    self.clipsToBounds = YES;
    self.isKeepBounds = NO;
    self.moveScale = 1.5f;
    self.dragEnable = YES;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)beginMove
{
    //animation
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(self.moveScale, self.moveScale);
                     }completion:^(BOOL finish){
                         
                     }];
}

- (void)endMove {
    
    //animation
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1, 1);
                     }completion:^(BOOL finish){
                         self.tacticsPlayerModel.playerCurrentPos = self.center;
                     }];
}

#pragma mark - Gesture

- (void)tapGestureUpdated:(UITapGestureRecognizer *)tapGesture {
    
    //animation
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(self.moveScale, self.moveScale);
                     }completion:^(BOOL finish){
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.transform = CGAffineTransformMakeScale(1, 1);
                                          }completion:^(BOOL finish){
                                              
                                          }];
                     }];
    if (self.clickDragViewBlock) {
        self.clickDragViewBlock(self);
    }
}

- (void)panGestureUpdated:(UIPanGestureRecognizer *)panGesture {
    
    NSLog(@"panGestureUpdated.state:%td", panGesture.state);
    switch (panGesture.state)
    {
            case UIGestureRecognizerStateBegan:{///开始拖动
                if (self.beginDragBlock) {
                    self.beginDragBlock(self);
                }
                [self beginMove];
                //  注意一旦你完成上述的移动，将translation重置为0十分重要。否则translation每次都会叠加
                //[longPressGesture setTranslation:CGPointZero inView:self.moveView];
                //保存触摸起始点位置
                self.startPoint = [panGesture locationInView:self];
                
                break;
            }
            case UIGestureRecognizerStateChanged:{///拖动中
                //计算位移 = 当前位置 - 起始位置
                if (self.duringDragBlock) {
                    self.duringDragBlock(self);
                }
                CGPoint point = [panGesture locationInView:self];
                float dx;
                float dy;
                switch (self.dragDirection) {
                        case WMDragDirectionAny:
                        dx = point.x - self.startPoint.x;
                        dy = point.y - self.startPoint.y;
                        break;
                        case WMDragDirectionHorizontal:
                        dx = point.x - self.startPoint.x;
                        dy = 0;
                        break;
                        case WMDragDirectionVertical:
                        dx = 0;
                        dy = point.y - self.startPoint.y;
                        break;
                    default:
                        dx = point.x - self.startPoint.x;
                        dy = point.y - self.startPoint.y;
                        break;
                }
                
                //计算移动后的view中心点
                CGPoint newCenter = CGPointMake(self.center.x + dx, self.center.y + dy);
                //移动view
                self.center = newCenter;
                //  注意一旦你完成上述的移动，将translation重置为0十分重要。否则translation每次都会叠加
                //[longPressGesture setTranslation:CGPointZero inView:self.moveView];
                break;
            }
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateFailed:{///拖动结束
                [self keepBounds];
                [self endMove];
                if (self.endDragBlock) {
                    self.endDragBlock(self);
                }
                break;
            }
        default:
            break;
    }
}



- (void)keepBounds{
    //中心点判断
    float centerX = self.freeRect.origin.x+(self.freeRect.size.width - self.frame.size.width)/2;
    CGRect rect = self.frame;
    if (self.isKeepBounds==NO) {//没有黏贴边界的效果
        if (self.frame.origin.x < self.freeRect.origin.x) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"leftMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.freeRect.origin.x;
            self.frame = rect;
            [UIView commitAnimations];
        } else if(self.freeRect.origin.x+self.freeRect.size.width < self.frame.origin.x+self.frame.size.width){
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"rightMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.freeRect.origin.x+self.freeRect.size.width-self.frame.size.width;
            self.frame = rect;
            [UIView commitAnimations];
        }
    }else if(self.isKeepBounds==YES){//自动粘边
        if (self.frame.origin.x< centerX) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"leftMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.freeRect.origin.x;
            self.frame = rect;
            [UIView commitAnimations];
        } else {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"rightMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x =self.freeRect.origin.x+self.freeRect.size.width - self.frame.size.width;
            self.frame = rect;
            [UIView commitAnimations];
        }
    }
    
    if (self.frame.origin.y < self.freeRect.origin.y) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"topMove" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        rect.origin.y = self.freeRect.origin.y;
        self.frame = rect;
        [UIView commitAnimations];
    } else if(self.freeRect.origin.y+self.freeRect.size.height< self.frame.origin.y+self.frame.size.height){
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"bottomMove" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        rect.origin.y = self.freeRect.origin.y+self.freeRect.size.height-self.frame.size.height;
        self.frame = rect;
        [UIView commitAnimations];
    }
}

#pragma mark - Delegate


//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//
//    NSLog(@"gestureRecognizerShouldBegin");
//
//    return YES;
//}



@end

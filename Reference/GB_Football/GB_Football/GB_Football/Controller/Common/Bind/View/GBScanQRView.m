//
//  GBScanQRView.m
//  GB_Football
//
//  Created by Pizza on 16/8/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBScanQRView.h"

@implementation BackView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.5);
    CGContextFillRect(context, rect);
    CGContextClearRect(context, self.rectWhite);
}

@end

@interface GBScanQRView()<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
}
@property (strong,nonatomic) AVCaptureDevice * device;
@property (strong,nonatomic) AVCaptureDeviceInput * input;
@property (strong,nonatomic) AVCaptureMetadataOutput * output;
@property (strong,nonatomic) AVCaptureSession * session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer * preview;
@property (strong, nonatomic)  UIImageView * line;
@property (strong, nonatomic)  UIImageView *imgBK;
@property (strong, nonatomic)  BackView *viewBK;

@property (nonatomic, strong) NSTimer *timer;

@end
@implementation GBScanQRView

-(void)dealloc
{
    [self stopCameraScan];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    upOrdown = NO;
    num =0;
    [self setupUI];
    [self setupCamera];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avCaptureInputPortFormatDescriptionDidChangeNotification) name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.preview.frame = self.bounds;
    self.viewBK.frame = self.bounds;
    self.imgBK.size = CGSizeMake(200*kAppScale, 200*kAppScale);
    [self.imgBK setCenter:CGPointMake(self.viewBK.width/2, self.viewBK.height/2)];
    self.line.center = CGPointMake(self.imgBK.center.x, self.imgBK.top);
    self.viewBK.rectWhite = CGRectMake(self.imgBK.centerX-self.imgBK.width/2,
                                       self.imgBK.centerY-self.imgBK.height/2,
                                       self.imgBK.bounds.size.width,
                                       self.imgBK.bounds.size.height);
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)avCaptureInputPortFormatDescriptionDidChangeNotification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = [self.preview metadataOutputRectOfInterestForRect:self.imgBK.frame];
        self.output.rectOfInterest = rect;
    });
}

#pragma mark Public

- (void)startCameraScan {
    
    // Start
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [_session startRunning];
    [self startTimer];
    //});
}

- (void)stopCameraScan {
    
    [self.preview removeFromSuperlayer];
    self.preview = nil;
    
    [self.session removeOutput:self.output];
    [self.session removeInput:self.input];
    [self.session stopRunning];
    self.session = nil;
    
    [self.output setMetadataObjectsDelegate:nil queue:dispatch_get_main_queue()];
    self.output = nil;
    
    self.input = nil;
    
    [self stopTimer];
}

#pragma mark Private

- (void)animation {
    
    CGRect frame = _line.frame;
    CGFloat move = 2.0f;
    if (upOrdown == NO) {
        num ++;
        frame.origin.y = self.imgBK.frame.origin.y + move*num;
        _line.frame = frame;
        if (2*num >= self.imgBK.bounds.size.height - 20) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        frame.origin.y = self.imgBK.frame.origin.y + move*num;
        _line.frame = frame;
        if (num == 10) {
            upOrdown = NO;
        }
    }
}

- (void)setupUI {
    
    self.viewBK = [[BackView alloc] initWithFrame:self.bounds];
    self.viewBK.backgroundColor = [UIColor clearColor];
    [self addSubview:self.viewBK];
    
    self.imgBK = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 185, 185)];
    self.imgBK.image = [UIImage imageNamed:@"code_box"];
    self.line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imgBK.width, 2)];
    self.line.image = [UIImage imageNamed:@"scan_line"];
    
    [self.viewBK addSubview:self.imgBK];
    [self.viewBK addSubview:self.line];
}

- (void)setupCamera
{
    if (![LogicManager checkIsOpenCamera] || _session)
    {
        return;
    }
    
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];

    // Preview
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer insertSublayer:self.preview atIndex:0];

}

- (void)startTimer {
    
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:.025 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    
    [self.timer invalidate];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [self.session stopRunning];
    
    [self barCodeAction:stringValue];
    
    [self stopTimer];
    
}

- (void)barCodeAction:(NSString *)barCodeContent {
    
    if (self.selectedHandler) {
        self.selectedHandler(barCodeContent);
        self.selectedHandler = nil;
    }
}

@end

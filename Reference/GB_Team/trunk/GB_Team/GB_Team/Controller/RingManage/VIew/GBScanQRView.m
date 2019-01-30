//
//  GBScanQRView.m
//  GB_Football
//
//  Created by Pizza on 16/8/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBScanQRView.h"
#import "XXNibBridge.h"
#import "AppDelegate.h"

@implementation BackView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 0);
    CGContextFillRect(context, rect);
    CGContextClearRect(context, self.rectWhite);
}

@end

@interface GBScanQRView()<XXNibBridge,AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (weak, nonatomic) IBOutlet UIImageView * line;
@property (weak, nonatomic) IBOutlet UIImageView *imgBK;
@property (weak, nonatomic) IBOutlet BackView *viewBK;

@property (nonatomic, strong) NSTimer *timer;

@end
@implementation GBScanQRView

-(void)awakeFromNib
{
    [super awakeFromNib];
    upOrdown = NO;
    num =0;
    [self setupCamera];
    
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer timerWithTimeInterval:.05 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)animation
{
    CGRect frame = _line.frame;
    if (upOrdown == NO) {
        num ++;
        frame.origin.y = self.imgBK.frame.origin.y + 2*num;
        _line.frame = frame;
        if (2*num >= self.imgBK.bounds.size.height - 20) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        frame.origin.y = self.imgBK.frame.origin.y + 2*num;
        _line.frame = frame;
        if (num == 10) {
            upOrdown = NO;
        }
    }
}

-(void)dealloc
{
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _preview.frame = self.bounds;
    _line.center = self.imgBK.center;
    self.viewBK.rectWhite = CGRectMake(self.center.x-self.imgBK.bounds.size.width/2,
                                       self.center.y-self.imgBK.bounds.size.height/2,
                                       self.imgBK.bounds.size.width,
                                       self.imgBK.bounds.size.height);
    self.backgroundColor = [UIColor clearColor];
}


- (BOOL)isCameraAvailable;
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    return [videoDevices count] > 0;
}

- (void)setupCamera
{
    if (![self isCameraAvailable] || _session)
    {
        return;
    }
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;

}

- (void)cleanData {
    
    [_timer invalidate];
}

- (void)startCameraScan {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // Start
    self.isStart = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_session startRunning];
    });
}

- (void)stopCameraScan {
    
    [_preview removeFromSuperlayer];
    _preview = nil;

    [_session removeOutput:_output];
    [_session removeInput:_input];
    [_session stopRunning];
    _session = nil;
    
    [_output setMetadataObjectsDelegate:nil queue:dispatch_get_main_queue()];
    _output = nil;
    
    _input = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.hidden = YES;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (!self.isStart) {
        return;
    }
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }

    [self barCodeAction:stringValue];
    
    self.isStart = NO;
}

- (void)barCodeAction:(NSString *)barCodeContent
{
    if (self.selectedHandler)
    {
        self.selectedHandler(barCodeContent);
    }
}

- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation
{
    UIInterfaceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    switch (deviceOrientation)
    {
        case UIInterfaceOrientationLandscapeLeft: {
            return AVCaptureVideoOrientationLandscapeLeft;
        }
        case UIInterfaceOrientationLandscapeRight: {
            return AVCaptureVideoOrientationLandscapeRight;
        }
        case UIInterfaceOrientationPortrait: {
            return AVCaptureVideoOrientationPortrait;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            return AVCaptureVideoOrientationPortraitUpsideDown;
        }
        default: return _preview.connection.videoOrientation;
    }
    return _preview.connection.videoOrientation;
}

- (void)deviceOrientationDidChange
{
    AVCaptureVideoOrientation videoOrient = [self videoOrientationFromCurrentDeviceOrientation];
    _preview.connection.videoOrientation = videoOrient;
}

#pragma mark - Setter

- (void)setIsStart:(BOOL)isStart {
    
    _isStart = isStart;
    
    self.hidden = !_isStart;
    if (_isStart) {
        [self.layer insertSublayer:self.preview atIndex:0];
    }
}

@end

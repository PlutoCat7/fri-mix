//
//  GBMapPolylineViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMapPolylineViewController.h"
#import "GBMapPolylineViewControllerViewModel.h"

#import "GBMapPolyLineView.h"
#import "GBAlertViewOneWay.h"

#import "RunRequest.h"

@interface GBMapPolylineViewController ()

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (nonatomic, strong) GBMapPolyLineView *polylineView;
@property (nonatomic, strong) GBMapPolylineViewControllerViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeConsumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *burnLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIView *distanceView;
@property (weak, nonatomic) IBOutlet UIView *showDataView;

//静态文本
@property (weak, nonatomic) IBOutlet UILabel *slowLabel;
@property (weak, nonatomic) IBOutlet UILabel *fastLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *burnStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedStaticLabel;


@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) float distance;
@property (nonatomic, assign) float consume;
@property (nonatomic, copy) NSString *withSpeedString;
@property (nonatomic, copy) NSString *consumeTimeString;

@end

@implementation GBMapPolylineViewController

- (instancetype)initWithRunRecordInfo:(RunRecordInfo *)runRecordInfo
{
    self = [super init];
    if (self) {
        _startTime = runRecordInfo.startTime;
        _distance = runRecordInfo.distance;
        _consume = runRecordInfo.consume;
        _withSpeedString = runRecordInfo.withSpeedString;
        _consumeTimeString = runRecordInfo.consumeTimeString;
    }
    return self;
}

- (instancetype)initWithStartTime:(NSInteger)startTime {
    
    self = [super init];
    if (self) {
        _startTime = startTime;
        _distance = 0;
        _consume = 0;
        _withSpeedString = @"";
        _consumeTimeString = @"";
    }
    return self;
}

- (void)localizeUI {
    
    self.slowLabel.text = LS(@"run.record.label.slow");
    self.fastLabel.text = LS(@"run.record.label.fast");
    self.timeStaticLabel.text = LS(@"run.record.label.duraton");
    self.burnStaticLabel.text = LS(@"run.record.dateal.label.calorie");
    self.speedStaticLabel.text = LS(@"run.record.label.speed");
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.polylineView.frame = self.mapContainerView.bounds;
}

#pragma mark - Analytics

- (void)shareSuccess {
    [UMShareManager event:Analy_Click_Share_Run];
}

#pragma mark - OverWrite

- (UIImage *)shareImage {
    
    UIImage *shareImage = nil;
    
    NSArray *subViews = @[self.showDataView];
    shareImage = [LogicManager getImageWithHeadImage:@[[self.viewModel imageWithOriginImage:[self.polylineView snapshotImage] addView:self.distanceView]] subviews:subViews backgroundImage:[UIImage imageWithColor:[UIColor blackColor]]];
    
    return shareImage;
}

#pragma mark - Private

- (void)loadData {
    
    //检查是否有缓存
    [RunResponseInfo loadCacheWithKey:@(self.startTime).stringValue withBlock:^(NSString *key, __kindof YAHDataResponseInfo *object) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            RunResponseInfo *runResponseInfo = object;
            if (runResponseInfo) {
                RunDetailInfo *info = runResponseInfo.data;
                [self drawPolyline:info];
            }else {
                [self showLoadingToast];
                @weakify(self)
                [RunRequest getRunDataWithRunTime:self.startTime handler:^(id result, NSError *error) {
                    
                    @strongify(self)
                    if (error) {
                        [self showToastWithText:error.domain];
                    }else {
                        [self dismissToast];
                        RunDetailInfo *info = (RunDetailInfo *)result;
                        [self drawPolyline:info];
                    }
                }];
            }
        });
    }];
    
}

- (void)setupUI {
    
    [super setupUI];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.startTime];
    self.title = [NSString stringWithFormat:@"%02td%@%02td%@", date.month, LS(@"run.record.label.month"), date.day, LS(@"run.record.label.day")];
    self.polylineView.frame = self.mapContainerView.bounds;
    
    [self refreshUI];
}

- (void)drawPolyline:(RunDetailInfo *)info {
    
    @weakify(self)
    self.viewModel = [[GBMapPolylineViewControllerViewModel alloc] initWithDictData:info.run_data exceptionBlock:^{
        @strongify(self)
        if (self.navigationController.topViewController == self) {
            [GBAlertViewOneWay showWithTitle:LS(@"run.model.data.error.tips") content:LS(@"run.model.data.error.content") button:LS(@"sync.popbox.btn.got.it") onOk:nil style:GBALERT_STYLE_SURE_GREEN];
        }
    }];
    self.polylineView.runInfoList = self.viewModel.runInfoList;
    self.distance = info.distance;
    self.consume = info.consume;
    self.withSpeedString = info.withSpeedString;
    self.consumeTimeString = info.consumeTimeString;
    [self refreshUI];
}

- (void)refreshUI {
    
    NSString *distanceString = @"";
    NSString *distanceUnit = @"";
    if (self.distance>1000) {
        distanceString = [NSString stringWithFormat:@"%0.1f  KM", self.distance/1000];
        distanceUnit = @"KM";
    }else {
        distanceString = [NSString stringWithFormat:@"%0.1f  M", self.distance];
        distanceUnit = @"M";
    }
    
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:distanceString];
    NSRange kmRange = [distanceString rangeOfString:distanceUnit];
    [mString addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"BEBAS" size:13.0f]
                    range:kmRange];
    [mString addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHex:0x909090]
                    range:kmRange];
    self.distanceLabel.attributedText = mString;
    
    self.timeConsumeLabel.text = self.consumeTimeString;
    self.burnLabel.text = [NSString stringWithFormat:@"%0.1f", self.consume];
    self.speedLabel.text = self.withSpeedString;
}

#pragma mark - Setter and Getter

- (GBMapPolyLineView *)polylineView {
    
    if (!_polylineView) {
        _polylineView = [[NSBundle mainBundle]loadNibNamed:@"GBMapPolyLineView" owner:self options:nil].firstObject;
        _polylineView.frame = self.mapContainerView.bounds;
        
        [self.mapContainerView addSubview:_polylineView];
    }
    return _polylineView;
}

@end

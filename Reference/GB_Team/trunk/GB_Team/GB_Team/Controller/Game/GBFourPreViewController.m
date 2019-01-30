//
//  GBFourPreViewController.m
//  GB_Team
//
//  Created by gxd on 16/11/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFourPreViewController.h"
#import "GBHightLightButton.h"
#import "CourtRequest.h"

@interface GBFourPreViewController ()<MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet GBHightLightButton *resetButton;
@property (weak, nonatomic) IBOutlet GBHightLightButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextView *courtNameText;
@property (weak, nonatomic) IBOutlet UITextView *courtAddrText;

// 计算矩形
@property (nonatomic, strong) MAPolygon *calculatePolygon;
// 原始四点
@property (nonatomic, strong) MAPolygon *originalPolygon;
// 大头针集合
@property (nonatomic, strong) NSMutableArray *annotations;

@end

@implementation GBFourPreViewController
#pragma mark -
#pragma mark Memory

- (void)dealloc{
    [_mapView removeObserver:self forKeyPath:@"showsUserLocation"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setupUI
{
    self.title=LS(@"球场预览");
    self.resetButton.enabled = YES;
    self.saveButton.enabled  = YES;
    self.courtAddrText.text = self.address;
    self.courtNameText.text = self.name;
    [self setupBackButtonWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RestartLocate object:nil];
    }];
    [self setupMapView];
    // 绘制计算后的球场矩形
    [self drawCalculateToMap];
    // 大头针标记球场四角
    [self performBlock:^{[self drawPin];} delay:1.f];
    
}

// 地图参数设置
-(void)setupMapView
{
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setMapType:MAMapTypeSatellite];
    [self.mapView setShowsScale:NO];
    [self.mapView setShowsCompass:NO];
    [self.mapView setZoomLevel:18.6 animated:YES];
    self.mapView.delegate = self;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self initLocationObservers];
}

// 地图位置中心点跟随
- (void)initLocationObservers {
    [self.mapView addObserver:self forKeyPath:@"showsUserLocation" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Getters & Setters

// 原始四点绘制-不开启
-(void)drawOrignalToMap
{
    self.orignalPoints = [self originalPoints];
    self.originalPolygon = [self buildPolygon:self.orignalPoints];
    if (self.originalPolygon == nil)return;
    [self.mapView removeOverlay:self.originalPolygon];
    [self.mapView addOverlay:self.originalPolygon];
}

// 绘制服务端返回的最小外接矩形
-(void)drawCalculateToMap
{
    self.calculatePoints = [self calculatePoints];
    self.calculatePolygon = [self buildPolygon:self.calculatePoints];
    if (self.calculatePolygon == nil)return;
    [self.mapView removeOverlay:self.calculatePolygon];
    [self.mapView addOverlay:self.calculatePolygon];
}


// 根据四点生成图层
-(MAPolygon*)buildPolygon:(NSArray<NSValue*>*)points
{
    if ([points count] != 4)return nil;
    CLLocationCoordinate2D rectPoints[4];
    rectPoints[0] = [points[0] MACoordinateValue];
    rectPoints[1] = [points[1] MACoordinateValue];
    rectPoints[2] = [points[2] MACoordinateValue];
    rectPoints[3] = [points[3] MACoordinateValue];
    return  [MAPolygon polygonWithCoordinates:rectPoints count:4];
}

// 重新定位
- (IBAction)actionResetLocate:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ResetCourtSuccess object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

// 保存
- (IBAction)actionPressSave:(id)sender
{
    [self requestAddCourt];
}

-(void)drawPin
{
    // 初始化
    self.annotations = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < [self.calculatePoints count]; i++)
    {
        MAPointAnnotation *pin = [[MAPointAnnotation alloc] init];
        pin.coordinate = [self.calculatePoints[i] MACoordinateValue];
        [self.annotations addObject:pin];
    }
    // 绘制到地图
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:NO];
}

// 添加球场
-(void)requestAddCourt
{
    CourtInfo *courtObj = [[CourtInfo alloc] init];
    courtObj.courtName    = [self.courtNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    courtObj.courtAddress = [self.courtAddrText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    courtObj.location = [[LocationCoordinateInfo alloc] initWithLon:self.oneLocation.longitude lat:self.oneLocation.latitude];
    courtObj.locA = [[LocationCoordinateInfo alloc] initWithLon:self.oneLocation.longitude lat:self.oneLocation.latitude];;
    courtObj.locB = [[LocationCoordinateInfo alloc] initWithLon:self.twoLocation.longitude lat:self.twoLocation.latitude];;
    courtObj.locC = [[LocationCoordinateInfo alloc] initWithLon:self.threeLocation.longitude lat:self.threeLocation.latitude];;
    courtObj.locD = [[LocationCoordinateInfo alloc] initWithLon:self.fourLocation.longitude lat:self.fourLocation.latitude];
    [self showLoadingToast];
    @weakify(self);
    [CourtRequest addCourt:courtObj handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error)
        {
            [self showToastWithText:error.domain];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CreateCourtSuccess object:nil];
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [viewControllers removeLastObject];
            [viewControllers removeLastObject];
            [self.navigationController  setViewControllers:viewControllers animated:YES];
        }
    }];
}

// 服务器计算的坐标点
-(NSArray*)calculatePoints
{
    NSMutableArray *arrayPoint = [[NSMutableArray alloc]init];
    CLLocationCoordinate2D rectPoints[4];
    rectPoints[0].longitude = self.calOneLocation.longitude;
    rectPoints[0].latitude  = self.calOneLocation.latitude;
    rectPoints[1].longitude = self.calTwoLocation.longitude;
    rectPoints[1].latitude  = self.calTwoLocation.latitude;
    rectPoints[2].longitude = self.calThreeLocation.longitude;
    rectPoints[2].latitude  = self.calThreeLocation.latitude;
    rectPoints[3].longitude = self.calFourLocation.longitude;
    rectPoints[3].latitude  = self.calFourLocation.latitude;
    [arrayPoint addObject:[NSValue valueWithMACoordinate:rectPoints[0]]];
    [arrayPoint addObject:[NSValue valueWithMACoordinate:rectPoints[1]]];
    [arrayPoint addObject:[NSValue valueWithMACoordinate:rectPoints[2]]];
    [arrayPoint addObject:[NSValue valueWithMACoordinate:rectPoints[3]]];
    return (NSArray*)[arrayPoint mutableCopy];
}

// 原始坐标点
-(NSArray*)originalPoints
{
    NSMutableArray *arrayPoint = [[NSMutableArray alloc]init];
    CLLocationCoordinate2D rectPoints[4];
    rectPoints[0].longitude = self.oneLocation.longitude;
    rectPoints[0].latitude  = self.oneLocation.latitude;
    rectPoints[1].longitude = self.twoLocation.longitude;;
    rectPoints[1].latitude  = self.twoLocation.latitude;
    rectPoints[2].longitude = self.threeLocation.longitude;;
    rectPoints[2].latitude  = self.threeLocation.latitude;
    rectPoints[3].longitude = self.fourLocation.longitude;;
    rectPoints[3].latitude  = self.fourLocation.latitude;
    [arrayPoint addObject:[NSValue valueWithMACoordinate:rectPoints[0]]];
    [arrayPoint addObject:[NSValue valueWithMACoordinate:rectPoints[1]]];
    [arrayPoint addObject:[NSValue valueWithMACoordinate:rectPoints[2]]];
    [arrayPoint addObject:[NSValue valueWithMACoordinate:rectPoints[3]]];
    return (NSArray*)[arrayPoint mutableCopy];
}

// 角旗绘制
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"positioning_3"];
        return annotationView;
    }
    return nil;
}

// 球场绘制
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        if (overlay == self.calculatePolygon)
        {
            MAPolygonRenderer *polygonRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
            polygonRenderer.lineWidth   = 2.f;
            polygonRenderer.strokeColor = [UIColor colorWithHex:0x58e357 andAlpha:0.6];
            polygonRenderer.fillColor   = [UIColor colorWithHex:0x58e357 andAlpha:0.6];
            return polygonRenderer;
        }
        else if(overlay == self.originalPolygon)
        {
            MAPolygonRenderer *polygonRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
            polygonRenderer.lineWidth   = 2.f;
            polygonRenderer.strokeColor = [UIColor colorWithHex:0xff0000 andAlpha:0.6];
            polygonRenderer.fillColor   = [UIColor colorWithHex:0xff0000 andAlpha:0.6];
            return polygonRenderer;
        }
        return nil;
    }
    return nil;
}

@end

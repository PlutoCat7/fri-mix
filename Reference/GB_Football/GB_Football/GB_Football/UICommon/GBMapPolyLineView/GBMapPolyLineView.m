//
//  GBMapPolyLineView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMapPolyLineView.h"
#import "GBMapPolyLineViewModel.h"
#import "GBMAPointAnnotation.h"

@interface GBMapPolyLineView ()<MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (strong, nonatomic) MAMapView *mapView;

@property (nonatomic, strong) GBMapPolyLineViewModel *viewModel;

@end

@implementation GBMapPolyLineView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    
    [self.mapContainerView insertSubview:self.mapView atIndex:0];
}

- (UIImage *)snapshotImage {
    
    return [self.mapView takeSnapshotInRect:self.mapView.bounds];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.mapView.frame = self.mapContainerView.bounds;
}

- (void)setRunInfoList:(NSArray<RunInfo *> *)runInfoList {
    
    _runInfoList = runInfoList;
    //构造背景圆
    MACircle *circle = [MACircle circleWithCenterCoordinate:self.viewModel.coordinateRegion.center radius:1000*20000];
    [_mapView addOverlay: circle];
    
    //摄像机位置
    [self.mapView setRegion:self.viewModel.coordinateRegion];
    
    @weakify(self)
    [self.viewModel getRunPolyLine:^(GBMKPolyline *runPolyLine) {
        
        @strongify(self)
        //轨迹图
        [self.mapView addOverlay:runPolyLine];
        
        //添加起点终点
        GBMAPointAnnotation *pin1 = [[GBMAPointAnnotation alloc] init];
        pin1.coordinate = CLLocationCoordinate2DMake(self.viewModel.runInfoList.firstObject.lat, self.viewModel.runInfoList.firstObject.lon);
        pin1.showImageName = @"ic_marker_start";
        GBMAPointAnnotation *pin2 = [[GBMAPointAnnotation alloc] init];
        pin2.coordinate = CLLocationCoordinate2DMake(self.viewModel.runInfoList.lastObject.lat, self.viewModel.runInfoList.lastObject.lon);
        pin2.showImageName = @"ic_marker_end";
        [self.mapView addAnnotations:@[pin1, pin2]];
    }];
    
}

#pragma mark - MKMapViewDelegate

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
        GBMAPointAnnotation *tmpAnnotation = (GBMAPointAnnotation *)annotation;
        annotationView.image = [UIImage imageNamed:tmpAnnotation.showImageName];
        return annotationView;
    }
    return nil;
}


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    
    if ([overlay isKindOfClass:[GBMKPolyline class]]) {
        GBMKPolyline * polyLine = (GBMKPolyline *)overlay;
        
        MAMultiColoredPolylineRenderer *aRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithOverlay:polyLine];
        aRenderer.gradient = YES;
        aRenderer.strokeColors = polyLine.colors;
        aRenderer.lineWidth = 8;
        aRenderer.lineJoinType = kMALineJoinRound;
        aRenderer.lineCapType = kMALineCapRound;
        
        return aRenderer;
    }else if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth    = 0.f;
        circleRenderer.fillColor    = [UIColor colorWithHex:0x232238 andAlpha:0.45];
        return circleRenderer;
    }
    
    return nil;
}

#pragma mark - Setter and Getter

//高德地图初始化
- (MAMapView *)mapView {
    
    if (!_mapView) {
        _mapView = [[MAMapView alloc]initWithFrame:self.mapContainerView.bounds];
        _mapView.delegate = self;
        [_mapView setRotateEnabled:YES];
        [_mapView setSkyModelEnable:NO];
        [_mapView setRotateCameraEnabled:NO];
        [_mapView setScrollEnabled:YES];
        [_mapView setMapType:MAMapTypeStandard];
        [_mapView setShowsScale:NO];
        [_mapView setShowsCompass:NO];
        
    }
    return _mapView;
}

- (GBMapPolyLineViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[GBMapPolyLineViewModel alloc] initWithRunInfoList:_runInfoList];
    }
    return _viewModel;
}

@end

//
//  FindPhotoHandleViewController.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoHandleViewController.h"
#import "YAHMultiPhotoViewController.h"
#import "FindPhotoAddLabelAlertView.h"
#import "FindPhotoHandleTips1View.h"
#import "FindPhotoHandleTips2View.h"
#import "FindPhotoLabelContainerView.h"
#import "FindPhotoHandleLabelView.h"

#import "HXPhotoModel.h"
#import "Masonry.h"


@interface FindPhotoHandleViewController () <
YAHMultiPhotoViewControllerDelegate>

@property (nonatomic, strong) YAHMultiPhotoViewController *multiPhotoVC;
@property (nonatomic, strong) FindPhotoLabelContainerView *labelContainerView;
@property (nonatomic, strong) FindPhotoAddLabelAlertView *alertView;
@property (nonatomic, weak) FindPhotoHandleTips1View *tips1View;
@property (nonatomic, strong) FindPhotoHandleTips2View *tips2View;
@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) NSArray<HXPhotoModel *> *photoList;
@property (nonatomic, strong) NSMutableArray<FindPhotoHandleModel *> *photoLabelList;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGPoint clickTagPoint;  //记录点击添加标签时的位置

@property (nonatomic, copy) void(^doneBlock)(NSArray<FindPhotoHandleModel *> *photoModelList);

@end

@implementation FindPhotoHandleViewController


- (instancetype)initWithPhotoList:(NSArray<HXPhotoModel *> *)photoList doneBlock:(void(^)(NSArray<FindPhotoHandleModel *> *photoModelList))doneBlock {
    
    self = [super init];
    if (self) {
        _photoList = photoList;
        _doneBlock = doneBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.doneBtn.size = CGSizeMake(70, 30);
    self.doneBtn.right = self.view.width-13;
    self.doneBtn.bottom = self.view.height-8;
}

#pragma mark - Action

- (void)actionBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didDoneBtnClick {
    
    if (_doneBlock) {
        _doneBlock([self.photoLabelList copy]);
    }
}

#pragma mark - Private

- (void)loadData {
    
    _photoLabelList = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger i=0; i<_photoList.count; i++) {
        FindPhotoHandleModel *model = [[FindPhotoHandleModel alloc] init];
        model.photoModel = _photoList[i];
        [_photoLabelList addObject:model];
    }
}

- (void)setupUI {
    
    [self setupPhotoView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, kDevice_Is_iPhoneX?44:20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"find_back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    _tips1View = [FindPhotoHandleTips1View showWithSuperView:self.view];
    
    [self.view addSubview:self.doneBtn];
}

- (void)setupPhotoView {
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *thumbPhotos = [NSMutableArray arrayWithCapacity:1];
    for (HXPhotoModel *photoModel in _photoList) {
        
        if (photoModel.previewPhoto) {
            [photos addObject:[YAHMutiZoomPhoto photoWithImage:photoModel.previewPhoto]];
        }else {
            [photos addObject:[YAHMutiZoomPhoto photoWithPhotoAsset:photoModel.asset]];
        }
        
        [thumbPhotos addObject:[YAHMutiZoomPhoto photoWithImage:photoModel.thumbPhoto]];
    }
    YAHMultiPhotoViewController *vc = [[YAHMultiPhotoViewController alloc] initWithImage:photos thumbImage:photos originFrame:nil selectIndex:0];
    vc.autoClickToClose = NO;
    vc.delegate = self;
    [self.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    self.multiPhotoVC = vc;
    [self addChildViewController:vc];
    
    
    [self.view addSubview:self.labelContainerView];
}

- (void)reloadLabelsView {
    
    [self.labelContainerView clear];
    self.labelContainerView.frame = [self.multiPhotoVC currentImageFrame];
    FindPhotoHandleModel *photoModel = self.photoLabelList[self.currentIndex];
    for (FindAssemarcFileTagJA *model in photoModel.labelModelList) {
        @weakify(self)
        FindPhotoHandleLabelView *view = [FindPhotoHandleLabelView createWithLabelModel:model longPressBlock:^(FindPhotoHandleLabelView *labelView){
            @strongify(self)
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                [photoModel.labelModelList removeObject:model];
                [labelView removeFromSuperview];
            }];
            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        } clickBlock:nil edit:YES];
        view.center = CGPointMake(self.labelContainerView.width*model.assemarcfiletagwper, self.labelContainerView.height*model.assemarcfiletaghper);
        [self.labelContainerView addSubview:view];
        
        if (!self.tips2View) { //没有提示过，提示一次
            _tips2View = [FindPhotoHandleTips2View showWithSuperView:self.view];
        }
    }
}

#pragma mark - Setter and Getter

- (FindPhotoLabelContainerView *)labelContainerView {
    
    if (!_labelContainerView) {
        _labelContainerView = [[NSBundle mainBundle] loadNibNamed:@"FindPhotoLabelContainerView" owner:self options:nil].firstObject;
    }
    return _labelContainerView;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:[NSString stringWithFormat:@"完成(%td)", self.photoList.count] forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor colorWithRGBHex:0x44444b] forState:UIControlStateNormal];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _doneBtn.layer.cornerRadius = 5;
        _doneBtn.backgroundColor = kTiMainBgColor;
        [_doneBtn addTarget:self action:@selector(didDoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

#pragma mark - YAHMultiPhotoViewControllerDelegate

- (void)didClickMultiPhotoView:(YAHMultiPhotoViewController *)vc currentIndex:(NSInteger)cuurentIndex touchPoint:(CGPoint)touchPoint{
    
    CGRect frame = [self.multiPhotoVC currentImageFrame];
    if (touchPoint.y<0 || touchPoint.y>frame.size.height) { //点击位置不对  不弹出标签选择view
        return;
    }
    
    self.clickTagPoint = CGPointMake(touchPoint.x/frame.size.width, touchPoint.y/frame.size.height);
    WEAKSELF
    self.alertView = [FindPhotoAddLabelAlertView showWithNavigation:self.navigationController doneBlock:^(FindPhotoThingInfo *info, NSArray<FindPhotoLabelInfo *> *labelList, NSArray<FindPhotoStyleInfo *> *styleList) {
        
        FindPhotoHandleModel *photoModel = weakSelf.photoLabelList[weakSelf.currentIndex];
        if (info) {
            FindAssemarcFileTagJA *labelModel = [[FindAssemarcFileTagJA alloc] init];
            labelModel.assemarcfiletagtype = 1;
            labelModel.assemarcfiletagcontent = info.thingname;
            labelModel.assemarcfiletagbrand = info.thingbrand;
            labelModel.assemarcfiletagprice = info.thingprice;
            labelModel.assemarcfiletagwper = self.clickTagPoint.x;
            labelModel.assemarcfiletaghper = self.clickTagPoint.y;
            
            [photoModel.labelModelList addObject:labelModel];
        }
        for (FindPhotoLabelInfo *info in labelList) {
            FindAssemarcFileTagJA *labelModel = [[FindAssemarcFileTagJA alloc] init];
            labelModel.assemarcfiletagtype = 2;
            labelModel.assemarcfiletagcontent = info.labelName;
            labelModel.assemarcfiletagwper = self.clickTagPoint.x;
            labelModel.assemarcfiletaghper = self.clickTagPoint.y;
            
            [photoModel.labelModelList addObject:labelModel];
        }
        for (FindPhotoStyleInfo *info in styleList) {
            FindAssemarcFileTagJA *labelModel = [[FindAssemarcFileTagJA alloc] init];
            labelModel.assemarcfiletagtype = 3;
            labelModel.assemarcfiletagcontent = info.stylename;
            labelModel.assemarcfiletagwper = self.clickTagPoint.x;
            labelModel.assemarcfiletaghper = self.clickTagPoint.y;
            
            [photoModel.labelModelList addObject:labelModel];
        }
        [weakSelf reloadLabelsView];
    }];
    [_tips1View removeFromSuperview];
    
    //判断是否显示空间和风格
    FindPhotoHandleModel *photoModel = weakSelf.photoLabelList[weakSelf.currentIndex];
    BOOL isSpace = NO;
    BOOL isStyle = NO;
    for (FindAssemarcFileTagJA *tagJA in photoModel.labelModelList) {
        if (tagJA.assemarcfiletagtype == 2) {
            isSpace = YES;
        }
        if (tagJA.assemarcfiletagtype == 3) {
            isStyle = YES;
        }
    }
    self.alertView.isSpaceVaild = !isSpace;
    self.alertView.isStyleVaild = !isStyle;
}

- (void)scrollMultiPhotoView:(YAHMultiPhotoViewController *)vc index:(NSInteger)index {
    
    self.currentIndex = index;
    [self reloadLabelsView];
}

- (void)dealloc
{
    if (self.alertView)
    {
        [self.alertView removeFromSuperview];
    }
}

@end

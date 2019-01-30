//
//  FindPhotoPostCheckViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoPostCheckViewController.h"
#import "YAHMultiPhotoViewController.h"

#import "FindPhotoLabelContainerView.h"
#import "FindPhotoHandleLabelView.h"

#import "FindPhotoLabelModel.h"

@interface FindPhotoPostCheckViewController ()<
YAHMultiPhotoViewControllerDelegate>

@property (nonatomic, strong) YAHMultiPhotoViewController *multiVC;
@property (nonatomic, strong) FindPhotoLabelContainerView *labelContainerView;

@property (nonatomic, strong) NSMutableArray<FindPhotoHandleModel *> *photoList;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) void(^deleteBlock)(NSInteger deleteIndex);

@end

@implementation FindPhotoPostCheckViewController

- (instancetype)initWithPhotoList:(NSArray<FindPhotoHandleModel *> *)photoList selectIndex:(NSInteger)selectIndex deleteBlock:(void(^)(NSInteger deleteIndex))deleteBlock {
    
    self = [super init];
    if (self) {
        _photoList = [NSMutableArray arrayWithArray:photoList];
        _deleteBlock = deleteBlock;
        _currentIndex = selectIndex;
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

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self reloadLabelsView];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self reloadLabelsView];
}

#pragma mark - Action

- (void)actionBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionDelete {
    
    if (self.photoList.count==1) { //最后一个退出控制器
        if (_deleteBlock) {
            _deleteBlock(self.currentIndex);
        }
        [self actionBack];
        return;
    }
    
    if (_deleteBlock) {
        _deleteBlock(self.currentIndex);
    }
    [self.photoList removeObjectAtIndex:self.currentIndex];
    [_multiVC removeWithIndex:self.currentIndex];
}

#pragma mark - Private

- (void)setupUI {
    
    [self setupPhotoView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, kDevice_Is_iPhoneX?44:20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"find_back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(0, kDevice_Is_iPhoneX?44:20, 44, 44);
    deleteButton.right = kScreen_Width;
    [deleteButton setImage:[UIImage imageNamed:@"find_photo_post_delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(actionDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
    
    [self.view addSubview:self.labelContainerView];
    [self reloadLabelsView];
}

- (void)setupPhotoView {
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *thumbPhotos = [NSMutableArray arrayWithCapacity:1];
    for (FindPhotoHandleModel *photoModel in _photoList) {
        
        if (photoModel.photoModel.previewPhoto) {
            [photos addObject:[YAHMutiZoomPhoto photoWithImage:photoModel.photoModel.previewPhoto]];
        }else {
            [photos addObject:[YAHMutiZoomPhoto photoWithPhotoAsset:photoModel.photoModel.asset]];
        }
        
        [thumbPhotos addObject:[YAHMutiZoomPhoto photoWithImage:photoModel.photoModel.thumbPhoto]];
    }
    YAHMultiPhotoViewController *vc = [[YAHMultiPhotoViewController alloc] initWithImage:photos thumbImage:photos originFrame:nil selectIndex:_currentIndex];
    vc.autoClickToClose = NO;
    vc.delegate = self;
    [self.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [self addChildViewController:vc];
    
    _multiVC = vc;
}

- (void)reloadLabelsView {
    
    [_labelContainerView clear];
    self.labelContainerView.frame = [self.multiVC currentImageFrame];
    for (FindAssemarcFileTagJA *model in self.photoList[self.currentIndex].labelModelList) {
        FindPhotoHandleLabelView *view = [FindPhotoHandleLabelView createWithLabelModel:model longPressBlock:nil clickBlock:^(FindPhotoHandleLabelView *labelView) {
            //点击标签， 跳转搜索界面
        } edit:NO];
        view.center = CGPointMake(self.labelContainerView.width*model.assemarcfiletagwper, self.labelContainerView.height*model.assemarcfiletaghper);
        [self.labelContainerView addSubview:view];
    }
}

- (FindPhotoLabelContainerView *)labelContainerView {
    
    if (!_labelContainerView) {
        _labelContainerView = [[NSBundle mainBundle] loadNibNamed:@"FindPhotoLabelContainerView" owner:self options:nil].firstObject;
    }
    return _labelContainerView;
}


#pragma mark - YAHMultiPhotoViewControllerDelegate

- (void)scrollMultiPhotoView:(YAHMultiPhotoViewController *)vc index:(NSInteger)index {
    
    self.currentIndex = index;
    [self reloadLabelsView];
}

- (void)didFinishLoadCurrentViewImage {
    
    [self reloadLabelsView];
}

@end

//
//  ColorBigCardViewController.m
//  TiHouse
//
//  Created by weilai on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ColorBigCardViewController.h"
#import "ColorCardFavorViewController.h"
#import "ColorCardCollectionViewCell.h"
#import "ColorBigCellViewController.h"

#import "ColorCardRequest.h"
#import "GBSegmentView.h"

@interface ColorBigCardViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet UIView *favorButtonShadowView;
@property (weak, nonatomic) IBOutlet UIButton *favorItemButton;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView;

@property (strong, nonatomic) ColorModeInfo *colorModeInfo;
@property (strong, nonatomic) NSArray<ColorModeInfo *> *colorList;
@property (nonatomic, assign) NSInteger showIndex;

@property (nonatomic,strong) GBSegmentView *segmentView;

@end

@implementation ColorBigCardViewController

- (instancetype)initWithColorModeInfo:(ColorModeInfo *)colorModeInfo {
    if (self = [super init]) {
        _colorModeInfo = colorModeInfo;
    }
    
    return self;
}

- (instancetype)initWithColorModeInfoList:(NSArray<ColorModeInfo *> *)colorList index:(NSInteger)index {
    
    if (self = [super init]) {
        _colorList = colorList;
        _showIndex = index;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
//    [self.collectionView setContentOffset:CGPointMake(_showIndex*kScreen_Width, 0) animated:NO];
    
//    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_showIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//    [self.collectionView becomeFirstResponder];
    
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_showIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - Action

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionFavor:(id)sender {
    ColorCardFavorViewController *viewController = [ColorCardFavorViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - private

- (void)setupUI {
    
    [self.favorButton.layer setMasksToBounds:YES];
    [self.favorButton.layer setCornerRadius:25.f];
    CALayer *sublayer =[CALayer layer];
    sublayer.backgroundColor = [UIColor colorWithRGBHex:0xFDF086].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius = 5.0;
    sublayer.shadowColor =[UIColor colorWithRGBHex:0xF2DF90].CGColor;
    sublayer.shadowOpacity = 1.0;
    sublayer.frame = CGRectMake(0, 0, kScreen_Width-90, self.favorButtonShadowView.height);
    sublayer.cornerRadius = 25.0;
    [self.favorButtonShadowView.layer addSublayer:sublayer];
    
    [self setupCollectionView];
    [self updateUIData];
    
    [self setupSegmentView];
    [self.segmentView goCurrentController:self.showIndex];
    
}

- (void)setupSegmentView {
    NSInteger yPos = (kScreen_Height - (kScreen_Width-40)*(880.0f/660))/2;
    self.segmentView = [[GBSegmentView alloc]initWithFrame:CGRectMake(0,yPos, kScreen_Width,(kScreen_Width-40)*(880.0f/660))
                                                 topHeight:0.f
                                           colorModeArray:_colorList
                                                    titles:nil];
    WEAKSELF
    self.segmentView.clickBlock = ^(ColorModeInfo * colorModelInfo) {
        [weakSelf actionFavorModel:colorModelInfo];
    };
    [self.view addSubview:self.segmentView];
}

- (void)setupCollectionView {
    
    [self.collectionFlowLayout setItemSize:CGSizeMake(kScreen_Width-20*2,(kScreen_Width-40)*(880.0f/660))];

    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.collectionFlowLayout.minimumLineSpacing = 40;
    
//    //最小行间距
//    self.collectionFlowLayout.minimumLineSpacing = 0;
//    //最小列间距
//    self.collectionFlowLayout.minimumInteritemSpacing = 0;
//    //滚动方向：横向和竖向
//    self.collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"ColorCardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ColorCardCollectionViewCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView.hidden = YES;
}

- (void)updateUIData {
    if (_colorModeInfo.colorcardiscoll) {
        [self.favorItemButton setBackgroundImage:[UIImage imageNamed:@"kcolorfavor.png"] forState:UIControlStateNormal];
    } else {
        [self.favorItemButton setBackgroundImage:[UIImage imageNamed:@"kcolorunfavor.png"] forState:UIControlStateNormal];
    }
    
    [self.colorImageView sd_setImageWithURL:[NSURL URLWithString:_colorModeInfo.colorcardurl] placeholderImage:nil];
}

- (void)actionFavorModel:(ColorModeInfo *)model {
    if (model.colorcardiscoll) {
        WEAKSELF
        [ColorCardRequest removeColorCardFavor:model.colorcardid handler:^(id result, NSError *error) {
            if (error) {
                [NSObject showHudTipStr:self.view tipStr:error.domain];
            } else {
                GBResponseInfo *info = result;
                [NSObject showHudTipStr:self.view tipStr:info.msg];
                
                model.colorcardiscoll = !model.colorcardiscoll;
                [weakSelf.collectionView reloadData];
                [weakSelf.segmentView reloadCurrentData];
            }
        }];
        
    } else {
        WEAKSELF
        [ColorCardRequest addColorCardFavor:model.colorcardid handler:^(id result, NSError *error) {
            if (error) {
                [NSObject showHudTipStr:self.view tipStr:error.domain];
            } else {
                GBResponseInfo *info = result;
                [NSObject showHudTipStr:self.view tipStr:info.msg];
                
                model.colorcardiscoll = !model.colorcardiscoll;
                [weakSelf.collectionView reloadData];
                [weakSelf.segmentView reloadCurrentData];
            }
        }];
    }
}


#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorList.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorCardCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCardCollectionViewCell" forIndexPath:indexPath];
    item.backgroundColor = [UIColor clearColor];
    
    ColorModeInfo *model = self.colorList[indexPath.row];
    [item refreshWithColorModeInfo:model big:YES];
    
    WEAKSELF
    item.clickBlock = ^(ColorModeInfo * colorModelInfo) {
        [weakSelf actionFavorModel:colorModelInfo];
    };
    
    return item;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreen_Width-20*2, (kScreen_Width-40)*(880.0f/660));
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

@end

//
//  CloudRecordCollectVC.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CloudRecordCollectVC.h"
#import "HXPhotoPicker.h"

@interface CloudRecordCollectVC ()
@property (strong, nonatomic) CloudRecordCollectView * cloudRecordCollectView;

@end

@implementation CloudRecordCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleName;
    
    [self addSubviews];
    [self bindViewModel];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)addSubviews {
    [self.view addSubview:self.cloudRecordCollectView];
    
    
    if (@available(iOS 11.0, *)) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)bindViewModel {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints{
    
    [self.cloudRecordCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreen_Width);
    }];
    [super updateViewConstraints];
}

- (HXDatePhotoViewCell *)currentPreviewCell:(HXPhotoModel *)model {
//    if (!model || ![self.allArray containsObject:model]) {
//        return nil;
//    }
//
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self dateItem:model] inSection:model.dateSection];
//    return (HXDatePhotoViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return [self.cloudRecordCollectView currentPreviewCell:model];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - get fun
-(CloudRecordCollectView *)cloudRecordCollectView {
    if (!_cloudRecordCollectView) {
        _cloudRecordCollectView = [CloudRecordCollectView shareInstanceWithViewModel:nil withHouseID:self.houseID withFolderID:self.folderID withType:self.type withMonthStr:self.monthStr];
        _cloudRecordCollectView.viewController = self;
    }
    return _cloudRecordCollectView;
}

@end

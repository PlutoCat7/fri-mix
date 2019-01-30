//
//  GBCourtTracticsView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBCourtLineUpView.h"
#import "XXNibBridge.h"
#import "LineUpPlayerSelectCollectionViewCell.h"
#import "SingleLineUpView.h"

@interface GBCourtLineUpView ()<XXNibBridge,
SingleLineUpViewDelegate>

@property (strong, nonatomic) IBOutletCollection(SingleLineUpView) NSArray *singleTracticsViewList;


@end

@implementation GBCourtLineUpView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    for(SingleLineUpView *view in _singleTracticsViewList) {
        
        view.delegate = self;
    }
}

- (void)setSelectIndexPath:(NSIndexPath *)selectIndexPath {
    
    _selectIndexPath = selectIndexPath;

    for (NSInteger index=0; index<self.singleTracticsViewList.count; index++) {
        SingleLineUpView *view = self.singleTracticsViewList[index];
        view.selectRow = -1;
    }
    if (selectIndexPath) {
        SingleLineUpView *view = self.singleTracticsViewList[selectIndexPath.section];
        view.selectRow = selectIndexPath.row;
    }
}

- (void)setDataList:(NSArray<NSArray<LineUpPlayerModel *> *> *)dataList {
    
    _dataList = dataList;
    [self performBlock:^{
        for (NSInteger index=0; index<dataList.count; index++) {
            SingleLineUpView *view = self.singleTracticsViewList[index];
            view.data = dataList[index];
        }
    } delay:0.3f];
    
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    for(SingleLineUpView *view in _singleTracticsViewList) {
        
        view.isEdit = isEdit;
    }
}

#pragma mark - SingleTracticsViewDelegate

- (void)singleTracticsView:(SingleLineUpView *)singleTracticsView didSelectAtIndex:(NSInteger)index {
    
    NSInteger section = [self.singleTracticsViewList indexOfObject:singleTracticsView];
    if ([self.delegate respondsToSelector:@selector(courtTracticsView:didSelectAtIndexPath:)]) {
        [self.delegate courtTracticsView:self didSelectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:section]];
    }
}

- (void)singleTracticsView:(SingleLineUpView *)singleTracticsView removeAtIndex:(NSInteger)index {
    
    NSInteger section = [self.singleTracticsViewList indexOfObject:singleTracticsView];
    if ([self.delegate respondsToSelector:@selector(courtTracticsView:removeAtIndexPath:)]) {
        [self.delegate courtTracticsView:self removeAtIndexPath:[NSIndexPath indexPathForRow:index inSection:section]];
    }
}
@end

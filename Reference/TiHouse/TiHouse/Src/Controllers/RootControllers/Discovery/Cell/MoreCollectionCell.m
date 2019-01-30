//
//  MoreCollectionCell.m
//  TiHouse
//
//  Created by Teen Ma on 2017/12/9.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "MoreCollectionCell.h"
#import "MoreCollectionViewModel.h"

#import "CollectionDetailView.h"
#import "CollectionDetailViewModel.h"

#define kDetailViewWidth 200
#define kDetailViewHeight 100
#define kSpace 10

@interface MoreCollectionCell () <UIScrollViewDelegate,CollectionDetailViewDelegate>

@property (nonatomic,strong) MoreCollectionViewModel *viewModel;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation MoreCollectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupUIInterface];
    }
    return self;
}

- (void)setupUIInterface
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.scrollView];
}

- (void)resetCellWithViewModel:(MoreCollectionViewModel *)viewModel
{
    [super resetCellWithViewModel:viewModel];
    
    if (viewModel != self.viewModel)
    {
        if (viewModel.collections && viewModel.collections.count > 0)
        {
            self.viewModel = viewModel;
            for (UIView *view in self.scrollView.subviews)
            {
                [view removeFromSuperview];
            }
            
            float xSpace = kSpace;
            for (int i = 0 ; i < viewModel.collections.count; i++)
            {
                CollectionDetailViewModel *detailViewModel = viewModel.collections[i];
                CollectionDetailView *detailView = [[CollectionDetailView alloc] initWithFrame:CGRectMake(xSpace, 0, kDetailViewWidth, kDetailViewHeight)];
                detailView.delegate = self;
                [detailView resetViewWithViewModel:detailViewModel];
                [self.scrollView addSubview:detailView];
                xSpace += detailView.frame.size.width;
                xSpace += kSpace;
            }
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            if (self.scrollView.frame.size.width < xSpace)
            {
                [self.scrollView setContentSize:CGSizeMake(xSpace, self.scrollView.frame.size.height)];
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, kDetailViewHeight);
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

#pragma mark CarTypeChoosedDetailViewDelegate
- (void)collectionDetailView:(CollectionDetailView *)view clickLargeImageWithViewModel:(CollectionDetailViewModel *)viewModel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreCollectionCell:clickCollectionViewWithViewModel:)])
    {
        [self.delegate moreCollectionCell:self clickCollectionViewWithViewModel:viewModel];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


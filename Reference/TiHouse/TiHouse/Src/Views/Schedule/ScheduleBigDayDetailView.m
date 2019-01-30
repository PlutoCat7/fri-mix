//
//  ScheduleBigDayDetailView.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleBigDayDetailView.h"

#import "BaseViewModel.h"
#import "BaseTableViewCell.h"
#import "BaseCellLineViewModel.h"

#import "AdverHeadView.h"
#import "AdverHeadViewModel.h"
 
#import "TwoOptionTitleView.h"
#import "TwoOptionTitleViewModel.h"

#import "ScheduleDetailViewModel.h"
#import "ScheduleDetailCell.h"

#import "ScheduleBigDayDetailViewModel.h"

#import "ScheduleOneButtonView.h"
#import "ScheduleOneButtonViewModel.h"

#import "ScheduleModel.h"

#define kLeftSpace 45
#define kMaxHeight [[UIScreen mainScreen] bounds].size.height - 120 * 2

#define kBottomButtonHeight kRKBHEIGHT(74)

@interface ScheduleBigDayDetailView () <UITableViewDelegate,UITableViewDataSource,ScheduleOneButtonViewDelegate,AdverHeadViewDelegate>

@property (nonatomic, strong  ) UITableView *table;
@property (nonatomic, strong  ) NSMutableArray *viewModels;

@property (nonatomic, strong  ) ScheduleBigDayDetailViewModel *mainViewModel;//主ViewModel

@property (nonatomic, strong  ) UIView             *optionView;//主View

@property (nonatomic, strong  ) TwoOptionTitleView *twoOptionTitleView;
@property (nonatomic, strong  ) TwoOptionTitleViewModel *twoOptionTitleViewModel;

@property (nonatomic, strong  ) AdverHeadView *adverHeadView;
@property (nonatomic, strong  ) AdverHeadViewModel *adverHeadViewModel;

@property (nonatomic, strong  ) ScheduleOneButtonView *oneButtonView;
@property (nonatomic, strong  ) ScheduleOneButtonViewModel *oneButtonViewModel;

@end

@implementation ScheduleBigDayDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUIInterface];
    }
    return self;
}

- (void)resetViewWithViewModel:(ScheduleBigDayDetailViewModel *)viewModel
{
    self.mainViewModel = viewModel;
    
    self.optionView.frame = CGRectMake(0, 0, self.frame.size.width - kLeftSpace * 2, 0);
    
    float ySpace = 0;
    self.adverHeadView.frame = CGRectZero;
    if (viewModel.topImageUrl.length > 0)
    {
        self.adverHeadViewModel.placeHolder = [UIImage imageNamed:@"placeHolder"];
        self.adverHeadViewModel.adv_imageUrl = viewModel.topImageUrl;
        self.adverHeadViewModel.topRightTitle = @"广告";
        self.adverHeadView.frame = CGRectMake(0, ySpace, self.optionView.frame.size.width, kRKBHEIGHT(100));
        
        [self.adverHeadView resetViewWithViewModel:self.adverHeadViewModel];
        ySpace += self.adverHeadView.frame.size.height;
    }
    
    self.twoOptionTitleViewModel.leftTitle = viewModel.centerLeftTItle;
    self.twoOptionTitleViewModel.centerTitle = @"·";
    self.twoOptionTitleViewModel.rightTitle = viewModel.centerRightTitle;
    self.twoOptionTitleView.frame = CGRectMake(0, ySpace, self.optionView.frame.size.width, kRKBHEIGHT(50));
    
    [self.twoOptionTitleView resetViewWithViewModel:self.twoOptionTitleViewModel];
    ySpace += self.twoOptionTitleView.frame.size.height;
    
    self.table.frame = CGRectMake(0, ySpace, self.optionView.frame.size.width, 0);
    
    [self.viewModels removeAllObjects];
    [self.viewModels addObjectsFromArray:viewModel.options];
    [self.table reloadData];
    
    self.table.frame = CGRectMake(0, ySpace, self.optionView.frame.size.width, self.table.contentSize.height);
    if (self.table.contentSize.height > kMaxHeight - ySpace - kBottomButtonHeight)
    {
        self.table.frame = CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y, self.table.frame.size.width, kMaxHeight - ySpace - kBottomButtonHeight);
    }
    ySpace += self.table.frame.size.height;
    
    [self.oneButtonView resetViewWithViewModel:self.oneButtonViewModel];
    self.oneButtonView.frame = CGRectMake(0, ySpace, self.optionView.frame.size.width, kBottomButtonHeight);
    ySpace += self.oneButtonView.frame.size.height;
    
    self.optionView.frame = CGRectMake(0, 0, self.frame.size.width - kLeftSpace * 2, ySpace);
    self.optionView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)setupUIInterface
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.table.separatorColor = [UIColor clearColor];
    self.table.separatorInset = UIEdgeInsetsZero;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.backgroundView = [[UIView alloc]init];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.showsVerticalScrollIndicator = NO;
    self.table.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *))
    {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.table.estimatedRowHeight = 0;
    self.table.estimatedSectionFooterHeight = 0;
    self.table.estimatedSectionHeaderHeight = 0;
    
    [self.optionView addSubview:self.table];
    [self.optionView addSubview:self.adverHeadView];
    [self.optionView addSubview:self.twoOptionTitleView];
    [self.optionView addSubview:self.oneButtonView];
    
    [self addSubview:self.optionView];
    
    [self.table registerClass:[ScheduleDetailCell class] forCellReuseIdentifier:NSStringFromClass([ScheduleDetailCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewModel *viewModel = self.viewModels[indexPath.row];
    BaseTableViewCell *cell  = [self.table dequeueReusableCellWithIdentifier:viewModel.cellIndentifier];
    cell.delegate = self;
    [cell resetCellWithViewModel:viewModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewModel *viewModel    = self.viewModels[indexPath.row];
    if (viewModel.currentCellHeight == 0)
    {
        viewModel.currentCellHeight = [viewModel.cellClass currentCellHeightWithViewModel:viewModel];
    }
    return viewModel.currentCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleDetailViewModel *viewModel    = self.viewModels[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleBigDayDetailView:clickScheduleCellWithViewModel:)])
    {
        [self.delegate scheduleBigDayDetailView:self clickScheduleCellWithViewModel:viewModel];
    }
}

/**
 *  只要实现了这个方法，左滑出现按钮的功能就有了
 (一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __block ScheduleDetailViewModel *viewModel = self.viewModels[indexPath.row];
    if (viewModel.canSwipe)
    {
        ScheduleModel *dataModel = viewModel.dataModel;
        if (dataModel.scheduletype == 0)
        {
            UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"已完成" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                if (dataModel.scheduletype == 1) {
                    return ;
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleBigDayDetailView:swipeToFinishedWithViewModel:)])
                {
                    [self.delegate scheduleBigDayDetailView:self swipeToFinishedWithViewModel:viewModel];
                }
//                if(_actionblock){
//                    _actionblock(weakSelf,DoneAction,indexPath,weakSelf.data[indexPath.row]);
//                }
                // 收回左滑出现的按钮(退出编辑模式)
                tableView.editing = NO;
            }];
            
            action0.backgroundColor = kdayTypeExeBGColor;
            
            UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleBigDayDetailView:swipeToDeleteWithViewModel:)])
                {
                    [self.delegate scheduleBigDayDetailView:self swipeToDeleteWithViewModel:viewModel];
                }
//                if(_actionblock){
//                    _actionblock(weakSelf,DeleteAction,indexPath,weakSelf.data[indexPath.row]);
//                }
                // 收回左滑出现的按钮(退出编辑模式)
                tableView.editing = NO;
            }];
            
            return @[action1, action0];
        }
        
        
        UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleBigDayDetailView:swipeToDeleteWithViewModel:)])
            {
                [self.delegate scheduleBigDayDetailView:self swipeToDeleteWithViewModel:viewModel];
            }
//            if(_actionblock){
//                _actionblock(weakSelf,DeleteAction,indexPath,weakSelf.data[indexPath.row]);
//            }
            // 收回左滑出现的按钮(退出编辑模式)
            tableView.editing = NO;
        }];
        
        return @[action1];
    }
    return @[];
}

#pragma mark LazyInit
- (NSMutableArray *)viewModels
{
    if (!_viewModels)
    {
        _viewModels = [[NSMutableArray alloc] init];
    }
    return _viewModels;
}

- (AdverHeadView *)adverHeadView
{
    if (!_adverHeadView)
    {
        _adverHeadView = [[AdverHeadView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - kLeftSpace * 2, kRKBHEIGHT(100))];
        _adverHeadView.delegate = self;
    }
    return _adverHeadView;
}

- (AdverHeadViewModel *)adverHeadViewModel
{
    if (!_adverHeadViewModel)
    {
        _adverHeadViewModel = [[AdverHeadViewModel alloc] init];
    }
    return _adverHeadViewModel;
}

- (TwoOptionTitleView *)twoOptionTitleView
{
    if (!_twoOptionTitleView)
    {
        _twoOptionTitleView = [[TwoOptionTitleView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - kLeftSpace * 2, kRKBHEIGHT(50))];
    }
    return _twoOptionTitleView;
}

- (TwoOptionTitleViewModel *)twoOptionTitleViewModel
{
    if (!_twoOptionTitleViewModel)
    {
        _twoOptionTitleViewModel = [[TwoOptionTitleViewModel alloc] init];
    }
    return _twoOptionTitleViewModel;
}

- (ScheduleOneButtonView *)oneButtonView
{
    if (!_oneButtonView)
    {
        _oneButtonView = [[ScheduleOneButtonView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - kLeftSpace * 2, 0)];
        _oneButtonView.delegate = self;
    }
    return _oneButtonView;
}

- (ScheduleOneButtonViewModel *)oneButtonViewModel
{
    if (!_oneButtonViewModel)
    {
        _oneButtonViewModel = [[ScheduleOneButtonViewModel alloc] init];
        _oneButtonViewModel.oneButtonTitle = @"添加";
    }
    return _oneButtonViewModel;
}

- (UIView *)optionView
{
    if (!_optionView)
    {
        _optionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - kLeftSpace * 2, 0)];
    }
    return _optionView;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *t = [touches anyObject];
    if (self == t.view){
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

- (void)scheduleOneButtonView:(ScheduleOneButtonView *)view clickButtonWithViewModel:(ScheduleOneButtonViewModel *)viewModel;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleBigDayDetailView:clickBottomButtonWithViewModel:)])
    {
        [self.delegate scheduleBigDayDetailView:self clickBottomButtonWithViewModel:self.mainViewModel];
    }
}

- (void)adverHeadView:(AdverHeadView *)view clickLargeImageWithViewModel:(AdverHeadViewModel *)viewModel;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleBigDayDetailView:clickTopViewWithViewModel:)])
    {
        [self.delegate scheduleBigDayDetailView:self clickTopViewWithViewModel:self.mainViewModel];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

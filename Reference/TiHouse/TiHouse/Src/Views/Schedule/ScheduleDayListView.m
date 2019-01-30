//
//  ScheduleDayListView.m
//  TiHouse
//
//  Created by Mstic on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleDayListView.h"
#import "ScheduleDayCell.h"
#import "ScheduleDayListViewModel.h"
#import "NSDate+Extend.h"
#import "EventPopAlertView.h"

#import "ScheduleBigDayDetailView.h"
#import "ScheduleBigDayDetailViewModel.h"

#import "ScheduleDetailViewModel.h"
#import "ScheduleDetailCell.h"
#import "BaseCellLineViewModel.h"


@interface ScheduleDayListView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ScheduleBigDayDetailViewDelegate>

@property (nonatomic, strong) UIButton *btnLastMonth;
@property (nonatomic, strong) UIButton *btnNextMonth;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *weekView;
@property (nonatomic, strong) UIView *btnBgView;

@property (nonatomic, strong) ScheduleDayListViewModel *viewModel;

@property (nonatomic, strong  ) ScheduleBigDayDetailView *scheduleBigDayDetailView;
@property (nonatomic, strong  ) ScheduleBigDayDetailViewModel *scheduleBigDayDetailViewModel;

@end


@implementation ScheduleDayListView

- (instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    _viewModel = viewModel;
    self.lblDate.text = _viewModel.scheduleDay.date;
    return [super initWithViewModel:viewModel];
}

- (void)xl_bindViewModel{
    @weakify(self);
    [self.viewModel.successSubject subscribeNext:^(id x) {
        @strongify(self);
        
        //处理广告 + 日程数据
        for (ScheduleDayListModel *oneDayListModel in self.viewModel.scheduleDay.list)
        {
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (ScheduleadvertListDataModel *adverModel in oneDayListModel.scheduleadvertList)
            {
                ScheduleModel *scheduModel = [[ScheduleModel alloc] init];//模拟成日程
                scheduModel.schedulename = adverModel.scheadvertname;
                scheduModel.schedulestarttime = adverModel.advertstarttime;
                scheduModel.scheduleendtime = adverModel.advertendtime;
                scheduModel.scheduleremark = adverModel.scheadvertdesc;
                scheduModel.schedulecolor = adverModel.scheadvertcolor;
                scheduModel.type = SCHEDULEMODELTYPE_ADVER;
                scheduModel.allurllink = adverModel.allurllink;
                scheduModel.scheadvertid = adverModel.scheadvertid;
                scheduModel.adverttype = adverModel.adverttype;
                [tmpArray addObject:scheduModel];
            }
            
            for (ScheduleModel *schedModel in oneDayListModel.scheduleList)
            {
                [tmpArray addObject:schedModel];
            }
            
            oneDayListModel.scheduleList = tmpArray;
        }
        
        [self.collectionView reloadData];
    }];
    
    [RACObserve(self.viewModel, loadDate) subscribeNext:^(id x) {
        NSString *str = x;
        NSDate *date =  [NSDate dateWithString:str format:@"yyyy-MM"];

        self.lblDate.text = IF_NULL_TO_STRINGSTR([NSDate stringWithDate:date format:@"yyyy年MM月"], @"");
    }];
}


- (void)xl_setupViews{
    [self addSubview:self.btnBgView];
    [self addSubview:self.lblDate];
    [self addSubview:self.btnLastMonth];
    [self addSubview:self.btnNextMonth];
    [self addSubview:self.weekView];
    [self addSubview:self.collectionView];
    [self configCollectionView];
    
    [self updateConstraints];
    [self updateConstraintsIfNeeded];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.scheduleBigDayDetailView];
    
}

- (void)configCollectionView{
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ScheduleDayCell class]) bundle:nil];
    
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([ScheduleDayCell class])];
}

- (void)updateConstraints{
    
    WS(weakSelf);
    [self.btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    [self.lblDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.btnLastMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [self.btnNextMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [self.weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lblDate.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.weekView.mas_bottom).offset(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [super updateConstraints];
}
- (UIView *)btnBgView{
    if (!_btnBgView) {
        _btnBgView = [[UIView alloc] init];
        _btnBgView.backgroundColor = [UIColor whiteColor];
        // 阴影的颜色
        _btnBgView.layer.shadowColor = RGB(0, 0, 0).CGColor;
        // 阴影的透明度
        _btnBgView.layer.shadowOpacity = 0.03f;
        // 阴影偏移量
        _btnBgView.layer.shadowOffset = CGSizeMake(0,5);
    }
    return _btnBgView;
}

- (UILabel *)lblDate{
    if (!_lblDate) {
        _lblDate = [[UILabel alloc]init];
        _lblDate.font = ZISIZE(12);
        _lblDate.textColor = RGB(191, 191, 191);
        _lblDate.textAlignment = NSTextAlignmentCenter;
    }
    return _lblDate;
}

- (UIButton *)btnLastMonth{
    if (!_btnLastMonth) {
        _btnLastMonth = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLastMonth setImage:IMAGE_ANME(@"s_left") forState:UIControlStateNormal];
        [_btnLastMonth addTarget:self action:@selector(lastMonthClick) forControlEvents:UIControlEventTouchUpInside];
        _btnLastMonth.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _btnLastMonth;
}

- (UIButton *)btnNextMonth{
    if (!_btnNextMonth) {
        _btnNextMonth = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnNextMonth setImage:IMAGE_ANME(@"s_right") forState:UIControlStateNormal];
        [_btnNextMonth addTarget:self action:@selector(nextMonthClick) forControlEvents:UIControlEventTouchUpInside];
        _btnNextMonth.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _btnNextMonth;
}

- (UIView *)weekView{
    if (!_weekView) {
        _weekView = [[UIView alloc] init];
//        _weekView.backgroundColor = [UIColor greenColor];
        [self addWeekLabel];
    }
    return _weekView;
}

- (void)addWeekLabel{
    
    NSArray *arr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat w = kScreen_Width/7;
    
    for (int i = 0; i< arr.count; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(i*w, 0, w, 30)];
        lbl.font = ZISIZE(12);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = arr[i];
        if (i == 0 || i == arr.count-1) {
            lbl.textColor = RGB(241, 56, 56);
        } else{
            lbl.textColor = RGB(0, 0, 0);
        }
        [_weekView addSubview:lbl];
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 65, kScreen_Width, kScreen_Height - kNavigationBarHeight - 65) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSwipe];
    }
    return _collectionView;
}

/**
 添加手势
 */
- (void)addSwipe{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [_collectionView addGestureRecognizer:swipeLeft];
    [_collectionView addGestureRecognizer:swipeRight];
}

#pragma mark - 手势事件
- (void)swipeAction:(UISwipeGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
//            [self scrollCalendarNext:YES];
            //下一月
            [self nextMonthClick];
            
        } else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
//            [self scrollCalendarNext:NO];
            //上一月
            [self lastMonthClick];
        } else {
            return;
        }
    }
}

#pragma mark - 代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger week = [[NSDate dateWithString:JString(@"%@-01",self.viewModel.loadDate) format:@"yyyy-MM-dd"] weekday];
    
    NSInteger rows = self.viewModel.scheduleDay.list.count+week-1 ;
    rows = rows % 7 == 0 ? rows : (rows +(7-rows%7));
    
    return rows;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ScheduleDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ScheduleDayCell class]) forIndexPath:indexPath];
    
    NSUInteger days = [self.viewModel.lastMonthDate getDays];
    NSInteger week = [[NSDate dateWithString:JString(@"%@-01",self.viewModel.loadDate) format:@"yyyy-MM-dd"] weekday];
    
    
    cell.isWeekDay = indexPath.item % 7 == 0 || indexPath.item %7 == 6;
    if (indexPath.item < week - 1 ) {//前一个月
        cell.dayListModel = nil;
        cell.isNoCurrentMonthDay = YES;
        cell.dayNum = (int)(days - week + 2 +indexPath.row);
        
    } else if (indexPath.row >= self.viewModel.scheduleDay.list.count+week-1){//后一个月
        cell.dayListModel = nil;
        cell.isNoCurrentMonthDay = YES;
        cell.dayNum = (int)(indexPath.row - self.viewModel.scheduleDay.list.count - week +2);
        
    } else {//当前月
        cell.scheduleDay = self.viewModel.scheduleDay;
        ScheduleDayListModel *model = self.viewModel.scheduleDay.list[indexPath.item-week+1];
        cell.isNoCurrentMonthDay = NO;
        cell.isWeekDay = indexPath.item % 7 == 0 || indexPath.item %7 == 6;
        cell.dayListModel = model;
        
        
    }
    
    if (indexPath.row >= self.viewModel.scheduleDay.list.count+week-1) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def removeObjectForKey:kLastUseArrayKey];
        //存入数组并同步
        [def synchronize];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreen_Width/7, 136);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger week = [[NSDate dateWithString:JString(@"%@-01",self.viewModel.loadDate) format:@"yyyy-MM-dd"] weekday];
    
    ScheduleDayListModel *model = self.viewModel.scheduleDay.list[indexPath.item-week+1];
    
    
    
    [self showEventScheduleDayList:model];
}

-(void)showEventScheduleDayList:(ScheduleDayListModel *)model {
    
    __block NSString *strDate = JString(@"%@-%ld",self.viewModel.loadDate,model.day);
    NSDate *date = [NSDate dateWithString:strDate format:@"yyyy-MM-dd"];
    
    strDate = [NSDate stringWithDate:date format:@"MM月dd日"];
    
    if (model.scheduleList.count<1) {
        //添加
        [self.viewModel.addSchedule sendNext:date];
        return;
    }
    
    
    NSString *strWeek = [date dayFromWeekday];
    
    self.scheduleBigDayDetailViewModel.dataModel = model;
    self.scheduleBigDayDetailViewModel.topImageUrl = @"";
    if (model.scheduleadvertList.count > 0)
    {
        self.scheduleBigDayDetailViewModel.topImageUrl = model.scheduleadvertList[0].urlpicindex;
    }
    self.scheduleBigDayDetailViewModel.centerLeftTItle = strDate;
    self.scheduleBigDayDetailViewModel.centerRightTitle = strWeek;
    
    if (model.scheduleList.count > 0)
    {
        self.scheduleBigDayDetailViewModel.options = [NSMutableArray array];
        for (ScheduleModel *tmpModel in model.scheduleList)
        {
            ScheduleDetailViewModel *viewModel = [[ScheduleDetailViewModel alloc] init];
            viewModel.leftIconBackgroundColor = [UIColor colorWithHexString:JString(@"0x%@",tmpModel.schedulecolor)];
            viewModel.leftIconTitle = tmpModel.type == SCHEDULEMODELTYPE_SCHEDULE ? @"": @"广告";
            viewModel.optionText = tmpModel.type == SCHEDULEMODELTYPE_SCHEDULE ? [NSString stringWithFormat:@"%@",tmpModel.schedulename]: [NSString stringWithFormat:@"%@ | %@",tmpModel.schedulename,tmpModel.scheduleremark];
            viewModel.dataModel = tmpModel;
            viewModel.cellClass = [ScheduleDetailCell class];
            viewModel.currentCellHeight = 50;
            viewModel.canSwipe = tmpModel.type == SCHEDULEMODELTYPE_SCHEDULE;
            viewModel.cellLineViewModel.bottomLineEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 13);
            [self.scheduleBigDayDetailViewModel.options addObject:viewModel];
        }
    }

    [self.scheduleBigDayDetailView resetViewWithViewModel:self.scheduleBigDayDetailViewModel];

    [UIView animateWithDuration:0.3 animations:^{
        self.scheduleBigDayDetailView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.scheduleBigDayDetailView.hidden = NO;
    }];
}

#pragma mark- 事件

- (void)lastMonthClick{

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:kLastUseArrayKey];
    //存入数组并同步
    [def synchronize];
    
    self.viewModel.loadDate = [NSDate stringWithDate:self.viewModel.lastMonthDate  format:@"yyyy-MM"];
    [self.viewModel requestScheduleList];
}

- (void)nextMonthClick{
    
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def removeObjectForKey:kLastUseArrayKey];
//    //存入数组并同步
//    [def synchronize];
    self.viewModel.loadDate = [NSDate stringWithDate:self.viewModel.nextMonthDate  format:@"yyyy-MM"];
    [self.viewModel requestScheduleList];
}

- (ScheduleBigDayDetailView *)scheduleBigDayDetailView
{
    if (!_scheduleBigDayDetailView)
    {
        _scheduleBigDayDetailView = [[ScheduleBigDayDetailView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        _scheduleBigDayDetailView.hidden = YES;
        _scheduleBigDayDetailView.delegate = self;
    }
    return _scheduleBigDayDetailView;
}

- (ScheduleBigDayDetailViewModel *)scheduleBigDayDetailViewModel
{
    if (!_scheduleBigDayDetailViewModel)
    {
        _scheduleBigDayDetailViewModel = [[ScheduleBigDayDetailViewModel alloc] init];
    }
    return _scheduleBigDayDetailViewModel;
}

#pragma mark ScheduleBigDayDetailViewDelegate
- (void)scheduleBigDayDetailView:(ScheduleBigDayDetailView *)view clickTopViewWithViewModel:(ScheduleBigDayDetailViewModel *)viewModel;
{
    [self dismissScheduleBigDayDetailView];
    ScheduleDayListModel *dataModel = viewModel.dataModel;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleDayListView:clickSheduleWithViewModel:)])
    {
        [self.delegate scheduleDayListView:self clickSheduleWithViewModel:dataModel];
    }
}

- (void)scheduleBigDayDetailView:(ScheduleBigDayDetailView *)view clickScheduleCellWithViewModel:(ScheduleDetailViewModel *)viewModel;
{
    [self dismissScheduleBigDayDetailView];
    ScheduleModel *dataModel = viewModel.dataModel;
    if (dataModel)
    {
        SCHEDULEMODELTYPE type = dataModel.type;
        if (type == SCHEDULEMODELTYPE_ADVER)
        {
            //跳H5
            if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleDayListView:clickSheduleWithViewModel:)])
            {
                [self.delegate scheduleDayListView:self clickSheduleWithViewModel:dataModel];
            }
        }
        else
        {
            dataModel = viewModel.dataModel;
            //日程详情
            [self.viewModel.cellClickSubject sendNext:dataModel];
        }
    }
}

- (void)scheduleBigDayDetailView:(ScheduleBigDayDetailView *)view clickBottomButtonWithViewModel:(ScheduleBigDayDetailViewModel *)viewModel;
{
    ScheduleDayListModel *dataModel = viewModel.dataModel;
    if (dataModel)
    {
        [self dismissScheduleBigDayDetailView];
        __block NSString *strDate = JString(@"%@-%ld",self.viewModel.loadDate,dataModel.day);
        NSDate *date = [NSDate dateWithString:strDate format:@"yyyy-MM-dd"];
        [self.viewModel.addSchedule sendNext:date];
    }
}

- (void)scheduleBigDayDetailView:(ScheduleBigDayDetailView *)view swipeToFinishedWithViewModel:(ScheduleDetailViewModel *)viewModel;
{
    ScheduleModel *m =  viewModel.dataModel;
    self.viewModel.deleteScheduleId = m.scheduleid;
    [self.viewModel requestFinishSchedule:^(BOOL status) {
        if (status) {
            [self dismissScheduleBigDayDetailView];
            [self.viewModel requestScheduleList];
        }
    }];
}

- (void)scheduleBigDayDetailView:(ScheduleBigDayDetailView *)view swipeToDeleteWithViewModel:(ScheduleDetailViewModel *)viewModel;
{
    ScheduleModel *m =  viewModel.dataModel;
    self.viewModel.deleteScheduleId = m.scheduleid;
    [self.viewModel requestDeleteSchedule:^(BOOL status) {
        if (status) {
            [self dismissScheduleBigDayDetailView];
            [self.viewModel requestScheduleList];
        }
    }];
}

- (void)dismissScheduleBigDayDetailView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.scheduleBigDayDetailView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.scheduleBigDayDetailView.hidden = YES;
    }];
}


- (void)dealloc
{
    if (self.scheduleBigDayDetailView)
    {
        [self.scheduleBigDayDetailView removeFromSuperview];
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


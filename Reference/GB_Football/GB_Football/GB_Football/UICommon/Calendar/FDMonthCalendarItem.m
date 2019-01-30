//
//  FDMonthCalendarItem.m
//  GB_Football
//
//  Created by gxd on 17/6/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "FDMonthCalendarItem.h"
#import "FDCalendarConfig.h"

@interface FDMonthCalendarCell : UICollectionViewCell

- (UILabel *)monthLabel;

@end

@implementation FDMonthCalendarCell {
    UILabel *_monthLabel;
}

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font = [UIFont systemFontOfSize:15];
        _monthLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        [self addSubview:_monthLabel];
    }
    return _monthLabel;
}

@end

#define CollectionViewHorizonMargin 5
#define CollectionViewVerticalMargin 5

typedef NS_ENUM(NSUInteger, FDCalendarMonth) {
    FDCalendarMonthPrevious = 0,
    FDCalendarMonthCurrent = 1,
    FDCalendarMonthNext = 2,
};

@interface FDMonthCalendarItem () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *monthArray;

@end

@implementation FDMonthCalendarItem

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupCollectionView];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, self.collectionView.frame.size.height + CollectionViewVerticalMargin * 2)];
        
        _monthArray = @[LS(@"calendar.label.jan"), LS(@"calendar.label.feb"), LS(@"calendar.label.mar"), LS(@"calendar.label.apr"), LS(@"calendar.label.may"), LS(@"calendar.label.jun"), LS(@"calendar.label.jul"), LS(@"calendar.label.aug"), LS(@"calendar.label.sep"), LS(@"calendar.label.oct"), LS(@"calendar.label.nov"), LS(@"calendar.label.dec")];
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setYear:(NSInteger)year {
    _year = year;
    [self.collectionView reloadData];
}

- (void)setCurYear:(NSInteger)curYear {
    _curYear = curYear;
    [self.collectionView reloadData];
}

- (void)setCurMonth:(NSInteger)curMonth {
    _curMonth = curMonth;
    [self.collectionView reloadData];
}

#pragma mark - Public

// 获取date的下个月日期
- (NSInteger)nextYear {
    return self.year + 1;
}

// 获取date的上个月日期
- (NSInteger)previousYear {
    return self.year - 1;
}

#pragma mark - Private

// collectionView显示日期单元，设置其属性
- (void)setupCollectionView {
    CGFloat itemWidth = (DeviceWidth - CollectionViewHorizonMargin * 2) / 4;
    CGFloat itemHeight = [FDCalendarConfig calendarMonthCellHeight];
    
    UICollectionViewFlowLayout *flowLayot = [[UICollectionViewFlowLayout alloc] init];
    flowLayot.sectionInset = UIEdgeInsetsZero;
    flowLayot.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayot.minimumLineSpacing = 0;
    flowLayot.minimumInteritemSpacing = 0;
    
    CGRect collectionViewFrame = CGRectMake(CollectionViewHorizonMargin, CollectionViewVerticalMargin, DeviceWidth - CollectionViewHorizonMargin * 2, itemHeight * 4);
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayot];
    [self addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[FDMonthCalendarCell class] forCellWithReuseIdentifier:@"FDMonthCalendarCell"];
}

#pragma mark - UICollectionDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"FDMonthCalendarCell";
    FDMonthCalendarCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.monthLabel.backgroundColor = [UIColor clearColor];
    cell.monthLabel.textColor = [UIColor whiteColor];
    cell.monthLabel.text = self.monthArray[indexPath.row];
    
    if (self.year == self.curYear && indexPath.row + 1 == self.curMonth) {
        cell.monthLabel.backgroundColor = [FDCalendarConfig selectBackgroundColor];
        cell.monthLabel.textColor = [FDCalendarConfig heightLightColor];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarItem:selectedYear:selectedMonth:)]) {
        [self.delegate calendarItem:self selectedYear:self.year selectedMonth:indexPath.row + 1];
    }
}

@end

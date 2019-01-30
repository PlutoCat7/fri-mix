//
//  GBGameCompleteViewController.m
//  GB_Team
//
//  Created by weilai on 16/9/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBGameCompleteViewController.h"

#import "GBGameScorePicker.h"
#import "GBGameTimePicker.h"
#import "GBGameDatePicker.h"
#import "GBAlertView.h"
#import "GBGameCompletePreview.h"

#import "MatchRequest.h"

typedef enum {
    TimeType_FirstHalf = 0,
    TimeType_SecondHalf = 1
}TimeType;

@interface GBGameCompleteViewController () <
GBGameScorePickerDelegate,
GBGameTimePickerDelegate,
GBGameDateDelegate>

@property (weak, nonatomic) IBOutlet UILabel *gameDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nomalFirstHalfBeginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nomalFirstHalfEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nomalSecondHalfBeginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nomalSecondHalfEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ourSideScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppSideScoreLabel;

@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;

// 比分选择器
@property (strong, nonatomic) GBGameScorePicker  *scorePicker;
@property (strong, nonatomic) GBGameTimePicker *timePicker;
@property (strong, nonatomic) GBGameDatePicker *datePicker;

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) NSInteger matchTime;
@property (nonatomic, assign) NSInteger currentSelectIndex;

@end

@implementation GBGameCompleteViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

- (instancetype)initWithMatchId:(NSInteger)matchId matchTime:(NSInteger)matchTime {
    
    if(self=[super init]){
        _matchId = matchId;
        _matchTime = matchTime;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Delegate
#pragma mark GBGameScorePickerDelegate

- (void)GBGameScorePicker:(GBGameScorePicker*)picker our:(NSInteger)our opp:(NSInteger)opp {
    
    self.ourSideScoreLabel.text = @(our).stringValue;
    self.oppSideScoreLabel.text = @(opp).stringValue;
}

#pragma mark GBGameTimePickerDelegate

- (void)GBGameTimePicker:(GBGameTimePicker*)picker startHour:(NSInteger)startHour startMin:(NSInteger)startMin endHour:(NSInteger)endHour endMin:(NSInteger)endMin {
    
    if (self.currentSelectIndex == TimeType_FirstHalf) {
        NSString *startTime = [NSString stringWithFormat:@"%02td:%02td", startHour, startMin];
        NSString *endTime = [NSString stringWithFormat:@"%02td:%02td", endHour, endMin];
        
        self.nomalFirstHalfBeginTimeLabel.text = startTime;
        self.nomalFirstHalfEndTimeLabel.text = endTime;
        
        NSDate *firstEndDate = [self dateWithTime:self.nomalFirstHalfEndTimeLabel.text];
        NSDate *secondStartDate = [firstEndDate dateByAddingMinutes:15];
        NSDate *secondEndDate = [secondStartDate dateByAddingMinutes:45];
        NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
        [dateToStrFormatter setDateFormat:@"HH:mm"];
        self.nomalSecondHalfBeginTimeLabel.text = [dateToStrFormatter stringFromDate:secondStartDate];
        self.nomalSecondHalfEndTimeLabel.text = [dateToStrFormatter stringFromDate:secondEndDate];
        
    } else if (self.currentSelectIndex == TimeType_SecondHalf) {
        NSString *startTime = [NSString stringWithFormat:@"%02td:%02td", startHour, startMin];
        NSString *endTime = [NSString stringWithFormat:@"%02td:%02td", endHour, endMin];
        
        self.nomalSecondHalfBeginTimeLabel.text = startTime;
        self.nomalSecondHalfEndTimeLabel.text = endTime;
    }
    
}

#pragma mark GBGameDateDelegate

- (void)didSelectDateWithDate:(NSDate *)date year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    self.matchTime = [date timeIntervalSince1970];
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"yyyy / MM / dd"];
    self.gameDateLabel.text = [dateToStrFormatter stringFromDate:date];
}

#pragma mark - Action
- (IBAction)actionPressOK:(id)sender {
    
    [self finishMatch];
}

- (IBAction)actionDateSetting:(id)sender {
    
    self.datePicker = [GBGameDatePicker showWithDate:[NSDate dateWithTimeIntervalSince1970:self.matchTime]];
    self.datePicker.delegate = self;
}

- (IBAction)actionNomalFirstTimeSetting:(id)sender {
    
    self.currentSelectIndex = TimeType_FirstHalf;
    
    NSDate *firstStartDate = [self dateWithTime:self.nomalFirstHalfBeginTimeLabel.text];
    NSDate *firstEndDate = [self dateWithTime:self.nomalFirstHalfEndTimeLabel.text];
    NSInteger startH = [firstStartDate hour];
    NSInteger startM = [firstStartDate minute];
    NSInteger endH = [firstEndDate hour];
    NSInteger endM = [firstEndDate minute];
    
    self.timePicker = [GBGameTimePicker showWithSelectIndex:startH startMin:startM endHour:endH endMin:endM];
    self.timePicker.delegate = self;
}

- (IBAction)actionNomalSecondTimeSetting:(id)sender {
    
    self.currentSelectIndex = TimeType_SecondHalf;
    
    NSDate *firstStartDate = [self dateWithTime:self.nomalSecondHalfBeginTimeLabel.text];
    NSDate *firstEndDate = [self dateWithTime:self.nomalSecondHalfEndTimeLabel.text];
    NSInteger startH = [firstStartDate hour];
    NSInteger startM = [firstStartDate minute];
    NSInteger endH = [firstEndDate hour];
    NSInteger endM = [firstEndDate minute];
    
    self.timePicker = [GBGameTimePicker showWithSelectIndex:startH startMin:startM endHour:endH endMin:endM];
    self.timePicker.delegate = self;
}

- (IBAction)actionScoreSetting:(id)sender {
    
    self.scorePicker = [GBGameScorePicker showWithOurSelectIndex:self.ourSideScoreLabel.text.integerValue oppSelectIndex:self.oppSideScoreLabel.text.integerValue];
    self.scorePicker.delegate = self;
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"赛后设置");
    [self setupBackButtonWithBlock:nil];
    
    [self updateTimeUI];
    
    self.okButton.enabled = YES;
}

- (void)updateTimeUI {
    
    long beginTime = self.matchTime;
    
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"HH:mm"];
    
    self.nomalFirstHalfBeginTimeLabel.text = @"9:00";
    self.nomalFirstHalfEndTimeLabel.text = @"9:45";
    self.nomalSecondHalfBeginTimeLabel.text = @"10:00";
    self.nomalSecondHalfEndTimeLabel.text = @"10:45";
    
    dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"yyyy / MM / dd"];
    self.gameDateLabel.text = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:beginTime]];
}

- (void)finishMatch {
    
    NSDate *firstStartDate = [self dateWithTime:self.nomalFirstHalfBeginTimeLabel.text];
    NSDate *firstEndDate = [self dateWithTime:self.nomalFirstHalfEndTimeLabel.text];
    NSDate *secondStartDate = [self dateWithTime:self.nomalSecondHalfBeginTimeLabel.text];
    NSDate *secondEndDate = [self dateWithTime:self.nomalSecondHalfEndTimeLabel.text];
    
    NSInteger weScore= [self.ourSideScoreLabel.text integerValue];
    NSInteger otherScore = [self.oppSideScoreLabel.text integerValue];
    
    MatchInfo *matchInfo = [[MatchInfo alloc] init];
    matchInfo.matchId = self.matchId;
    matchInfo.homeScore = weScore;
    matchInfo.guestScore = otherScore;
    matchInfo.firstStartTime = [firstStartDate timeIntervalSince1970];
    matchInfo.firstEndTime = [firstEndDate timeIntervalSince1970];
    matchInfo.secondStartTime = [secondStartDate timeIntervalSince1970];
    matchInfo.secondEndTime = [secondEndDate timeIntervalSince1970];
    
    [self showLoadingToast];
    @weakify(self)
    [MatchRequest commitMatchComplete:matchInfo handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [[UIApplication sharedApplication].keyWindow showToastWithText:LS(@"数据上传成功，请稍后到比赛记录中查看比赛热力图")];
            
            [[RawCacheManager sharedRawCacheManager] setDoingMatchId:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CompleteMatchSuccess object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (NSDate *)dateWithTime:(NSString *)timeString {
    
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *YMD = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.matchTime]];
    
    NSDateFormatter *strToDataFormatter = [[NSDateFormatter alloc] init];
    [strToDataFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [strToDataFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", YMD, timeString]];
    
    return date;
}


@end

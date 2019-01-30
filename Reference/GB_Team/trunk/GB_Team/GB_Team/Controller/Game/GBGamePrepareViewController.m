//
//  GBGamePrepareViewController.m
//  GB_Team
//
//  Created by weilai on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBGamePrepareViewController.h"
#import "GBHomePageViewController.h"
#import "GBBindPlayerViewController.h"

#import "MatchBindInfo.h"
#import "TeamRequest.h"

#define SELECT_NIL_VALUE -1

@interface GBGamePrepareViewController () <UITextFieldDelegate, UIComboBoxDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *homeTeamNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *visiterTeamNameTextField;
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;
@property (weak, nonatomic) IBOutlet UIComboBox *selectCombo;

@property (nonatomic, assign) NSInteger selectTeamIndex;
@property (nonatomic, strong) NSArray<TeamInfo *> *teamArray;

@property (nonatomic, strong) MatchBindInfo *matchBindInfo;//创建的比赛信息

@end

@implementation GBGamePrepareViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCourtInfo:(CourtInfo *)courtInfo {
    
    if(self=[super init]){
        _matchBindInfo = [[MatchBindInfo alloc] init];
        _matchBindInfo.matchTime = [[NSDate date] timeIntervalSince1970];
        _matchBindInfo.courtId = courtInfo.courtId;
        _matchBindInfo.courtName = courtInfo.courtName;
        
        _selectTeamIndex = SELECT_NIL_VALUE;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBHomePageViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Notification

#pragma mark - Delegate

// 字数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.homeTeamNameTextField) {
        if(strlen([textField.text UTF8String]) >= 33 && range.length != 1)return NO;
    }else if (textField == self.visiterTeamNameTextField) {
        if(strlen([textField.text UTF8String]) >= 33 && range.length != 1)return NO;
    }
    return YES;
}

// Done键盘回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    UITextField *textField = notification.object;
    if (textField != self.homeTeamNameTextField && textField != self.visiterTeamNameTextField) {
        return;
    }
    [self checkInputValid];
}

#pragma mark - Delegate
#pragma mark - UIComboBoxDelegate
- (void)comboBox:(UIComboBox *)comboBox selected:(int)selected {
    
    self.selectTeamIndex = selected;
    [self updateSelectTeam];
    [self checkInputValid];
}

#pragma mark - Action
- (IBAction)actionPressOK:(id)sender {
    
    NSString *homeTeam = [self.homeTeamNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *vistorTeam = [self.visiterTeamNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    _matchBindInfo.matchName = [NSString stringWithFormat:@"%@VS%@", homeTeam, vistorTeam];
    _matchBindInfo.homeTeamName = self.teamArray[self.selectTeamIndex].teamName;
    _matchBindInfo.homeTeamId = self.teamArray[self.selectTeamIndex].teamId;
    
    _matchBindInfo.guestTeamName = vistorTeam;
    
    GBBindPlayerViewController *vc = [[GBBindPlayerViewController alloc] initWithMatchBindInfo:_matchBindInfo];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"赛前设置");
    [self setupBackButtonWithBlock:nil];
    
    self.selectCombo.delegate = self;
    [self.selectCombo setComboBoxPlaceholder:@"球队选择" color:[UIColor colorWithHex:0x01FF00]];
    
    self.homeTeamNameTextField.enabled = NO;
    self.visiterTeamNameTextField.delegate = self;
    NSDate *matchDate = [NSDate date];
    self.dateLabel.text = [NSString stringWithFormat:@"%td - %02td - %02td", matchDate.year, matchDate.month, matchDate.day];
    self.addressLabel.text = self.matchBindInfo.courtName;

    self.homeTeamNameTextField.text = LS(@"");
    self.visiterTeamNameTextField.text = LS(@"对手");
    
}

- (void)loadData {

    @weakify(self)
    [TeamRequest getTeamListWithHandler:^(id result, NSError *error) {
        
        @strongify(self)
        if (!error) {
            self.teamArray = result;
            [self updateComboData];
        }
    }];
}

- (void)updateComboData {
    
    NSMutableArray *teamNameArray = [NSMutableArray array];
    for (int i = 0; i < [self.teamArray count]; i++) {
        [teamNameArray addObject:((TeamInfo *) self.teamArray[i]).teamName];
    }
    self.selectCombo.entries = [teamNameArray copy];
}

- (void)updateSelectTeam {
    
    if (self.selectTeamIndex != SELECT_NIL_VALUE && self.selectTeamIndex < [self.teamArray count]) {
        TeamInfo *teamInfo = self.teamArray[self.selectTeamIndex];
        self.homeTeamNameTextField.text = teamInfo.teamName;
    }
}

- (void)checkInputValid {
    
    NSString *homeTeam = [self.homeTeamNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *vistorTeam = [self.visiterTeamNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL isInputValid = homeTeam.length>0 && vistorTeam.length>0;
    BOOL isSelectValid = self.selectTeamIndex != SELECT_NIL_VALUE;
    self.okButton.enabled = isInputValid && isSelectValid;
}

@end

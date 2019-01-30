//
//  GBTeamAddViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBTeamAddViewController.h"
#import "GBHomePageViewController.h"
#import "GBHightLightButton.h"
#import "GBTeamMemberViewController.h"

#import "TeamRequest.h"

const static NSInteger kMinTeamNameLength = 2;
const static NSInteger kMaxTeamNameLength = 50;

@interface GBTeamAddViewController ()
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;
@property (weak, nonatomic) IBOutlet UITextField *teamNameTextField;

@end

@implementation GBTeamAddViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action

- (IBAction)actionPressOk:(id)sender {

    NSString *teamName = [self.teamNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self showLoadingToast];

    @weakify(self)
    [TeamRequest addTeam:teamName handler:^(id result, NSError *error) {
        @strongify(self)
        
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CreateTeamSuccess object:nil];
            GBTeamMemberViewController *vc = [[GBTeamMemberViewController alloc] initWithTeamId:[result integerValue]];
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [viewControllers removeLastObject];
            [viewControllers addObject:vc];
            [self.navigationController setViewControllers:viewControllers animated:YES];
        }
    }];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    [self checkInputValid];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"添加球队");
    [self setupBackButtonWithBlock:nil];
}

- (void)checkInputValid {
    
    NSString *teamName = [self.teamNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL isInputValid = teamName.length>=kMinTeamNameLength && teamName.length<=kMaxTeamNameLength;
    self.okButton.enabled = isInputValid;
}

@end

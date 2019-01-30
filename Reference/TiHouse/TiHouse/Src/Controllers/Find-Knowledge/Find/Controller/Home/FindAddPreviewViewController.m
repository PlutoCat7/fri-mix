//
//  FindAddPreviewViewController.m
//  TiHouse
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAddPreviewViewController.h"
#import "BaseNavigationController.h"
#import "FindDraftViewController.h"
#import "FindArticleEditViewController.h"


#import "NSDate+Extend.h"
#import "FindAddPhotoPresentTool.h"
#import "NotificationConstants.h"


@interface FindAddPreviewViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *articleBgImageView;

@property (nonatomic, strong) FindAddPhotoPresentTool *addPhotoPresentTool;

@end

@implementation FindAddPreviewViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasPostPhoto) name:Notification_Posted_Photo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasPostPhoto) name:Notification_Posted_Article object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.articleBgImageView.layer.cornerRadius = self.articleBgImageView.width/2;
        self.photoBgImageView.layer.cornerRadius = self.photoBgImageView.width/2;
    });
}

#pragma mark - Notification

- (void)hasPostPhoto {
    
    [self actionClose:nil];
}

#pragma mark - Action

- (IBAction)actionDraft:(id)sender {
    
    [self.navigationController pushViewController:[FindDraftViewController new] animated:YES];
}
- (IBAction)actionClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)actionPhoto:(id)sender {
    
    self.addPhotoPresentTool = [[FindAddPhotoPresentTool alloc] init];
    [self.addPhotoPresentTool presentToolWithViewController:self];
}

- (IBAction)actionArticle:(id)sender {
    
    FindArticleEditViewController *vc = [FindArticleEditViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)setupUI {
    
    NSDate *currentDate = [NSDate date];
    self.dateLabel.text = [NSString stringWithFormat:@"%td-%02td-%02td", currentDate.year, currentDate.month, currentDate.day];
    self.weekdayLabel.text = [currentDate dayFromWeekday];
}

@end

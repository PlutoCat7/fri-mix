//
//  GBFeedbackViewController.m
//  GB_Football
//
//  Created by gxd on 2018/1/11.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "GBFeedbackViewController.h"

#import "FeedbackCollectionViewCell.h"

#import "SystemRequest.h"

static const NSInteger kFeedbackMessageMinLength = 1;
static const NSInteger kFeedbackMessageMaxLength = 200;

@interface GBFeedbackViewController ()<UICollectionViewDelegate,
UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UIView *collectionContainerView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numberLimitLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

//静态
@property (weak, nonatomic) IBOutlet UILabel *descLabel1;
@property (weak, nonatomic) IBOutlet UILabel *descLabel2;

@property (nonatomic, strong) NSArray<NSString *> *feedbackTitles;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation GBFeedbackViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)localizeUI {
    self.descLabel1.text = LS(@"setting.feedback.desc.tips.1");
    self.descLabel2.text = LS(@"setting.feedback.desc.tips.2");
    [self.commitButton setTitle:LS(@"setting.feedback.commint") forState:UIControlStateNormal];
    [self.commitButton setTitle:LS(@"setting.feedback.commint") forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // Dispose of any resources that can be recreated.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.collectionView.frame = self.collectionContainerView.bounds;
    });
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    [self checkAndUpdateUI];
}

- (IBAction)actionCommit:(id)sender {
    
    if (!self.selectIndexPath) {
        return;
    }
    [self showLoadingToast];
    FeedbackType type = FeedbackType_Software;
    switch (self.selectIndexPath.row) {
        case 0:
            type = FeedbackType_Software;
            break;
        case 1:
            type = FeedbackType_Firmware;
            break;
        case 2:
            type = FeedbackType_Buy;
            break;
        case 3:
            type = FeedbackType_AfterSales;
            break;
        case 4:
            type = FeedbackType_Expect;
            break;
        case 5:
            type = FeedbackType_praise;
            break;
        default:
            break;
    }
    
    @weakify(self)
    [SystemRequest sendFeedbackWithType:type message:self.textView.text handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [[UIApplication sharedApplication].keyWindow showToastWithText:LS(@"setting.feedback.commint.success.tips")];
            if ([self.navigationController.topViewController isMemberOfClass:[self class]]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

#pragma mark - Private

- (void)loadData {
    
    self.feedbackTitles = @[LS(@"setting.feedback.software"), LS(@"setting.feedback.firmware"),
                           LS(@"setting.feedback.bug"),
                            LS(@"setting.feedback.after.sale"),
                            LS(@"setting.feedback.expect"),
                            LS(@"setting.feedback.praise")
                            ];
}

- (void)setupUI {
    
    self.title = LS(@"setting.nav.feedback");
    [self setupBackButtonWithBlock:nil];
    
    [self setupCollectionView];
    
    self.textView.zw_placeHolder = LS(@"setting.feedback.desc.tips.3");
    self.textView.zw_placeHolderColor = [UIColor colorWithHex:0x5b5b5b];
    self.numberLimitLabel.text = [NSString stringWithFormat:@"0/%td", kFeedbackMessageMaxLength];
}

-(void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100*kAppScale,45*kAppScale)];
    flowLayout.minimumInteritemSpacing = 11*kAppScale;
    flowLayout.minimumLineSpacing = 7*kAppScale;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 25*kAppScale, 0, 25*kAppScale);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.collectionContainerView.bounds collectionViewLayout:flowLayout];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedbackCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FeedbackCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionContainerView addSubview:self.collectionView];
    
}

- (void)checkAndUpdateUI {
    
    NSString *newName = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.commitButton.enabled = !([NSString stringIsNullOrEmpty:newName]) && (newName.length>=kFeedbackMessageMinLength && newName.length<=kFeedbackMessageMaxLength) && self.selectIndexPath;
    
    NSString *hint = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)newName.length, kFeedbackMessageMaxLength];
    self.numberLimitLabel.text = hint;
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _feedbackTitles.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeedbackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedbackCollectionViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = _feedbackTitles[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndexPath = indexPath;
    [self checkAndUpdateUI];
}

@end

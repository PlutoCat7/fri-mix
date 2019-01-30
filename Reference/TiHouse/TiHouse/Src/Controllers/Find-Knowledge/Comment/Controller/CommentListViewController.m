//
//  CommentListViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentViewController.h"
#import "BaseNavigationController.h"
#import "UIViewController+YHToast.h"

#import "CommentViewCell.h"
#import "ODRefreshControl.h"
#import "CommentPageRequest.h"
#import "CommentRequest.h"
#import "FindCommentPageRequest.h"
#import "NotificationConstants.h"

@interface CommentListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@property (nonatomic, strong) ODRefreshControl *refreshControl;

@property (assign, nonatomic) NSInteger knowId;
@property (assign, nonatomic) CommentType commentType;

@property (nonatomic, strong) BasePageNetworkRequest *recordPageRequest;
@property (nonatomic, strong) CommentPageRequest *knowPageRequest;
@property (nonatomic, strong) FindCommentPageRequest *assPageRequest;

@property (nonatomic, strong) NSArray *recordList;

@end

@implementation CommentListViewController


- (instancetype)initWithKnowId:(NSInteger)knowId {
    if (self = [super init]) {
        _knowId = knowId;
        _commentType = CommentType_Know;
    }
    return self;
}

- (instancetype)initWithAssenarcId:(NSInteger)assenarcId {
    if (self = [super init]) {
        _knowId = assenarcId;
        _commentType = CommentType_Asse;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self wr_setNavBarBarTintColor:kColorWhite];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentSuccess) name:Notification_Comment_Success object:nil];
    
}

#pragma mark - Notification

- (void)commentSuccess {
    
    [self loadNetworkData];
}

#pragma mark - Getters & Setters

- (BasePageNetworkRequest *)recordPageRequest {
    
    if (_commentType == CommentType_Know) {
        return self.knowPageRequest;
        
    }
    
    return self.assPageRequest;
}

- (CommentPageRequest *)knowPageRequest {
    
    if (!_knowPageRequest) {
        _knowPageRequest = [[CommentPageRequest alloc] init];
        _knowPageRequest.knowledgeId = _knowId;
        _knowPageRequest.rankType = CommentRankType_D;
        
    }
    
    return _knowPageRequest;
}

- (FindCommentPageRequest *)assPageRequest {
    
    if (!_assPageRequest) {
        _assPageRequest = [[FindCommentPageRequest alloc] init];
        _assPageRequest.assemId = _knowId;
        _assPageRequest.rankType = CommentRankType_D;
        
    }
    
    return _assPageRequest;
}

- (IBAction)actionComment:(id)sender {
    CommentViewController *vc = [[CommentViewController alloc] initWithCommentId:_knowId commId:0 commuid:0 comuname:nil type:_commentType];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - private
- (void)setupUI {
    
    self.title = @"评论";
    
    [self.commentView.layer setMasksToBounds:YES];
    [self.commentView.layer setCornerRadius:3.f];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentViewCell" bundle:nil] forCellReuseIdentifier:@"CommentViewCell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)loadNetworkData {
    [self getFirstRecordList];
}

- (void)refresh {
    [self getFirstRecordList];
}

- (void)getFirstRecordList {
    [self showLoadingToast];
    @weakify(self)
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.refreshControl endRefreshing];
        [self dismissToast];
        
        if (error) {
            [NSObject showHudTipStr:error.domain];
            [self.tableView reloadData];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            [self.tableView reloadData];
        }
    }];
}

- (void)getNextRecordList {
    
    @weakify(self)
    [self.recordPageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark UITableViewDelegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordList == nil ? 0 : self.recordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    [cell refreshWithCommentInfo:self.recordList[indexPath.row] type:_commentType];
    WEAKSELF
    cell.clickZanBlock = ^(id commentInfo) {
        [weakSelf clickZan:commentInfo];
    };
    cell.clickCommentBlock = ^(id commentInfo) {
        [weakSelf clickCommnet:commentInfo];
    };
   
    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_commentType == CommentType_Know) {
        CommentInfo * commentInfo = self.recordList[indexPath.row];
        NSString *content = [NSString stringWithFormat:@"%@:%@", commentInfo.knowcommnameon, commentInfo.knowcommcontentsub];
        
        return commentInfo.knowcommnameon.length == 0 ? [CommentViewCell defaultHeight:@"" comment:commentInfo.knowcommcontent] : [CommentViewCell defaultHeight:content comment:commentInfo.knowcommcontent];
        
    } else {
        FindAssemarcCommentInfo * commentInfo = self.recordList[indexPath.row];
        NSString *content = [NSString stringWithFormat:@"%@:%@", commentInfo.assemarccommnameon, commentInfo.assemarccommcontentsub];
        
        return commentInfo.assemarccommnameon.length == 0 ? [CommentViewCell defaultHeight:@"" comment:commentInfo.assemarccommcontent] : [CommentViewCell defaultHeight:content comment:commentInfo.assemarccommcontent];
    }
    
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRKBHEIGHT(45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
 
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, kRKBHEIGHT(45))];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRGBHex:0xF2F3F5];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithRGBHex:0x2D2F35];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.text = [NSString stringWithFormat:@"全部评论(%td条)", self.recordPageRequest.responseInfo.allCount];
    
    UIButton *rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rankBtn setImage:[UIImage imageNamed:@"crank"] forState:UIControlStateNormal];
    [rankBtn setImage:[UIImage imageNamed:@"crank"] forState:UIControlStateSelected];
    rankBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rankBtn.enabled = YES;
    [rankBtn addTarget:self action:@selector(clickRank:) forControlEvents:UIControlEventTouchUpInside];
    
    CommentRankType rankType = CommentRankType_D;
    if (_commentType == CommentType_Know) {
        rankType = self.knowPageRequest.rankType;
    } else {
        rankType = self.assPageRequest.rankType;
    }
    if (rankType == CommentRankType_A) {
        rankBtn.imageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
    } else {
        rankBtn.imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }
    
    [sectionView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).offset(10);
        make.right.equalTo(sectionView).offset(-10);
        make.bottom.equalTo(sectionView);
        make.height.equalTo(@(kRKBHEIGHT(1)));
    }];
    [sectionView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).offset(10);
        make.right.equalTo(sectionView).offset(-10);
        make.top.equalTo(sectionView);
        make.bottom.equalTo(sectionView);
    }];
    [sectionView addSubview:rankBtn];
    [rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionView).offset(-10);
        make.centerY.equalTo(sectionView.mas_centerY);
        make.height.equalTo(@(kRKBHEIGHT(45)));
    }];
    
    return sectionView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.recordPageRequest isLoadEnd] &&
        self.recordList.count-1 == indexPath.row) {
        [self getNextRecordList];
    }
}

- (void)clickZan:(id)comment {
    if (_commentType == CommentType_Know) {
        CommentInfo *commentInfo = comment;
        if (commentInfo.knowcommiszan) {
            [CommentRequest removeZanComment:commentInfo.knowcommid handler:^(id result, NSError *error) {
                if (!error) {
                    
                    commentInfo.knowcommiszan = !commentInfo.knowcommiszan;
                    commentInfo.knowcommzan -= 1;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Comment_Zan object:nil];
                    
                    [self.tableView reloadData];
                }
            }];
            
        } else {
            [CommentRequest addZanComment:commentInfo.knowcommid handler:^(id result, NSError *error) {
                if (!error) {
                    
                    commentInfo.knowcommiszan = !commentInfo.knowcommiszan;
                    commentInfo.knowcommzan += 1;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Comment_Zan object:nil];
                    
                    [self.tableView reloadData];
                }
            }];
        }
        
    } else {
        FindAssemarcCommentInfo *commentInfo = comment;
        if (commentInfo.assemarccommiszan) {
            [CommentRequest removeAssemarcZanComment:commentInfo.assemarccommid handler:^(id result, NSError *error) {
                if (!error) {
                    
                    commentInfo.assemarccommiszan = !commentInfo.assemarccommiszan;
                    commentInfo.assemarccommnumzan -= 1;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Comment_Zan object:nil];
                    
                    [self.tableView reloadData];
                }
            }];
            
        } else {
            [CommentRequest addAssemarcZanComment:commentInfo.assemarccommid handler:^(id result, NSError *error) {
                if (!error) {
                    
                    commentInfo.assemarccommiszan = !commentInfo.assemarccommiszan;
                    commentInfo.assemarccommnumzan += 1;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Comment_Zan object:nil];
                    
                    [self.tableView reloadData];
                }
            }];
        }
    }
    
}

- (void)clickCommnet:(id)commentInfo {
    WEAKSELF
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"回复" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf clickComment:commentInfo];
        
    }];
    [takePhotoAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *ablumAction = [UIAlertAction actionWithTitle:@"复制" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf clickCopy:commentInfo];
        
    }];
    [ablumAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
//    UIAlertAction *cloudAction = [UIAlertAction actionWithTitle:@"举报" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [cloudAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [action2 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    
    [alert addAction:takePhotoAction];
    [alert addAction:ablumAction];
//    [alert addAction:cloudAction];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clickCopy:(id)comment {
    if (_commentType == CommentType_Know) {
        CommentInfo *commentInfo = comment;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = commentInfo.knowcommcontent;
        [NSObject showHudTipStr:self.view tipStr:@"成功复制到粘贴板"];
        
    } else {
        FindAssemarcCommentInfo *commentInfo = comment;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = commentInfo.assemarccommcontent;
        [NSObject showHudTipStr:self.view tipStr:@"成功复制到粘贴板"];
    }
    
}

- (void)clickComment:(id)comment {
    if (_commentType == CommentType_Know) {
        CommentInfo *commentInfo = comment;
        
        CommentViewController *vc = [[CommentViewController alloc] initWithCommentId:_knowId commId:commentInfo.knowcommid commuid:commentInfo.knowcommuid comuname:commentInfo.knowcommname type:_commentType];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    } else {
        FindAssemarcCommentInfo *commentInfo = comment;
        
        CommentViewController *vc = [[CommentViewController alloc] initWithCommentId:_knowId commId:commentInfo.assemarccommid commuid:commentInfo.assemarccommuid comuname:commentInfo.assemarccommname type:_commentType];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

- (void)clickRank:(id)sender {
    UIButton *button = sender;
    CommentRankType rankType = CommentRankType_D;
    
    if (_commentType == CommentType_Know) {
        if (self.knowPageRequest.rankType == CommentRankType_A) {
            self.knowPageRequest.rankType = CommentRankType_D;
            rankType = CommentRankType_D;
            
        } else {
            self.knowPageRequest.rankType = CommentRankType_A;
            rankType = CommentRankType_A;
        }
        
    } else {
        if (self.assPageRequest.rankType == CommentRankType_A) {
            self.assPageRequest.rankType = CommentRankType_D;
            rankType = CommentRankType_D;
        } else {
            self.assPageRequest.rankType = CommentRankType_A;
            rankType = CommentRankType_A;
        }
    }
    
    if (rankType == CommentRankType_A) {
        button.imageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
    } else {
        button.imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }
    
    [self loadNetworkData];
}

@end

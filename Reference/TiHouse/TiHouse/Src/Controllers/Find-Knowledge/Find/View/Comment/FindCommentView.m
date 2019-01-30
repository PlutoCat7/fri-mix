//
//  FindCommentView.m
//  TiHouse
//
//  Created by weilai on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindCommentView.h"
#import "CommentViewCell.h"
#import "CommentListViewController.h"

#import "CommentRequest.h"

@interface FindCommentView()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableLayoutConstraint;

@property (strong, nonatomic) NSArray <FindAssemarcCommentInfo *> *commentArray;

@end

@implementation FindCommentView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupUI];
}

- (void)setupUI {
    [self.commentBtn.layer setMasksToBounds:YES];
    [self.commentBtn.layer setCornerRadius:self.commentBtn.frame.size.height / 2];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentViewCell" bundle:nil] forCellReuseIdentifier:@"CommentViewCell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)refreshWithComments:(NSArray <FindAssemarcCommentInfo *>*)commentArray {
    _commentArray = commentArray;
    
    self.tableLayoutConstraint.constant = [FindCommentView tableViewHeight:commentArray];
    
    [self.tableView reloadData];
}

- (CGFloat)getFindCommentHeight {
    return 160 + [FindCommentView tableViewHeight:self.commentArray];
}

+ (CGFloat)tableViewHeight:(NSArray <FindAssemarcCommentInfo *>*)commentArray {
    CGFloat height = 0;
    if (commentArray.count > 0) {
        FindAssemarcCommentInfo *commentInfo = commentArray[0];
        NSString *content = [NSString stringWithFormat:@"%@:%@", commentInfo.assemarccommnameon, commentInfo.assemarccommcontentsub];
        
        height += commentInfo.assemarccommnameon.length == 0 ? [CommentViewCell defaultHeight:@"" comment:commentInfo.assemarccommcontent] : [CommentViewCell defaultHeight:content comment:commentInfo.assemarccommcontent];
    }
    
    if (commentArray.count > 1) {
        FindAssemarcCommentInfo *commentInfo = commentArray[1];
        NSString *content = [NSString stringWithFormat:@"%@:%@", commentInfo.assemarccommnameon, commentInfo.assemarccommcontentsub];
        
        height += commentInfo.assemarccommnameon.length == 0 ? [CommentViewCell defaultHeight:@"" comment:commentInfo.assemarccommcontent] : [CommentViewCell defaultHeight:content comment:commentInfo.assemarccommcontent];
    }
    return height;
}

- (IBAction)actionComment:(id)sender {
    if (self.clickCommentBlock) {
        self.clickCommentBlock();
    }
}

#pragma mark UITableViewDelegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count > 2 ? 2 : self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    [cell refreshWithCommentInfo:self.commentArray[indexPath.row] type:CommentType_Asse];
    WEAKSELF
    cell.clickZanBlock = ^(id commentInfo) {
        [weakSelf clickZan:commentInfo];
    };
    
    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindAssemarcCommentInfo * commentInfo = self.commentArray[indexPath.row];
    NSString *content = [NSString stringWithFormat:@"%@:%@", commentInfo.assemarccommnameon, commentInfo.assemarccommcontentsub];
    
    return commentInfo.assemarccommnameon.length == 0 ? [CommentViewCell defaultHeight:@"" comment:commentInfo.assemarccommcontent] : [CommentViewCell defaultHeight:content comment:commentInfo.assemarccommcontent];
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (void)clickZan:(id)comment {
    FindAssemarcCommentInfo *commentInfo = comment;
    
    if (commentInfo.assemarccommiszan) {
        [CommentRequest removeAssemarcZanComment:commentInfo.assemarccommid handler:^(id result, NSError *error) {
            if (!error) {
//                GBResponseInfo *info = result;
//                [NSObject showHudTipStr:self tipStr:info.msg];
                
                commentInfo.assemarccommiszan = !commentInfo.assemarccommiszan;
                commentInfo.assemarccommnumzan -= 1;
                
                [self.tableView reloadData];
            }
        }];
        
    } else {
        [CommentRequest addAssemarcZanComment:commentInfo.assemarccommid handler:^(id result, NSError *error) {
            if (!error) {
//                GBResponseInfo *info = result;
//                [NSObject showHudTipStr:self tipStr:info.msg];
                
                commentInfo.assemarccommiszan = !commentInfo.assemarccommiszan;
                commentInfo.assemarccommnumzan += 1;
                
                [self.tableView reloadData];
            }
        }];
    }
    
}

@end

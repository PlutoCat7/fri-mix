//
//  FindPhotoDetailHeaderViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoDetailHeaderViewController.h"
#import "CommentListViewController.h"

#import "FindCommentView.h"
#import "FindPhotoLabelContainerView.h"
#import "FindPhotoHandleLabelView.h"

#import "Login.h"
#import "AssemarcRequest.h"
#import "NotificationConstants.h"

#define kImageViewDataModelKey @"kImageViewDataModelKey"

@interface FindPhotoDetailHeaderViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *editDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) NSMutableArray<UIView *> *imageContainerViewList;

@property (nonatomic, strong) FindAssemarcInfo *assemarcInfo;
@property (nonatomic, strong) FindCommentView *commentView;

@end

@implementation FindPhotoDetailHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageContainerViewList = [NSMutableArray arrayWithCapacity:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userAvatorImageView.layer.cornerRadius = self.userAvatorImageView.height/2;
    });
}

#pragma mark - Public

- (CGFloat)viewHeight {
    
    CGFloat padding = 10;
    if (self.commentArray.count > 0) {
        return self.commentView.bottom;
        
    } else if (self.imageContainerViewList.count == 0) {
        return self.contentLabel.bottom + padding;
        
    } else {
        return self.imageContainerViewList.lastObject.bottom + padding;
    }
}

- (void)refreshWithInfo:(FindAssemarcInfo *)info {
    
    _assemarcInfo = info;
    
    [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:info.urlhead]];
    self.userNameLabel.text = info.username;
    self.editDateLabel.text = info.createtimeStr;
    [self.attentionButton setImage:info.assemarcisconcern?nil:[UIImage imageNamed:@"find_add_attention"] forState:UIControlStateNormal];
    [self.attentionButton setTitle:info.assemarcisconcern?@"已关注":@"关注" forState:UIControlStateNormal];
    self.attentionButton.backgroundColor = info.assemarcisconcern?[UIColor colorWithRGBHex:0xEFEFEF]:kTiMainBgColor;
    self.attentionButton.hidden = [Login curLoginUser].uid == info.assemarcuid;  //自己的文章隐藏关注按钮
    
    NSString *content = info.assemarctitle;
    if (!info.assemtitle ||
        [info.assemtitle isEmpty]) {
        self.contentLabel.text = content;
    }else {
        NSString *assemTitle = [NSString stringWithFormat:@"#%@#", info.assemtitle];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", assemTitle, content]];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRGBHex:0xFEC00C]
                                 range:[[attributedString string] rangeOfString:assemTitle]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kRKBWIDTH(13)] range:NSMakeRange(0, [attributedString string].length)];
        self.contentLabel.attributedText = [attributedString copy];
    }
    
    [self.contentLabel sizeToFit];
    
    //上一个约束view
    UIView *lastView = self.contentLabel;
    [self.imageContainerViewList removeAllObjects];
    for (FindAssemarcFileJA *file in info.assemarcfileJA) {
        UIView *imageView = [self imageContainerView:file];
        objc_setAssociatedObject(imageView, kImageViewDataModelKey, file, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToImageView:)]];
        [self.view addSubview:imageView];
        imageView.top = lastView.bottom + 9;
        [self.imageContainerViewList addObject:imageView];
        
        lastView = imageView;
    }
    
    [self updateCommentView];
}

- (void)setCommentArray:(NSArray<FindAssemarcCommentInfo *> *)commentArray {
    _commentArray = commentArray;
    
    if (_commentArray.count > 0) {
        [self.commentView refreshWithComments:self.commentArray];
        [self updateCommentView];
    }
}

- (void)updateCommentView {
    if (_commentArray.count > 0) {
        
        if (self.imageContainerViewList.count == 0) {
            
            self.commentView.top = self.contentLabel.bottom;
            CGRect commentFrame = self.commentView.frame;
            commentFrame.size.height = [self.commentView getFindCommentHeight];
            self.commentView.frame = commentFrame;
            
        }else {
            
            self.commentView.top = self.imageContainerViewList.lastObject.bottom + 10;
            CGRect commentFrame = self.commentView.frame;
            commentFrame.size.height = [self.commentView getFindCommentHeight];
            self.commentView.frame = commentFrame;
        }
    }
}

#pragma mark - Action

- (IBAction)actionAttention:(id)sender {
    
    [self attentionWithHandler:^(BOOL isSuccess) {
        if (isSuccess) {
            [self.attentionButton setImage:self.assemarcInfo.assemarcisconcern?nil:[UIImage imageNamed:@"find_add_attention"] forState:UIControlStateNormal];
            [self.attentionButton setTitle:self.assemarcInfo.assemarcisconcern?@"已关注":@"关注" forState:UIControlStateNormal];
            self.attentionButton.backgroundColor = self.assemarcInfo.assemarcisconcern?[UIColor colorWithRGBHex:0xEFEFEF]:kTiMainBgColor;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_Attention object:self.assemarcInfo];
        }
    }];
}

#pragma mark - Getters & Setters

- (FindCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[NSBundle mainBundle] loadNibNamed:@"FindCommentView" owner:nil options:nil].firstObject;
        _commentView.frame = CGRectMake(0, 0, kScreen_Width, 160);
        _commentView.autoresizingMask = UIViewAutoresizingNone;
        [self.view addSubview:_commentView];
    }
    
    WEAKSELF
    _commentView.clickCommentBlock = ^{
        CommentListViewController *viewController = [[CommentListViewController alloc] initWithAssenarcId:weakSelf.assemarcInfo.assemarcid];
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    };
    
    return _commentView;
}

#pragma mark - Private

- (void)layoutImageView {
    
    UIView *lastView = self.contentLabel;
    for (UIView *view in self.imageContainerViewList) {
        view.top = lastView.bottom + 9;
        lastView = view;
    }
}

- (UIView *)imageContainerView:(FindAssemarcFileJA *)fileJA {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width-12*2, 0)];
    view.height = view.width*(fileJA.assemarcfileh/fileJA.assemarcfilew);
    UIImageView *imageView = [UIImageView new];
    imageView.frame = view.bounds;
    [imageView sd_setImageWithURL:[NSURL URLWithString:fileJA.assemarcfileurl]];
    [view addSubview:imageView];
    
    //添加标签
    FindPhotoLabelContainerView *labelContainerView = [[NSBundle mainBundle] loadNibNamed:@"FindPhotoLabelContainerView" owner:self options:nil].firstObject;
    labelContainerView.frame = view.bounds;
    [view addSubview:labelContainerView];
    
    for (FindAssemarcFileTagJA *model in fileJA.assemarcfiletagJA) {
        FindPhotoHandleLabelView *labelView = [FindPhotoHandleLabelView createWithLabelModel:model longPressBlock:nil clickBlock:^(FindPhotoHandleLabelView *labelView) {
            //点击标签， 跳转搜索界面
        } edit:NO];
        labelView.center = CGPointMake(labelContainerView.width*model.assemarcfiletagwper, labelContainerView.height*model.assemarcfiletaghper);
        [labelContainerView addSubview:labelView];
    }
    
    return view;
}

- (void)respondsToImageView:(UITapGestureRecognizer *)gesture
{
    FindAssemarcFileJA *jaDataModel = objc_getAssociatedObject(gesture.view, kImageViewDataModelKey);
    if (jaDataModel)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(findPhotoDetailHeaderViewController:clickContentImageViewWithViewModel:)])
        {
            [self.delegate findPhotoDetailHeaderViewController:self clickContentImageViewWithViewModel:jaDataModel];
        }
    }
}

- (void)attentionWithHandler:(void(^)(BOOL isSuccess))handler {
    
    FindAssemarcInfo *info  = self.assemarcInfo;
    if (info.assemarcisconcern) {
        [AssemarcRequest removeAttentionWithConcernuidon:info.assemarcuid handler:^(id result, NSError *error) {
            info.assemarcisconcern = NO;
            BLOCK_EXEC(handler, error==nil)
        }];
    }else {
        [AssemarcRequest addAttentionWithConcernuidon:info.assemarcuid handler:^(id result, NSError *error) {
            info.assemarcisconcern = YES;
            BLOCK_EXEC(handler, error==nil)
        }];
    }
}

@end

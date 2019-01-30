//
//  ScheduleOptionsView.m
//  TiHouse
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleOptionsView.h"
#import "UITableView+RegisterNib.h"
#import "ScheduleOptionsTableViewCell.h"

#define kViewHeight 35

@interface ScheduleOptionsView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ScheduleOptionsView

+ (instancetype)sharedInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    ScheduleOptionsView *view = [super sharedInstanceWithViewModel:viewModel];
    view.viewModel = viewModel;
    view.viewModel.scheduletype = -1;
    [view xl_setupViews];
    [view xl_bindViewModel];
    return view;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!self.viewModel.firstLoad) {
        self.viewModel.firstLoad = YES;
        self.frame = CGRectMake(0, 0, kScreen_Width, kViewHeight);
    }
}

- (void)xl_setupViews{
    [self addSubview:self.tableView];
    [self configTableView];
    [self setButtonShadow];
}

- (void)xl_bindViewModel{

    @weakify(self);
    [RACObserve(self.viewModel, isOpenList) subscribeNext:^(id x) {
        @strongify(self);
        CGFloat vHeight = kViewHeight;
        
        if ([x  boolValue]) {
            vHeight = kScreen_Height - kNavigationBarHeight;
        } else {
            [self.viewModel.reloadData sendNext:nil];
        }
        self.tableView.hidden = ![x  boolValue];
        if (self.viewModel.firstLoad) {
            [self setViewFrameWithH:vHeight];
        }
    }];
    
    [RACObserve(self.viewModel, chooseTitle) subscribeNext:^(id x) {
        @strongify(self);
        [self setSelectTitle:IF_NULL_TO_STRINGSTR(x, @"")];
//        [self.btnSchedule setTitle:IF_NULL_TO_STRINGSTR(x, @"") forState:UIControlStateNormal];
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, kScreen_Width, 150) style:UITableViewStylePlain];
    }
    return _tableView;
}

#pragma mark -界面设置

- (void)configTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNibName:NSStringFromClass([ScheduleOptionsTableViewCell class])];
}

- (void)setViewFrameWithH:(CGFloat)vHeight{
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.frame = CGRectMake(0, 0, kScreen_Width, vHeight);
    }];
}

- (void)setButtonShadow{
    // 阴影的颜色
    self.btnSchedule.layer.shadowColor = RGB(220, 220, 220).CGColor;
    // 阴影的透明度
    self.btnSchedule.layer.shadowOpacity = 0.2f;
    // 阴影偏移量
    self.btnSchedule.layer.shadowOffset = CGSizeMake(0,4);
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.viewModel.arrData.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *arr = self.viewModel.arrData[section];
//    return arr.count;
    return self.viewModel.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *arr = self.viewModel.arrData[indexPath.row];
    ScheduleOptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ScheduleOptionsTableViewCell class]) forIndexPath:indexPath];
    NSDictionary *dict = self.viewModel.arrData[indexPath.row];//arr[indexPath.row];
    cell.dict = dict;
    BOOL selStatus = NO;
    NSInteger index = indexPath.row +1 +2;//indexPath.section * 2 +indexPath.row +1;
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//             selStatus =  self.viewModel.timeType == 2;
//        }else{
//             selStatus =  self.viewModel.timeType == 1;
//        }
//    }else{
        if (indexPath.row == 0) {
            selStatus =  self.viewModel.scheduletype == -1;
        }else if (indexPath.row == 1){
            selStatus =  self.viewModel.scheduletype == 1;
        }
        else
        {
            selStatus = self.viewModel.scheduletype == 0;
        }
//    }

    
    [cell setViewWithSelStatus:selStatus index:index];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            self.viewModel.timeType = 2;//未来
//            self.viewModel.chooseTitle = @"未来日程";
//        }else{
//            self.viewModel.timeType = 1;//过去
//            self.viewModel.chooseTitle = @"过去日程";
//        }
//    }else{
    if (indexPath.row == 0) {
        self.viewModel.scheduletype = -1;
        self.viewModel.chooseTitle = @"全部日程";
    }
    else if (indexPath.row == 1)
    {
        self.viewModel.scheduletype = 1;
        self.viewModel.chooseTitle = @"已完成的日程";
    }
    else{
        self.viewModel.scheduletype = 0;
        self.viewModel.chooseTitle = @"未完成的日程";
    }
    self.viewModel.isOpenList = !self.viewModel.isOpenList;
//    }
    [self.tableView reloadData];
}

#pragma mark - 按钮事件

- (IBAction)btnClick:(id)sender {
    
    self.viewModel.isOpenList = !self.viewModel.isOpenList;
    
    if (self.viewModel.isOpenList) {
        [self.btnSchedule setImage:IMAGE_ANME(@"s_up") forState:UIControlStateNormal];
    }else {
        [self.btnSchedule setImage:IMAGE_ANME(@"s_down") forState:UIControlStateNormal];
    }
    
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setSelectTitle:@"未完成的日程"];
}

/**
 设置按钮的显示
 @param name 名称
 */
- (void)setSelectTitle:(NSString *)name{
    
    [self.btnSchedule setTitle:name forState:UIControlStateNormal];
    
    [self.btnSchedule.titleLabel sizeToFit];
    self.btnSchedule.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.btnSchedule.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    CGFloat imgLeading = self.btnSchedule.titleLabel.frame.size.width > kScreen_Width - 60 ? kScreen_Width - 60 : self.btnSchedule.titleLabel.frame.size.width;
    
    self.btnSchedule.imageEdgeInsets = UIEdgeInsetsMake(0,  imgLeading+ 2.5, 0, -self.btnSchedule.titleLabel.frame.size.width - 2.5);
    self.btnSchedule.titleEdgeInsets = UIEdgeInsetsMake(0, -self.btnSchedule.currentImage.size.width, 0, self.btnSchedule.currentImage.size.width);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

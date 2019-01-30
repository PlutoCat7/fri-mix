//
//  TracticsSelectView.m
//  GB_Football
//
//  Created by yahua on 2017/7/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TracticsSelectView.h"

#import "TracticsSelectCell.h"

@interface TracticsSelectView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;


@property (nonatomic, strong) NSArray<NSString *> *entries;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) void(^didSelectBlock)(NSInteger index);
@property (nonatomic, copy) void(^cancelBlock)();

@end

@implementation TracticsSelectView

+ (instancetype)showWithTopY:(CGFloat)topY entries:(NSArray<NSString *> *)entries selectIndex:(NSInteger)selectIndex cancel:(void(^)())cancel complete:(void(^)(NSInteger index))complete {
    
    TracticsSelectView *view = [[NSBundle mainBundle] loadNibNamed:@"TracticsSelectView" owner:nil options:nil].firstObject;
    view.frame = CGRectMake(0, kUIScreen_NavigationBarHeight, kUIScreen_Width, kUIScreen_AppContentHeight);
    view.tableViewTopConstraint.constant = topY;
    view.selectIndex = selectIndex;
    view.entries = entries;
    view.cancelBlock = cancel;
    view.didSelectBlock = complete;
    [view.tableView reloadData];
//    NSIndexPath *path = [NSIndexPath indexPathForRow:selectIndex inSection:0];
//
//    if (entries.count && path) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [view.tableView selectRowAtIndexPath:path
//                                        animated:YES
//                                  scrollPosition:UITableViewScrollPositionBottom];
//        });
//    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    return view;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TracticsSelectCell" bundle:nil] forCellReuseIdentifier:@"TracticsSelectCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)dismiss {
    
    [self removeFromSuperview];
}

#pragma mark - Action

- (IBAction)antionTouchBacgroundView:(id)sender {
    
    [self removeFromSuperview];
    BLOCK_EXEC(self.cancelBlock);
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_entries count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40*kAppScale;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TracticsSelectCell* cell = (TracticsSelectCell *)[tableView dequeueReusableCellWithIdentifier:@"TracticsSelectCell"];
    cell.teamName.text = [_entries objectAtIndex:[indexPath row] ];
    cell.lineView.hidden = indexPath.row == _entries.count-1;

    return cell;
}

- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BLOCK_EXEC(self.didSelectBlock, indexPath.row);
    [self removeFromSuperview];
}

@end

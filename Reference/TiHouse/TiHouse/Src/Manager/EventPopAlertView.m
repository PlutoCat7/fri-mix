//
//  EventPopAlertView.m
//  TiHouse
//
//  Created by guansong on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "EventPopAlertView.h"
#import <POP.h>
#import "ScheduleModel.h"

#define kViewHeight 260
#define kTitleHeight 60
@interface EventPopAlertView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UILabel *lblWeek;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vHeightLayout;

@property (nonatomic,strong) NSMutableArray * data;

// 页面控制部分
@property (nonatomic,strong) EventPopViewAddBlock addblock;
@property (nonatomic,strong) EventPopViewActionBlock actionblock;

@end


@implementation EventPopAlertView

static EventPopAlertView * _instanse=nil;
+(void) showWithTitle:(NSString *)title
           andWeekday:(NSString *) weekday
                 Data:(NSArray *)arrData
       ActionCallBack:(EventPopViewActionBlock)actionBlock AddCallBack:(EventPopViewAddBlock)addBlock
{
    
    EventPopAlertView * popview = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    popview.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    
    popview.data = [[NSMutableArray alloc] initWithArray: arrData];
    
    popview.tableView.delegate = popview;
    popview.tableView.dataSource = popview;
    
    CGFloat h = arrData.count * 50;
    if (h > 300) {
        h = 300;
    }
    h += 70 + kTitleHeight;
    popview.vHeightLayout.constant = h;
    
    popview.lblDate.text = IF_NULL_TO_STRINGSTR(title, @"-");
    popview.lblWeek.text = JString(@"·%@",weekday);
  
    
    popview.actionblock = actionBlock;
    popview.addblock = addBlock;
    [popview showWithContentView:popview.bgView direction:PopAlertViewDirectionUp];
}


#pragma mark - 代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView * colorView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 20, 20 )];
        colorView.tag = 11;
        
        UILabel * lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, kScreen_Width-86-60, 30)];
        lbltitle.font = ZISIZE(12);
        lbltitle.tag = 22;
        
        lbltitle.textColor = RGBA(96, 96, 96, 1);
        
        [cell.contentView addSubview:lbltitle];
        [cell.contentView addSubview:colorView];
    
    }
    
    ScheduleModel *model = self.data[indexPath.row];
   
    UIView * colorView = [cell.contentView viewWithTag:11];
    colorView.backgroundColor =  [UIColor colorWithHexString:JString(@"0x%@",model.schedulecolor)];
    
    UILabel * lbltitle = [cell.contentView viewWithTag:22];
    lbltitle.text = IF_NULL_TO_STRINGSTR(model.schedulename, @"-");

    return cell;
}

/**
 *  只要实现了这个方法，左滑出现按钮的功能就有了
 (一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     __block ScheduleModel *m = self.data[indexPath.row];
    WS(weakSelf);
    
    if (m.scheduletype == 0) {
        UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"已完成" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            if (m.scheduletype == 1) {
                return ;
            }
            if(_actionblock){
                _actionblock(weakSelf,DoneAction,indexPath,weakSelf.data[indexPath.row]);
            }
            // 收回左滑出现的按钮(退出编辑模式)
            tableView.editing = NO;
        }];
        
        action0.backgroundColor = kdayTypeExeBGColor;
        
        UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

            if(_actionblock){
                _actionblock(weakSelf,DeleteAction,indexPath,weakSelf.data[indexPath.row]);
            }
            // 收回左滑出现的按钮(退出编辑模式)
            tableView.editing = NO;
        }];
        
        return @[action1, action0];
    }

    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if(_actionblock){
            _actionblock(weakSelf,DeleteAction,indexPath,weakSelf.data[indexPath.row]);
        }
        // 收回左滑出现的按钮(退出编辑模式)
        tableView.editing = NO;
    }];
    
    return @[action1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissAlertView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WS(weakSelf);
    self.actionblock(weakSelf,EditAction,indexPath,weakSelf.data[indexPath.row]);
}



- (IBAction)addClick:(id)sender {
    [self dismissAlertView];
    if(self.addblock){
        self.addblock(sender);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *t = [touches anyObject];
    if (self == t.view){
        [self dismissAlertView];
    }
    
}

@end

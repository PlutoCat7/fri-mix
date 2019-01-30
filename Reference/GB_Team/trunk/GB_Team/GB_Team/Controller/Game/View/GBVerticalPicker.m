//
//  GBVerticalPicker.m
//  GB_Football
//
//  Created by Pizza on 16/8/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBVerticalPicker.h"
#import "GBVerticalCell.h"

@interface GBVerticalPicker () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GBVerticalPicker

#pragma mark - 初始化

/** 初始化方法，用于从代码中创建的类实例 */
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

/** 初始化方法，用于从代码中创建的类实例 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

/** 初始化方法，用于从xib文件中载入的类实例 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

/** 默认的初始化方法 */
- (void)defaultInit
{
    [self commonInitWithFont:[UIFont boldSystemFontOfSize:20.0]
                   textColor:[UIColor blackColor]
          unselectedRowScale:0.5
                   rowHeight:24
                 topRowCount:2
              bottomRowCount:2];
}

/** 通用初始化方法 */
- (void)commonInitWithFont:(UIFont *)font
                 textColor:(UIColor *)textColor
        unselectedRowScale:(CGFloat)unselectedRowScale
                 rowHeight:(CGFloat)rowHeight
               topRowCount:(NSUInteger)topRowCount
            bottomRowCount:(NSUInteger)bottomRowCount
{
    _selectedRowFont = font;
    _textColor = textColor;
    _unselectedRowScale = unselectedRowScale;
    _rowHeight = rowHeight;
    _topRowCount = topRowCount;
    _bottomRowCount = bottomRowCount;
}


#pragma mark - 绘制

/** 重新布局自窗口 */
- (void)layoutSubviews
{
    // tableView 的高度固定为，（（上方显示行数量+1）+（下方显示行数量+1）+ 当前行1）* 行高
    CGRect frame = CGRectMake(self.bounds.origin.x,
                              self.bounds.origin.y,
                              self.bounds.size.width,
                              _rowHeight * (_topRowCount+_bottomRowCount+3));
    
    if(self.tableView == nil)
    {
        self.tableView = [[UITableView alloc] initWithFrame:frame];
        self.tableView.delegate = self;    // 配置委托
        self.tableView.dataSource = self;  // 配置数据源
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 不显示分割线
        self.tableView.showsVerticalScrollIndicator = NO;   // 隐藏滚动条
        self.tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        // 立即刷新tableView数据
        [self.tableView reloadData];
    }
    
    // 初始化选择指定行
    [self selectRow:_selectedRow animated:NO];
    
    // 刷新tableView
    [self refreshPickerView:0];
    
    // 防止多次更新子视图位置
    if (CGRectEqualToRect(frame, self.tableView.frame))
        return;
    
    self.tableView.frame = frame;
}


#pragma mark - 属性

/** 当前选中行的序号 */
- (void)setSelectedRow:(NSUInteger)selectedRow
{
    if (selectedRow > _rowCount - 1)
    {
        selectedRow = _rowCount - 1;
    }
    _selectedRow = selectedRow;
    [self selectRow:selectedRow animated:NO];
}

/** 行高 */
- (void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
    [self.tableView reloadData];
}

/** 当前选中行的字体 */
- (void)setSelectedRowFont:(UIFont *)selectedRowFont
{
    _selectedRowFont = selectedRowFont;
    [self.tableView reloadData];
}

/** 字体颜色 */
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self.tableView reloadData];
}

/** 未选中行的字体缩放比例 */
- (void)setUnselectedRowScale:(CGFloat)unselectedRowScale
{
    _unselectedRowScale = unselectedRowScale;
    [self.tableView reloadData];
}

/** CLZoomPickerView实际占用的高度 */
- (CGFloat)fitHeight
{
    return _rowHeight * (_topRowCount+_bottomRowCount+3);
}


#pragma mark - pickerView 方法

/**
 *  刷新视图
 *
 *  @param rowOffset 行偏移量，>0为向上偏移，<0为向下偏移
 */
- (void)refreshPickerView:(CGFloat)rowOffset
{
    NSInteger currentRow = _selectedRow;
    
    // 记录需要重绘的cell，即视图中可见的cell
    NSMutableArray *refreshCells = [NSMutableArray array];
    [refreshCells addObject:@(currentRow)];
    for (NSInteger i = 1; i <= _topRowCount + 2; ++i)
    {
        if (currentRow - i >= 0)
            [refreshCells addObject:@(currentRow - i)];
        
    }
    for (NSInteger i = 1; i <= _bottomRowCount + 2; ++i)
    {
        if (currentRow + i < _rowCount)
            [refreshCells addObject:@(currentRow + i)];
    }
    
    // 刷新可见cell的透明度
    for (NSNumber *row in refreshCells)
    {
        NSInteger rowIndex = row.integerValue;
        GBVerticalCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
        
        if (currentRow == rowIndex) {
            cell.textColor = [UIColor whiteColor];
        }
        else
        {
            cell.textColor = [UIColor colorWithWhite:1 alpha:0.2];
        }
        
        
        // 视图内的行正常显示
        if (rowIndex > currentRow - _topRowCount &&
            rowIndex < currentRow + _bottomRowCount)
        {
            cell.alpha = 1;
        }
        
        // 上端边界行
        if (rowIndex == currentRow - _topRowCount)
        {
            if (rowOffset >= 0)
                cell.alpha = 1 - rowOffset / _rowHeight;
            else
                cell.alpha = 1;
        }
        
        // 上端边界行的上一行
        if (rowIndex == currentRow - _topRowCount - 1)
        {
            if (rowOffset < 0)
                cell.alpha = -rowOffset / _rowHeight;
            else
                cell.alpha = 0;
        }
        
        // 下端边界行
        if (rowIndex == currentRow + _bottomRowCount)
        {
            if (rowOffset < 0)
                cell.alpha = 1 + rowOffset / _rowHeight;
            else
                cell.alpha = 1;
        }
        
        // 下端边界行的下一行
        if (rowIndex == currentRow + _bottomRowCount + 1)
        {
            if (rowOffset >= 0)
                cell.alpha = rowOffset / _rowHeight;
            else
                cell.alpha = 0;
        }
        
        // 视图外的行不显示
        if (rowIndex < currentRow - (NSInteger)_topRowCount - 1 ||
            rowIndex > currentRow + (NSInteger)_bottomRowCount + 1)
        {
            cell.alpha = 0;
        }
    }
}

/** 选择指定行 */
- (void)selectRow:(NSInteger)row animated:(BOOL)animated
{
    NSInteger currentRow;
    
    if (row < 0)
        currentRow = 0;
    else if (row > _rowCount-1)
        currentRow = _rowCount-1;
    else
        currentRow = row;
    
    // 通过偏移来选择行
    const CGPoint alignedOffset = CGPointMake(0, currentRow * _rowHeight - _tableView.contentInset.top);
    [_tableView setContentOffset:alignedOffset animated:animated];
    
    // 没有动画效果则刷新显示
    if (animated == NO)
    {
        [self refreshPickerView:0];
        
        // 没有播放动画，则手动调用代理方法
        if([self.delegate respondsToSelector:@selector(pickerView:changedIndex:)])
        {
            [self.delegate pickerView:self changedIndex:_selectedRow];
        }
    }
}

/** 重新加载数据源 */
- (void)reloadData
{
    [self.tableView reloadData];
    [self refreshPickerView:0];
}



#pragma mark - tableView 数据源

/** 返回列数，默认为1 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/** 返回指定列的数据行数，默认为0 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _rowCount = 0;
    if([self.dataSource respondsToSelector:@selector(pickerView:)])
    {
        _rowCount = [self.dataSource pickerView:self];
    }
    
    return _rowCount;
}

/** 返回指定的Cell */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GBVerticalCell";
    
    // 创建cell
    GBVerticalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[GBVerticalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // 获取title
    NSString *title = @"";
    if([self.delegate respondsToSelector:@selector(pickerView:titleForRow:)])
    {
        title = [NSString stringWithFormat:@"%@", [self.delegate pickerView:self titleForRow:indexPath.row]];
    }
    cell.text = title;
    cell.font = _selectedRowFont;
    cell.textColor = _textColor;
    cell.alpha = 0.0;
    cell.transform = CGAffineTransformIdentity;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


#pragma mark - tableView 委托

/** 拖拽结束后调用 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        // 拖拽结束，且不存在惯性减速时调用
        [self selectRow:_selectedRow animated:YES];
    }
}

/** 惯性减速停止时调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self selectRow:_selectedRow animated:YES];
}

/** 滚动条正在滚动时触发，任何偏移的改变都将触发此方法 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取偏移量
    CGFloat relativeOffset = self.tableView.contentOffset.y + self.tableView.contentInset.top;
    
    // 偏移量范围[-_rowHeight, (self.rowCount+1)*_rowHeight]，这样便于首末行视图的缩放
    if (relativeOffset < -_rowHeight)
        relativeOffset = -_rowHeight;
    else if(relativeOffset > _rowCount*_rowHeight)
        relativeOffset = _rowCount*_rowHeight;
    
    // 获得当前行号
    NSInteger currentRow = (relativeOffset+_rowHeight*0.5) / _rowHeight;
    if (currentRow >= _rowCount)
    {
        currentRow = _rowCount-1;
    }
    
    // 当前行改变，调用代理方法
    if(_selectedRow != currentRow)
    {
        _selectedRow = currentRow;
        if([self.delegate respondsToSelector:@selector(pickerView:changedIndex:)])
        {
            [self.delegate pickerView:self changedIndex:_selectedRow];
        }
    }
    
    // 计算相对于每一行的行偏移量
    CGFloat rowOffset = relativeOffset - currentRow * _rowHeight;
    
    // 刷新视图
    [self refreshPickerView:rowOffset];
}

/** 行高 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _rowHeight;
}

/** 段首高度，用于把当前选择项放在中间 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _rowHeight * (_topRowCount+1);  // +1是为了完整显示即将消失的选项
}

/** 段脚高度，用于把当前选择项放在中间 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _rowHeight * (_bottomRowCount+1);   // +1是为了完整显示即将消失的选项
}

/** 段顶部视图颜色 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width,  _rowHeight * (_topRowCount+1))];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}

/** 段底部视图颜色 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, _rowHeight * (_bottomRowCount+1))];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}




@end

//
//  CatalogCollectionViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/13.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CatalogCollectionViewCell.h"
#import "CatalogSubTableViewCell.h"

@interface CatalogCollectionViewCell ()
<UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CatalogCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupTableView];
}

#pragma mark - Private

-(void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"CatalogSubTableViewCell" bundle:nil] forCellReuseIdentifier:@"CatalogSubTableViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)setItems:(NSArray<CatalogModel *> *)items {
    
    _items = items;
    [self.tableView reloadData];
}

#pragma mark - Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CatalogSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CatalogSubTableViewCell"];
    CatalogModel *model = self.items[indexPath.row];
    cell.catalogTitleLabel.text = model.title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kSubCatalogCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelectedWithIndex:cell:)]) {
        [self.delegate didSelectedWithIndex:indexPath.row cell:self];
    }
}

#pragma mark EmptyView Delegate

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return 63.0f*kAppScale;
}


@end

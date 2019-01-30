//
//  AddTallyViewCategoryCell.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddTallyViewCategoryCell.h"
#import "TallyCategoryView.h"

@interface AddTallyViewCategoryCell()<TallyCategoryViewDelegate>
@property (weak, nonatomic) TallyCategoryView *tallyCategoryView;
//@property (assign, nonatomic) BOOL hasData;
@end

@implementation AddTallyViewCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = XWColorFromHex(0xf8f8f8);
        self.contentView.clipsToBounds = YES;
        
        TallyCategoryView *tallyCategoryView = [[TallyCategoryView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:tallyCategoryView];
        tallyCategoryView.clipsToBounds = YES;
        self.tallyCategoryView = tallyCategoryView;
        tallyCategoryView.delegate = self;
        [tallyCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)setData:(NSArray<TallyCategory *> *)data {
    if (!data || data.count == 0) {
        return;
    }

    _data = data;
    [self.tallyCategoryView show: data];
}

- (void)setCategoryId:(NSInteger)cateoneid catetwoid:(NSInteger)catetwoid catethreeid:(NSInteger)catethreeid {
    self.tallyCategoryView.catethreeid = catethreeid;
    self.tallyCategoryView.cateoneid = cateoneid;
    self.tallyCategoryView.catetwoid = catetwoid;
}

#pragma mark - TallyCategoryViewDelegate
- (void)tallyCategoryAddProjectAction:(NSInteger)catetwoid {
    if (_delegate && [_delegate respondsToSelector:@selector(addTallyViewCategoryCellAddProjectAction:catetwoid:)]) {
        [_delegate addTallyViewCategoryCellAddProjectAction:self catetwoid:catetwoid];
    }
}

- (void)refreshCellHeight:(CGFloat)height {
    _cellHeight = height;
    
    id<AddTallyViewCategoryCellDelegate> delegate = (id<AddTallyViewCategoryCellDelegate>)self.tableView.delegate;
    
    CGFloat newHeight = [self cellHeight];
    CGFloat oldHeight = [delegate tableView:self.tableView heightForRowAtIndexPath:self.indexPath];
    if (fabs(newHeight - oldHeight) > 0.01) {
        
        // update the height
        if ([delegate respondsToSelector:@selector(tableView:updatedHeight:atIndexPath:)]) {
            [delegate tableView:self.tableView
                  updatedHeight:newHeight
                    atIndexPath:self.indexPath];
        }
        
        // refresh 
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

- (void)didSelected:(TallyCategory *)firstCategory secondCategory:(TallySecondCategoryModel *)secondCategory thridCategory:(TallyThridCategoryModel *)thridCategory {
    
    _category1 = firstCategory;
    _category2 = secondCategory;
    _category3 = thridCategory;
    
    NSString *str = @"";
    
    if (thridCategory) {
        str = [NSString stringWithFormat:@"%@",thridCategory.catename];
        
        if (secondCategory) {
            str = [NSString stringWithFormat:@"%@-%@", str, secondCategory.catetwoname];
            
            if (firstCategory) {
                str = [NSString stringWithFormat:@"%@·%@",str, firstCategory.cateonename];
            }
        } else {
            str = [NSString stringWithFormat:@"%@-%@",str, firstCategory.cateonename];
        }
        
        
    } else {
        if (secondCategory) {
            str = [NSString stringWithFormat:@"%@", secondCategory.catetwoname];
            if (firstCategory) {
                str = [NSString stringWithFormat:@"%@-%@",str, firstCategory.cateonename];
            }
        } else {
            if (firstCategory) {
                str = [NSString stringWithFormat:@"%@", firstCategory.cateonename];
            }
        }
        
    }

    if ([_delegate respondsToSelector:@selector(addTallyViewCategoryCellSelected:categoryStr:)]) {
        [_delegate addTallyViewCategoryCellSelected:self categoryStr:str];
    }
}

-(void) setDisabled:(BOOL)disabled {
    _tallyCategoryView.userInteractionEnabled = NO;
}

@end

@implementation UITableView (AddTallyViewCategoryCell)

- (AddTallyViewCategoryCell *)addTallyViewCategoryCellWithId:(NSString *)cellId {
    AddTallyViewCategoryCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[AddTallyViewCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tableView = self;
    return cell;
}

@end

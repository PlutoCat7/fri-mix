//
//  RemindPeopleView.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RemindPeopleView.h"
#import "RemindPeopleCell.h"
#import "NewHousePersonModel.h"
#import "RemindPeopleCollectionCell.h"
#import "Login.h"

@interface RemindPeopleView ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewConstraintHeight;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) UICollectionView *collectionView;

//列表数据数组
@property (strong, nonatomic) NSArray * dataArray;

//model
@property (strong, nonatomic) House * house;

@end

@implementation RemindPeopleView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel withHouse:(House *)house {
    
    RemindPeopleView * remindPeopleView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    remindPeopleView.house = house;
    
    [remindPeopleView xl_setupViews];
    [remindPeopleView xl_bindViewModel];
    
    return remindPeopleView;
}

-(void)xl_setupViews {
    
    //tableView
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //一开始已选项为空，设置高度
    self.headViewConstraintHeight.constant = 1;
    [self updateConstraints];
    
    //注册collection
    [self.headView addSubview:self.collectionView];
}

-(void)xl_bindViewModel {
    
    NSAssert(self.house, @"house 数据模型为nil");
    
    [self beginLoading];
    
    //获取亲友列表数据
    WS(weakSelf);
    [[TiHouse_NetAPIManager sharedManager] request_FindersWithHouse:self.house Block:^(id data, NSError *error) {
        [weakSelf endLoading];
        
        NSArray * array = [NewHousePersonModel mj_objectArrayWithKeyValuesArray:data];
        NSMutableArray * mutableArray = [[NSMutableArray alloc] init];
        User *user = [Login curLoginUser];
        for (NewHousePersonModel * personModel in array) {
            //过滤自己
            if (personModel.uidconcert != user.uid) {
                [mutableArray addObject:personModel];
            }
        }
        weakSelf.dataArray = mutableArray;
        
        //编辑状态
        if (weakSelf.schedulearruidtip) {
            NSArray * array = [weakSelf.schedulearruidtip componentsSeparatedByString:@","];
            for (int i = 0; i < array.count; i++) {
                NSString * uid = array[i];
                for (int j = 0; j < weakSelf.dataArray.count; j++) {
                    NewHousePersonModel * user = weakSelf.dataArray[j];
                    if ([uid intValue] == user.uidconcert) {
                        user.selected = YES;
                        break;
                    }
                }
            }
            
            [weakSelf addSelectPeople];
        } else {
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - UICollectionView Delegate & datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectPeopleArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDCell = @"RemindPeopleCollectionCell";
    RemindPeopleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDCell forIndexPath:indexPath];
    
    NewHousePersonModel * user = self.selectPeopleArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:user.urlhead] placeholderImage:nil];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * cellID = @"RemindPeopleCell";
    RemindPeopleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindPeopleCell" owner:nil options:nil] firstObject];
    }
    
    NewHousePersonModel * user = self.dataArray[indexPath.row];
    cell.titleLabel.text = user.nickname;
    [cell.photoImg sd_setImageWithURL:[NSURL URLWithString:user.urlhead] placeholderImage:nil];
    cell.remarkBtn.selected = user.selected;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewHousePersonModel * user = self.dataArray[indexPath.row];
    if (user.selected) {
        user.selected = NO;
        
    } else {
        user.selected = YES;
    }
    
    [self addSelectPeople];
}

-(void)addSelectPeople {
    
    //添加所有所选项
    [self.selectPeopleArray removeAllObjects];
    for (NewHousePersonModel * user in self.dataArray) {
        if (user.selected) {
            [self.selectPeopleArray addObject:user];
        }
    }
    
    [self.collectionView reloadData];
    [self.tableView reloadData];
    
    //根据判断设置头部高度
    if (self.selectPeopleArray.count > 0) {
        self.headViewConstraintHeight.constant = 55;
    } else {
        self.headViewConstraintHeight.constant = 1;
    }
    [self updateConstraints];
}

#pragma mark - get fun
-(UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(45, 45);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 5, kScreen_Width - 5, 45) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"RemindPeopleCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"RemindPeopleCollectionCell"];
    }
    
    return _collectionView;
}

#pragma mark - set fun
-(void)setSchedulearruidtip:(NSString *)schedulearruidtip {
    _schedulearruidtip = schedulearruidtip;
    
//    NSArray * array = [schedulearruidtip componentsSeparatedByString:@","];
//    for (int i = 0; i < array.count; i++) {
//        NSString * uid = array[i];
//        for (int j = 0; j < self.dataArray.count; j++) {
//            NewHousePersonModel * user = self.dataArray[j];
//            if ([uid intValue] == user.uidconcert) {
//                user.selected = YES;
//                break;
//            }
//        }
//    }
//
//    [self addSelectPeople];
}

-(NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableArray *)selectPeopleArray {
    if (!_selectPeopleArray) {
        _selectPeopleArray = [[NSMutableArray alloc] init];
    }
    return _selectPeopleArray;
}

@end

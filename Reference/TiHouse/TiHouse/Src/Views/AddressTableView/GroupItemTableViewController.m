//
//  GroupItemTableViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/17.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "GroupItemTableViewController.h"
#import "ItemTableViewCell.h"
#import "ItemModel.h"
#import "Province.h"

@interface GroupItemTableViewController ()

@property (nonatomic, retain) ItemTableViewCell *currentCell;

@end

@implementation GroupItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[ItemTableViewCell class] forCellReuseIdentifier:@"item"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [_Addres.address[_item] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item"];
    cell.model = _Addres.address[_item][indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_Addres.address[_item] enumerateObjectsUsingBlock:^(ItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelect = NO;
    }];
    
    if ([_Addres.address[_item][indexPath.row] isKindOfClass:[Province class]]) {
        _Addres.province =     _Addres.address[_item][indexPath.row];
        _Addres.item     =     _Addres.address[_item][indexPath.row];
    }
    if ([_Addres.address[_item][indexPath.row] isKindOfClass:[City class]]) {
        _Addres.city = _Addres.address[_item][indexPath.row];
        _Addres.item = _Addres.address[_item][indexPath.row];
    }
    if ([_Addres.address[_item][indexPath.row] isKindOfClass:[Region class]]) {
        _Addres.region = _Addres.address[_item][indexPath.row];
        _Addres.item   =   _Addres.address[_item][indexPath.row];
    }
    
    if (_SelectedItem) {
        _SelectedItem(_item);
    }
    
    ItemModel *model = _Addres.address[_item][indexPath.row];
    model.isSelect = YES;
    [self.tableView reloadData];
    
}

-(void)setAddres:(AddresManager *)Addres{
    
    _Addres = Addres;
    [self.tableView reloadData];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

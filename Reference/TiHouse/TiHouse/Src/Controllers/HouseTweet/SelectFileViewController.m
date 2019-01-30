//
//  HouseChangeViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//
#define kCCellIdentifier_File @"TweetSendImageCCell"
#import "SelectFileViewController.h"
#import "FileCell.h"
#import "Folder.h"
#import "House.h"

@interface SelectFileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *fileView;
@property (strong, nonatomic) UITextField *addFileTextField;
@property (assign, nonatomic) BOOL edit;

@end

@implementation SelectFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        _fileView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        self.automaticallyAdjustsScrollViewInsets = YES;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.title = @"选择文件夹";
    self.view.backgroundColor = [UIColor whiteColor];
    _edit = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    
    [self fileView];
    if (!_files) {
        [self requestFlies];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
-(void)finish{
    
    _edit = !_edit;
    
    if (_edit) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    }
    
    [_fileView reloadData];
}

-(void)requestFlies{
    WEAKSELF
    if (_files.count == 0) {
        [self.view beginLoading];
    }
    [[TiHouse_NetAPIManager sharedManager] request_FilesBlockWith:_house Block:^(id data, NSError *error) {
        [self.view endLoading];
        if (data) {
            weakSelf.files = data;
            [weakSelf.fileView reloadData];
        }
    }];
}
-(void)addFlie{
    WEAKSELF
    [NSObject showHUDQueryStr:@"添加文件夹"];
    [[TiHouse_NetAPIManager sharedManager] request_WithPath:@"api/inter/folder/add" Params:@{@"foldername":_addFileTextField.text,@"houseid":@(_house.houseid)} Block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"添加成功"];
            [weakSelf requestFlies];
        }
    }];
}

-(void)DeleteFlieWithFolderid:(long)folderid{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_WithPath:@"api/inter/folder/remove" Params:@{@"folderid":[NSString stringWithFormat:@"%ld",folderid] ,@"houseid":@(_house.houseid)} Block:^(id data, NSError *error) {
        if (data) {
            [NSObject showHudTipStr:@"删除成功"];
            [weakSelf requestFlies];
        }
    }];
}

-(void)ChgangeFileName:(NSString *)name Folderid:(long)folderid{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_WithPath:@"api/inter/folder/edit" Params:@{@"foldername":name,@"folderid":[NSString stringWithFormat:@"%ld",folderid]} Block:^(id data, NSError *error) {
        if (data) {
            [weakSelf requestFlies];
        }
    }];
}


#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //    NSInteger num = _curTweet.tweetImages.count;
    return _files.count +1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    FileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_File forIndexPath:indexPath];
    cell.eidt = NO;
    if (indexPath.row<_files.count) {
        Folder *folder = _files[indexPath.row];
        cell.imageV.image = [UIImage imageNamed:@"file_icon_all"];
        cell.folder = folder;
        if (cell.folder.foldertype == 2) {
            cell.eidt = _edit;
        }
    }else{
        cell.imageV.image = [UIImage imageNamed:@"addfile_icon"];
        cell.folder = nil;
    }
    if (!_edit) {
        cell.eidt = NO;
    }
    cell.titleChange = ^(FileCell *cella) {
        [weakSelf ChgangeFileName:cella.title.text Folderid:cella.folder.folderid];
    };
    cell.deleFile = ^(FileCell *cella) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要永远删除该文件夹吗？\n删除后，文件夹的文件将移到“默认”文件夹" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf DeleteFlieWithFolderid:cella.folder.folderid];
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_edit) {
        return;
    }
    WEAKSELF
    if (indexPath.row == _files.count) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加文件夹" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf addFlie];
        }];
        WEAKSELF
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            weakSelf.addFileTextField = textField;
        }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (_selectdeFoder) {
        _selectdeFoder(_files[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreen_Width-kRKBWIDTH(10*5))/4, 100);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kRKBWIDTH(10), kRKBWIDTH(10), kRKBWIDTH(10));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kRKBWIDTH(10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kRKBWIDTH(10);
}


#pragma mark - getters and setters
-(UICollectionView *)fileView{
    if (!_fileView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _fileView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _fileView.backgroundColor = [UIColor whiteColor];
        _fileView.scrollEnabled = NO;
        [_fileView setBackgroundView:nil];
        [_fileView setBackgroundColor:[UIColor clearColor]];
        [_fileView registerClass:[FileCell class] forCellWithReuseIdentifier:kCCellIdentifier_File];
        _fileView.dataSource = self;
        _fileView.delegate = self;
        [self.view addSubview:_fileView];
        [_fileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(IphoneX ? 88 : 64, 0, 0, 0));
        }];
    }
    return _fileView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

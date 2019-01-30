//
//  GBPersonPositionSetting.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/8/1.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPersonPositionSetting.h"
#import "GBPostionItem.h"
#import "GBHightLightButton.h"
#import "RTLabel.h"

@interface GBPersonPositionSetting ()
@property (strong, nonatomic) IBOutletCollection(GBPostionItem) NSArray *positonItemCollection;
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;

@property (weak, nonatomic) IBOutlet RTLabel *selectHintStLbl;

@property (nonatomic, strong) NSMutableArray<NSString *> *selectIndexList;

@end

@implementation GBPersonPositionSetting

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

- (void)localizeUI {
    self.selectHintStLbl.text = LS(@"position.label.choose");
    self.selectHintStLbl.textAlignment = RTTextAlignmentCenter;
    self.selectHintStLbl.font = FONT_ADAPT(14.f);
    
}

- (instancetype)initWithSelectList:(NSArray<NSString *> *)selectList {
    
    if(self=[super init]){
        self.selectIndexList = [NSMutableArray arrayWithArray:selectList];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Notification

#pragma mark - Delegate

#pragma mark - Action

- (IBAction)okButtonAction:(id)sender {
    
    BLOCK_EXEC(self.saveBlock, [self.selectIndexList copy]);
    [self.navigationController yh_popViewController:self animated:YES];
}

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"position.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self.positonItemCollection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GBPostionItem *item = obj;
        @weakify(self)
        [item.button addActionHandler:^(NSInteger tag) {
            
            @strongify(self)
            if (self.selectIndexList.count == 1 && !item.selected && [self.selectIndexList firstObject].integerValue < self.positonItemCollection.count) {
                NSInteger number = [self.selectIndexList firstObject].integerValue;
                for (GBPostionItem *oldItem in self.positonItemCollection) {
                    if (oldItem.tag == number) {
                        oldItem.selected = !oldItem.selected;
                        [self.selectIndexList removeObject:@(oldItem.tag).stringValue];
                        break;
                    }
                }
                
            }
            
            if (item.selected) {
                [self.selectIndexList removeObject:@(item.tag).stringValue];
            }else {
                [self.selectIndexList addObject:@(item.tag).stringValue];
            }
            item.selected = !item.selected;
            self.okButton.enabled = (self.selectIndexList.count == 1);
        }];
    }];
    
    [self.positonItemCollection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GBPostionItem *item = obj;
        for (NSString *number in self.selectIndexList) {
            if (item.tag==number.integerValue) {
                item.selected = YES;
                break;
            }else {
                item.selected = NO;
            }
        }
    }];
}

-(void)loadData
{
}

#pragma mark - Getters & Setters

@end

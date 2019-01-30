//
//  GBSearchBar.m
//  GB_Video
//
//  Created by gxd on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBSearchBar.h"
#import "XXNibBridge.h"

@interface GBSearchBar()<XXNibBridge>

@end

@implementation GBSearchBar

-(void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)actionSearch:(id)sender {
    BLOCK_EXEC(self.actionSearch);
}

- (IBAction)actionPerson:(id)sender {
    BLOCK_EXEC(self.actionPerson);
}

@end

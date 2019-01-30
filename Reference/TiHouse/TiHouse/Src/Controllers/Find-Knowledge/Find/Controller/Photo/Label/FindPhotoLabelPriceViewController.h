//
//  FindPhotoLabelPriceViewController.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"

@interface FindPhotoLabelPriceViewController : FindKnowledgeBaseViewController

- (instancetype)initWithPlaceholder:(NSString *)placeholder text:(NSString *)text doneBlock:(void(^)(NSString *inputName))doneBlock;

@end

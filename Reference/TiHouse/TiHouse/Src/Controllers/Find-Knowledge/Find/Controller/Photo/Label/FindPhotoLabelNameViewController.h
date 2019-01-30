//
//  FindPhotoLabelDesc2ViewController.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"

@interface FindPhotoLabelNameViewController : FindKnowledgeBaseViewController

- (instancetype)initWithPlaceholder:(NSString *)placeholder text:(NSString *)text isBrand:(BOOL)isBrand doneBlock:(void(^)(NSString *inputName))doneBlock;

@end

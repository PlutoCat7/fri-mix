//
//  FindPhotoLabelDesc1ViewController.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"

@interface FindPhotoLabelAddViewController : FindKnowledgeBaseViewController

- (instancetype)initWithDoneBlock:(void(^)(NSString *thingName, NSString *brand, NSString *price))doneBlock;

@end

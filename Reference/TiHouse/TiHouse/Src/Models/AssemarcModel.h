//
//  AssemarcModel.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssemarccommModel.h"
#import "FindPhotoLabelModel.h"

@interface AssemarcModel : NSObject

@property (nonatomic, assign) long assemarcid;
@property (nonatomic, copy) NSString *urlindex, *assemarccontent;
@property (nonatomic, assign) NSInteger assemarctype, logassemarcopetype, assemarcnumzan, assemarcnumcomm;
@property (nonatomic, assign) long assemarcctime, createtime, updatetime;
@property (nonatomic, assign) int assemarcstatus, assemarciscoll, assemarciszan;
@property (nonatomic, assign) long assemarcuid;
@property (nonatomic, strong) AssemarccommModel *listModelAssemarccomm;
@property (nonatomic, copy) NSString *urlhead, *username, *urlheadon, *usernameon, *urlsoulfilearr, *assemarcfiletagJson, *assemarctitle;
@property (nonatomic, assign) double assemarcpicwidth, assemarcpicheigh;
@property (nonatomic, assign) long assemfiletagid, assemfileid;
@property (nonatomic, copy) NSString *assemfiletagcontent;
@property (nonatomic, assign) double assemfiletagwper;
@property (nonatomic, copy) NSString *assemfiletaghper;
@property (nonatomic, assign) int assemfiletagside;
@property (nonatomic, copy) NSString *assemtitle;

// 文章页面的引导语(sub title)
@property (nonatomic, copy) NSString *assemarctitlesub;

- (NSDictionary<NSString *, NSArray<FindPhotoLabelModel *> *> *)getLabelsDictionary;
@end

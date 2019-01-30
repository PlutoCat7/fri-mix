//
//  PhotoFavorPan.h
//  TiHouse
//
//  Created by weilai on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoulFolderResponse.h"
#import "FindKnowledgeBaseViewController.h"

@class PhotoFavorPan;

@protocol PhotoFavorPanDelegate <NSObject>
- (void)PhotoFavorPanAction:(PhotoFavorPan*)pan index:(NSInteger)index;
- (void)PhotoFavorPanActionCancel:(PhotoFavorPan*)pan;
- (void)PhotoFavorPanActionAdd:(PhotoFavorPan*)pan;
@optional
- (void)PhotoFavorPanActionWillShow:(PhotoFavorPan*)pan;
- (void)PhotoFavorPanActionWillHide:(PhotoFavorPan*)pan;
@end

@interface PhotoFavorPan : UIView

@property (strong, nonatomic) NSMutableArray<SoulFolderInfo *> *floderArray;

@property (weak, nonatomic) id<PhotoFavorPanDelegate> delegate;
+(PhotoFavorPan*)showPhotoFavorPanWithDelegate:(NSArray <SoulFolderInfo *> *)folderArray delegate:(id<PhotoFavorPanDelegate>)delegate vc:(FindKnowledgeBaseViewController *)vc;
-(void)hide:(void(^)(BOOL success))complete;


@end

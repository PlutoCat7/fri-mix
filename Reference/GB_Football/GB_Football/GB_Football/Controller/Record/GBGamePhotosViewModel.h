//
//  GBGamePhotosViewModel.h
//  GB_Football
//
//  Created by yahua on 2017/12/15.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBGamePhotosCellModel : NSObject

@property (nonatomic, copy) NSString *url; //图片或者视频url
@property (nonatomic, assign) NSInteger state;  //0:图片  1:视频

//缓存
@property (nonatomic, strong) UIImage *photoImage; //图片image
@property (nonatomic, strong) UIImage *videoImage; //视频image

@end

@interface GBGamePhotosSectionModel : NSObject

@property (nonatomic, copy) NSString *sectionName;
@property (nonatomic, strong) NSArray<GBGamePhotosCellModel *> *cellModels;

@end

@interface GBGamePhotosViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray<GBGamePhotosSectionModel *> *sectionModels;

- (instancetype)initWithMatchId:(NSInteger)matchId;

- (void)requestNetworkData:(void(^)(NSError *error))complete;

@end

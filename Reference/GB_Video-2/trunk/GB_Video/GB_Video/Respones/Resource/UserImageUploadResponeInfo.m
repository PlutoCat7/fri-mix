//
//  UserImageUploadResponeInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UserImageUploadResponeInfo.h"

@implementation UserImageUploadInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"imageName":@"image_name"};
}

- (NSString *)realImageurl {
    
    return [NSString stringWithFormat:@"%@%@", self.base_url, self.imageName];
}

@end


@implementation UserImageUploadResponeInfo

@end

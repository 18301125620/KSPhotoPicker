//
//  NSArray+PHAsset_KSPhoto.m
//  test
//
//  Created by Mr.kong on 2017/2/22.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "NSArray+PHAsset_KSPhoto.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
@implementation KSPhotoRequestImageOption
@end


@implementation NSArray (PHAsset_KSPhoto)
- (void)requestImageWithOption:(KSPhotoRequestImageOption *)option
                      progress:(KSPhotoRequestImageProgressHandle)progress
                      complete:(KSPhotoRequestImageCompleteHandle)complete{
    
    NSMutableArray<UIImage*>* images = [NSMutableArray array];
    PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            PHAsset* asset = (PHAsset*)obj;
            
            @autoreleasepool {
                [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                                  targetSize:PHImageManagerMaximumSize
                                                                 contentMode:PHImageContentModeDefault
                                                                     options:options
                                                               resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                                   
                                                                   [images addObject:result];
                                                                   
                                                                   if (progress) {
                                                                       progress(asset,result);
                                                                   }
                                                               }];
            }
        }
    }];
    
    if (complete) {
        complete(images);
    }
}

@end

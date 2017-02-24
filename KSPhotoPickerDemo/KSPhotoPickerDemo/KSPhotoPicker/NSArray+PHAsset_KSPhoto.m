//
//  NSArray+PHAsset_KSPhoto.m
//  test
//
//  Created by Mr.kong on 2017/2/22.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "NSArray+PHAsset_KSPhoto.h"
#import <Photos/Photos.h>
#import "PHAsset+KSPhoto.h"
#import <objc/runtime.h>

static char * const kCacheKey = "kCacheKey";

@implementation KSPhotoRequestImageOption
@end


@implementation NSArray (PHAsset_KSPhoto)
- (void)requestImageWithOption:(KSPhotoRequestImageOption *)option
                      progress:(KSPhotoRequestImageProgressHandle)progress
                      complete:(KSPhotoRequestImageCompleteHandle)complete{

    __weak typeof(self) weakSelf = self;
    double startTime = CFAbsoluteTimeGetCurrent();
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        PHImageRequestOptions* options              = [[PHImageRequestOptions alloc] init];
        options.resizeMode                          = PHImageRequestOptionsResizeModeExact;
        options.synchronous                         = option.synchronous;
        
        CFStringRef keys[4];
        CFNumberRef values[4];
        
        keys[0]                                     = kCGImageSourceCreateThumbnailFromImageIfAbsent;
        values[0]                                   = (__bridge CFNumberRef)(@(NO));
        
        keys[1]                                     = kCGImageSourceThumbnailMaxPixelSize;
        values[1]                                   = (__bridge CFNumberRef)(@(option.thumbnailMaxPixelSize));
        
        keys[2]                                     = kCGImageSourceCreateThumbnailWithTransform;
        values[2]                                   = (__bridge CFNumberRef)(@(YES));
        
        keys[3]                                     = kCGImageSourceCreateThumbnailFromImageAlways;
        values[3]                                   = (__bridge CFNumberRef)(@(YES));
        
        CFDictionaryRef optionRef                   = CFDictionaryCreate(kCFAllocatorDefault, (void*)keys, (void*)values, 4, nil, nil);
        dispatch_group_t imageGroup                 = dispatch_group_create();
        
        [weakSelf enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PHAsset class]]) {
                PHAsset* phAsset                    = (PHAsset*)obj;
                
                dispatch_group_enter(imageGroup);
                @autoreleasepool {
                    
                    NSLog(@"单个开始:%d",idx);

                    [[PHCachingImageManager defaultManager] requestImageDataForAsset:phAsset
                                                                             options:options
                                                                       resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                                           
                                                                            dispatch_async(dispatch_get_global_queue(0,0), ^{
                                                                                
                                                                                UIImage* originImage    = [UIImage imageWithData:imageData];
                                                                                UIImage* thumbImage     = [self thumbImageWithData:imageData option:optionRef];
 
                                                                                phAsset.originImage     = originImage;
                                                                                phAsset.thumbImage      = thumbImage;
                                                                                
                                                                                dispatch_group_t videoGroup = dispatch_group_create();

                                                                                if (phAsset.mediaType != PHAssetMediaTypeVideo) {
                                                                                    
                                                                                    phAsset.url         = info[@"PHImageFileURLKey"];
                                                                                    
                                                                                }else{
                                                                                    dispatch_group_enter(videoGroup);
                                                                                    dispatch_group_enter(imageGroup);
                                                                                    
                                                                                    [[PHCachingImageManager defaultManager] requestAVAssetForVideo:phAsset
                                                                                                                                           options:nil
                                                                                                                                     resultHandler:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                                                                                                                         
                                                                                                                                         phAsset.url = ((AVURLAsset*)avAsset).URL;
                                                                                                                                         
                                                                                                                                         dispatch_group_leave(videoGroup);
                                                                                                                                         dispatch_group_leave(imageGroup);

                                                                                    }];
                                                                                }
                                                                                
                                                                                dispatch_group_notify(videoGroup, dispatch_get_main_queue(), ^{
                                                                                    NSLog(@"单个回调:%d",idx);
                                                                                    if (progress) {
                                                                                        progress(phAsset);
                                                                                    }
                                                                                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                                                                        dispatch_group_leave(imageGroup);
                                                                                    });
                                                                                });
                                                                                
                                                                            });
                                                                           
                    }];
                }
            }
        }];
        
        dispatch_group_notify(imageGroup, dispatch_get_global_queue(0, 0), ^{
            CFRelease(optionRef);

            NSLog(@"耗时:%f",CFAbsoluteTimeGetCurrent() - startTime);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"结束回调");
                if (complete) {
                    complete(weakSelf);
                }
            });
        });
    });
}


- (UIImage*)thumbImageWithData:(NSData*)imageData option:(CFDictionaryRef)option{
    
    CFDataRef dataRef                   = CFBridgingRetain(imageData);
    CGImageSourceRef imageSourceRef     = CGImageSourceCreateWithData(dataRef, NULL);
    CGImageRef thumbImageRef            = CGImageSourceCreateThumbnailAtIndex(imageSourceRef, 0, option);
    
    UIImage* thumbImage                 = [UIImage imageWithCGImage:thumbImageRef];
    
    CFBridgingRelease(dataRef);
    CFRelease(imageSourceRef);
    CGImageRelease(thumbImageRef);
    
    return thumbImage;
}

//- (NSCache*)cache{
//    NSCache* cache = objc_getAssociatedObject(self, kCacheKey);
//    if (!cache) {
//        cache = [[NSCache alloc] init];
//        objc_setAssociatedObject(self, kCacheKey, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    
//    return cache;
//}

@end

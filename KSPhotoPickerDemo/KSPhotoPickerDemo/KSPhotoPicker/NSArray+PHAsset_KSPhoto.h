//
//  NSArray+PHAsset_KSPhoto.h
//  test
//
//  Created by Mr.kong on 2017/2/22.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHAsset;
@class UIImage;

typedef void(^KSPhotoRequestImageProgressHandle)(PHAsset* asset);
typedef void(^KSPhotoRequestImageCompleteHandle)(NSArray<PHAsset*>* assets);

@interface KSPhotoRequestImageOption : NSObject

/**
 缩略图的宽高最大值
 */
@property (nonatomic, assign) float thumbnailMaxPixelSize;

/**
 是否同步获取图片
 */
@property (nonatomic, assign) BOOL synchronous;

//@property (nonatomic, assign) bool  cache;

@end


@interface NSArray (PHAsset_KSPhoto)

- (void)requestImageWithOption:(KSPhotoRequestImageOption*)option
                      progress:(KSPhotoRequestImageProgressHandle)progress
                      complete:(KSPhotoRequestImageCompleteHandle)complete;

@end

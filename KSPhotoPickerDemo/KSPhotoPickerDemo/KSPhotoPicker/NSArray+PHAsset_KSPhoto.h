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
@property (nonatomic, assign) float thumbnailMaxPixelSize;
@property (nonatomic, assign) bool  synchronous;
//@property (nonatomic, assign) bool  cache;

@end


@interface NSArray (PHAsset_KSPhoto)

- (void)requestImageWithOption:(KSPhotoRequestImageOption*)option
                      progress:(KSPhotoRequestImageProgressHandle)progress
                      complete:(KSPhotoRequestImageCompleteHandle)complete;

@end

//
//  PHAsset+KSPhoto.m
//  KSPhotoPickerDemo
//
//  Created by Mr.kong on 2017/2/24.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "PHAsset+KSPhoto.h"
#import <objc/runtime.h>

static char* const kPHAssetOriginImage  = "kPHAssetOriginImage";
static char* const kPHAssetThumbImage   = "kPHAssetThumbImage";
static char* const kPHAssetUrl          = "kPHAssetUrl";

@implementation PHAsset (KSPhoto)

- (UIImage *)originImage{
    return objc_getAssociatedObject(self,
                                    kPHAssetOriginImage);
}
- (void)setOriginImage:(UIImage *)originImage{
    objc_setAssociatedObject(self,
                             kPHAssetOriginImage,
                             originImage,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)thumbImage{
    return objc_getAssociatedObject(self,
                                    kPHAssetThumbImage);
}
- (void)setThumbImage:(UIImage *)thumbImage{
    objc_setAssociatedObject(self,
                             kPHAssetThumbImage,
                             thumbImage,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL *)url{
    return objc_getAssociatedObject(self,
                                    kPHAssetUrl);
}
- (void)setUrl:(NSURL *)url{
    objc_setAssociatedObject(self,
                             kPHAssetUrl,
                             url,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

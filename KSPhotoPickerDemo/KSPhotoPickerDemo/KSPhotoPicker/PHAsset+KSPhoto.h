//
//  PHAsset+KSPhoto.h
//  KSPhotoPickerDemo
//
//  Created by Mr.kong on 2017/2/24.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (KSPhoto)


/**
 原大小图片
 */
@property (nonatomic, strong) UIImage* originImage;

/**
 MAX(width,height) == thumbnailMaxPixelSize 缩略图
 */
@property (nonatomic, strong) UIImage* thumbImage;


/**
 路径 图片类型的url 是未知的，或者获取不到资源，就是说没什么用
 */
@property (nonatomic, strong) NSURL* url;

@end

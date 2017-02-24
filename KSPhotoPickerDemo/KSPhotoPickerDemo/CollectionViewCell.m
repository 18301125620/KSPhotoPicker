//
//  CollectionViewCell.m
//  KSPhotoPickerDemo
//
//  Created by Mr.kong on 2017/2/24.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.imageView.image = asset.thumbImage;
    });
}

@end

NSString * const CollectionViewCellID = @"CollectionViewCellID";

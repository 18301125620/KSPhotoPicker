//
//  KSPhotoUtil.h
//  test
//
//  Created by Mr.kong on 2017/2/19.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSPhotoUtil : NSObject

@end

@class PHAsset;

typedef void(^KSPhotoPickerCancelHandle)(NSMutableArray<PHAsset*>* assets);
typedef void(^KSPhotoPickerCommitHandle)(NSMutableArray<PHAsset*>* assets);


/**
 size * scale

 @param size size
 @param scale scale
 @return CGSizeMake(size.width * scale, size.height * scale)
 */
CG_INLINE CGSize
KSSizeMake(CGSize size, CGFloat scale){
    return CGSizeMake(size.width * scale, size.height * scale);
}


/**
 size * screenScale

 @param size size
 @return CGSizeMake(size.width * [UIScreen mainScreen].scale, 
                    size.height * [UIScreen mainScreen].scale)
 */
CG_INLINE CGSize
KSSizeScreenScale(CGSize size){
    return KSSizeMake(size, [UIScreen mainScreen].scale);
}


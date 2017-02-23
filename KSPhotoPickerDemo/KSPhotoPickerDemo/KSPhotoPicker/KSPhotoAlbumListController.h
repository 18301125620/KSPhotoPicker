//
//  KSPhotoAlbumListController.h
//  test
//
//  Created by Mr.kong on 2017/2/15.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

//相册列表

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "KSPhotoUtil.h"
#import "KSPhotoPickerProtocal.h"

@interface KSPhotoAlbumListController : UIViewController

@property (nonatomic, strong) __kindof NSArray<PHAsset*>        * photos;

@property (nonatomic, copy) KSPhotoPickerCommitHandle           commitHandle;
@property (nonatomic, copy) KSPhotoPickerCancelHandle           cancelHandle;

@property (nonatomic, weak) id<KSPhotoPickerProtocal>           delegate;

@end

//
//  KSPhotoListViewController.h
//  test
//
//  Created by Mr.kong on 2017/2/15.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "KSPhotoPickerProtocal.h"
#import "KSPhotoUtil.h"

@interface KSPhotoListViewController : UIViewController

@property (nonatomic, strong) PHAssetCollection* collection;

@property (nonatomic, strong) NSMutableArray<PHAsset*>* assets;

@property (nonatomic, copy) KSPhotoPickerCommitHandle           commitHandle;
@property (nonatomic, copy) KSPhotoPickerCancelHandle           cancelHandle;

@property (nonatomic, weak) id<KSPhotoPickerProtocal>           delegate;

@end

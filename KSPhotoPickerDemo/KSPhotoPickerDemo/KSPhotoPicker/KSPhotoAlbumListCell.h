//
//  KSPhotoAlbumListCell.h
//  test
//
//  Created by Mr.kong on 2017/2/15.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "KSPhotoUtil.h"

@interface KSPhotoAlbumListCell : UITableViewCell

@property (nonatomic, strong) PHAssetCollection* collection;

@end

UIKIT_EXTERN NSString * const KSPhotoAlbumListCellID;

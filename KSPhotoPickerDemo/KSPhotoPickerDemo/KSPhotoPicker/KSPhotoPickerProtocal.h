//
//  KSPhotoPickerProtocal.h
//  test
//
//  Created by Mr.kong on 2017/2/21.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#ifndef KSPhotoPickerProtocal_h
#define KSPhotoPickerProtocal_h

@class NSMutableArray;
@class PHAsset;
@class KSPhotoAlbumListController;
@protocol KSPhotoPickerProtocal <NSObject>

- (void)photoAlbumListController:(KSPhotoAlbumListController*)photoAlbumListController didFinishPickingAssets:(NSMutableArray<PHAsset*>*)assets;

- (void)photoAlbumListController:(KSPhotoAlbumListController*)photoAlbumListController didCancelPickingAssets:(NSMutableArray<PHAsset*>*)assets;

@end

#endif /* KSPhotoPickerProtocal_h */

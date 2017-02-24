//
//  CollectionViewCell.h
//  KSPhotoPickerDemo
//
//  Created by Mr.kong on 2017/2/24.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPhotoPicker.h"

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) PHAsset* asset;
@end

UIKIT_EXTERN NSString * const CollectionViewCellID;

//
//  KSPhotoListCell.h
//  test
//
//  Created by Mr.kong on 2017/2/15.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "KSPhotoUtil.h"

@class KSPhotoListCell;
@protocol KSPhotoListCellDelegate <NSObject>

- (void)photoListCell:(KSPhotoListCell*)cell didSelectedIndexPath:(NSIndexPath*)indexPath;

@end
@interface KSPhotoListCell : UICollectionViewCell
@property (nonatomic, strong) PHAsset                       * asset;
@property (nonatomic, strong) NSIndexPath                   * indexPath;
@property (nonatomic, weak) id<KSPhotoListCellDelegate>     delegate;

@end

UIKIT_EXTERN NSString * const KSPhotoListCellID;

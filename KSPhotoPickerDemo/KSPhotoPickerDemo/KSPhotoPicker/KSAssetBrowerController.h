//
//  KSAssetBrowerController.h
//  test
//
//  Created by Mr.kong on 2017/2/18.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "KSPhotoUtil.h"

@interface KSAssetBrowerController : UIViewController
@property (nonatomic, strong) PHAsset   * asset;
@property (nonatomic, strong) UIView    * contentView;
@end

//
//  KSPhotoListViewController.h
//  test
//
//  Created by Mr.kong on 2017/2/15.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface KSPhotoListViewController : UIViewController

@property (nonatomic, strong) PHAssetCollection* collection;

@property (nonatomic, strong) NSMutableArray<PHAsset*>* assets;

@end

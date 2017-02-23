//
//  ViewController.m
//  KSPhotoPickerDemo
//
//  Created by Mr.kong on 2017/2/23.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "ViewController.h"
#import "KSPhotoAlbumListController.h"
#import "NSArray+PHAsset_KSPhoto.h"

@interface ViewController ()<KSPhotoPickerProtocal>

@end

@implementation ViewController

- (IBAction)selectedImageAction{
    KSPhotoAlbumListController* list = [[KSPhotoAlbumListController alloc] init];
    list.delegate = self;
    
    list.commitHandle = ^(NSMutableArray<PHAsset*>*assets){
        //        NSLog(@"确认-block:%@",assets);
    };
    
    list.cancelHandle = ^(NSMutableArray<PHAsset*>*assets){
        //        NSLog(@"取消-block:%@",assets);
    };
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:list];
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)photoAlbumListController:(KSPhotoAlbumListController *)photoAlbumListController didCancelPickingAssets:(NSMutableArray *)assets{
    //    NSLog(@"取消-代理:%@",assets);
}

- (void)photoAlbumListController:(KSPhotoAlbumListController *)photoAlbumListController didFinishPickingAssets:(NSMutableArray *)assets{
    NSLog(@"回调");
    [assets requestImageWithOption:nil progress:^(PHAsset *asset, UIImage *image) {
        NSLog(@"%@",image);
    } complete:^(NSArray<UIImage *> *images) {
        NSLog(@"%@",images);
    }];
}

@end

//
//  ViewController.m
//  KSPhotoPickerDemo
//
//  Created by Mr.kong on 2017/2/23.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "ViewController.h"
#import "KSPhotoPicker.h"

#import "CollectionViewCell.h"

@interface ViewController ()<KSPhotoPickerProtocal,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray* dataSource;
@end

@implementation ViewController

- (IBAction)selectedImageAction{
    KSPhotoAlbumListController* list = [[KSPhotoAlbumListController alloc] init];
    list.delegate = self;
    list.photos = self.dataSource;
    
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
    KSPhotoRequestImageOption* option = [[KSPhotoRequestImageOption alloc] init];
    option.thumbnailMaxPixelSize = 500;
    option.synchronous = NO;
    _dataSource = assets;
    
    [assets requestImageWithOption:option progress:^(PHAsset *asset) {
        
    } complete:^(NSArray<PHAsset *> *assets) {
        [self.collectionView reloadData];
    }];
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
}

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    cell.asset = self.dataSource[indexPath.row];
    return cell;
}
@end

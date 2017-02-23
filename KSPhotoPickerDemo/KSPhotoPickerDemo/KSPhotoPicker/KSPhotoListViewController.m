//
//  KSPhotoListViewController.m
//  test
//
//  Created by Mr.kong on 2017/2/15.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSPhotoListViewController.h"
#import "KSAssetBrowerController.h"
#import "KSPhotoListCell.h"

@interface KSPhotoListViewController ()
<
KSPhotoListCellDelegate,
UISearchControllerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView          * collectionView;
@property (nonatomic, strong) PHFetchResult<PHAsset*>   * result;

@end

@implementation KSPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title                           = self.collection.localizedTitle;
    [self.view addSubview:self.collectionView];
    
    //初始化选择
    __weak typeof(self) weakSelf = self;
    [self.assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger index                                = [weakSelf.result indexOfObject:obj];
        if (index != NSNotFound) {
            NSIndexPath* indexPath                      = [NSIndexPath indexPathForItem:index inSection:0];
            [weakSelf.collectionView selectItemAtIndexPath:indexPath
                                                  animated:NO
                                            scrollPosition:UICollectionViewScrollPositionNone];
        }
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.collectionView.frame                           = self.view.bounds;
}

#pragma mark- UICollecionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.result.count;
}

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KSPhotoListCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:KSPhotoListCellID forIndexPath:indexPath];
    PHAsset* asset                                      = [self.result objectAtIndex:indexPath.row];
    cell.delegate                                       = self;
    cell.asset                                          = asset;
    cell.indexPath                                      = indexPath;
    cell.selected                                       = [self.assets containsObject:asset];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = (CGRectGetWidth(collectionView.bounds)- 3) / 4;
    return CGSizeMake(w, w);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.assets addObject:self.result[indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.assets removeObject:self.result[indexPath.row]];
}

- (void)photoListCell:(KSPhotoListCell *)cell didSelectedIndexPath:(NSIndexPath *)indexPath{
    
    KSAssetBrowerController* brower                     = [[KSAssetBrowerController alloc] init];
    brower.asset                                        = self.result[indexPath.row];
    brower.contentView                                  = [self.collectionView cellForItemAtIndexPath:indexPath];
    [self presentViewController:brower animated:NO completion:NULL];
}

- (UICollectionView* )collectionView{
    if (!_collectionView) {
        _collectionView                                 = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                                             collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.delegate                        = self;
        _collectionView.dataSource                      = self;
        _collectionView.allowsMultipleSelection         = YES;
        _collectionView.backgroundColor                 = [UIColor whiteColor];
        [_collectionView registerClass:[KSPhotoListCell class] forCellWithReuseIdentifier:KSPhotoListCellID];
    }
    return _collectionView;
}

- (PHFetchResult<PHAsset*>* )result{
    if (!_result) {
        _result                                         = [PHAsset fetchAssetsInAssetCollection:self.collection options:nil];
    }
    return _result;
}

@end

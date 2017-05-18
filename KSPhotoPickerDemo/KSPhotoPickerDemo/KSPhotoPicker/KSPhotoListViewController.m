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
#import "UIView+Badge.h"

@interface KSPhotoListViewController ()
<
KSPhotoListCellDelegate,
UISearchControllerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, strong) UICollectionView          * collectionView;
@property (nonatomic, strong) PHFetchResult<PHAsset*>   * result;
@property (nonatomic, strong) UIButton                  * commitButton;

@property (nonatomic, strong) UIToolbar                 * toolbar;

@end

@implementation KSPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = self.collection.localizedTitle;
    [self.view addSubview:self.collectionView];
    
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.translucent = YES;
    [self.view addSubview:self.toolbar];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cancel", @"KSPhotoString", nil)
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(cancel)];
    
    NSArray* item = @[[[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStyleDone target:nil action:nil],
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc] initWithTitle:@"相机" style:UIBarButtonItemStyleDone target:self action:@selector(camera)],
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc] initWithCustomView:self.commitButton]];
    
    [self.toolbar setItems:item animated:NO];
    
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
    
    self.toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 44, CGRectGetWidth(self.view.frame), 44);
    
    self.collectionView.frame = UIEdgeInsetsInsetRect(self.view.frame, UIEdgeInsetsMake(0, 0, 44, 0));
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.commitButton.badge = self.assets.count;
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
    self.commitButton.badge ++;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.assets removeObject:self.result[indexPath.row]];
    self.commitButton.badge --;
}

- (void)photoListCell:(KSPhotoListCell *)cell didSelectedIndexPath:(NSIndexPath *)indexPath{
    
    KSAssetBrowerController* brower                     = [[KSAssetBrowerController alloc] init];
    brower.asset                                        = self.result[indexPath.row];
    brower.contentView                                  = [self.collectionView cellForItemAtIndexPath:indexPath];
    [self presentViewController:brower animated:NO completion:NULL];
}

- (void)cancel{
    if (self.cancelHandle) {
        self.cancelHandle(self.assets);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoAlbumListController:didCancelPickingAssets:)]) {
        [self.delegate photoAlbumListController:nil didCancelPickingAssets:self.assets];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)commit{
    
    if (self.commitHandle) {
        self.commitHandle(self.assets);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoAlbumListController:didFinishPickingAssets:)]) {
        [self.delegate photoAlbumListController:nil didFinishPickingAssets:self.assets];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)camera{
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        return;
    }
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    UIImage* image = info[UIImagePickerControllerOriginalImage];
    
    __block NSString * localIdentifier = nil;
    
    __weak typeof(self) weakSelf = self;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        localIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            
            PHAsset* asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil].lastObject;
            [weakSelf.assets addObject:asset];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.commitButton.badge ++;
            });
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
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

- (UIButton *)commitButton{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setTitle:NSLocalizedStringFromTable(@"Done", @"KSPhotoString", nil)
                       forState:UIControlStateNormal];
        _commitButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_commitButton setTitleColor:self.navigationController.navigationBar.tintColor
                            forState:UIControlStateNormal];
        [_commitButton addTarget:self
                          action:@selector(commit)
                forControlEvents:UIControlEventTouchUpInside];
        [_commitButton sizeToFit];
    }
    return _commitButton;
}
@end

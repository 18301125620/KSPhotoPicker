//
//  KSPhotoAlbumListController.m
//  test
//
//  Created by Mr.kong on 2017/2/15.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSPhotoAlbumListController.h"
#import "KSPhotoAlbumListCell.h"
#import "KSPhotoListViewController.h"
#import "KSPhotoAuthorizationDenyView.h"

@interface KSPhotoAlbumListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView                                   * tableView;
@property (nonatomic, strong) NSMutableArray<PHAssetCollection*>            * result;
@end

@implementation KSPhotoAlbumListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"Album", @"KSPhotoString", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cancel", @"KSPhotoString", nil)
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(cancel)];
    self.result = [NSMutableArray array];
    
    
    [self authorizationStatus];
   
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

//读取相册相机权限
- (void)authorizationStatus{
    __weak typeof(self) weakSelf = self;
    
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
        {
            weakSelf.tableView.backgroundView = [KSPhotoAuthorizationDenyView new];
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {
            [weakSelf fetchAssetCollections];
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [weakSelf performSelectorOnMainThread:@selector(authorizationStatus)
                                           withObject:nil
                                        waitUntilDone:NO];
            }];
        }
            break;
    }
}

//读取资源
- (void)fetchAssetCollections{
    
    PHFetchOptions* options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"estimatedAssetCount" ascending:NO]];
    
    //相机胶卷
    PHFetchResult<PHAssetCollection*>* result2 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [self.result addObjectsFromArray:[result2 objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, result2.count)]]];
    
    //自定义相册
    PHFetchResult<PHAssetCollection*>* result1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:options];
    [self.result addObjectsFromArray:[result1 objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, result1.count)]]];
    
    //视频
        PHFetchResult<PHAssetCollection*>* result3 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
        [self.result addObjectsFromArray:[result3 objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, result3.count)]]];
    
    [self.tableView reloadData];
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.result.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KSPhotoAlbumListCell* cell = [tableView dequeueReusableCellWithIdentifier:KSPhotoAlbumListCellID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.collection = self.result[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KSPhotoListViewController* listView = [[KSPhotoListViewController alloc] init];
    listView.collection = self.result[indexPath.row];
    listView.assets = self.photos;
    
    listView.cancelHandle = self.cancelHandle;
    listView.commitHandle = self.commitHandle;
    
    listView.delegate = self.delegate;
    
    [self.navigationController pushViewController:listView animated:YES];
}

- (UITableView* )tableView{
    if (!_tableView) {
        _tableView                          = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate                 = self;
        _tableView.dataSource               = self;
        _tableView.tableFooterView          = [UIView new];
        _tableView.layoutMargins            = UIEdgeInsetsZero;
        _tableView.separatorInset           = UIEdgeInsetsZero;
        [_tableView registerClass:[KSPhotoAlbumListCell class]
           forCellReuseIdentifier:KSPhotoAlbumListCellID];
    }
    return _tableView;
}

- (NSArray<PHAsset *> *)photos{
    if (!_photos) {
        _photos                             = [NSMutableArray array];
    }else{
        if (![_photos isKindOfClass:[NSMutableArray class]]) {
            _photos                         = [NSMutableArray arrayWithArray:_photos];
        }
        return _photos;
    }
    
    return _photos;
}

- (void)cancel{
    if (self.cancelHandle) {
        self.cancelHandle(self.photos);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoAlbumListController:didCancelPickingAssets:)]) {
        [self.delegate photoAlbumListController:self didCancelPickingAssets:self.photos];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)commit{
    
    if (self.commitHandle) {
        self.commitHandle(self.photos);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoAlbumListController:didFinishPickingAssets:)]) {
        [self.delegate photoAlbumListController:self didFinishPickingAssets:self.photos];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
@end

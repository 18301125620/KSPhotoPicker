//
//  KSPhotoAlbumListCell.m
//  test
//
//  Created by Mr.kong on 2017/2/15.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSPhotoAlbumListCell.h"

@interface KSPhotoAlbumListCell ()
@property (nonatomic, strong) CALayer           * frontImageLayer;
@property (nonatomic, strong) CALayer           * middleImageLayer;
@property (nonatomic, strong) CALayer           * backImageLayer;
@property (nonatomic, strong) UILabel           * titleLabel;

@end

@implementation KSPhotoAlbumListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backImageLayer = [CALayer layer];
        self.backImageLayer.borderWidth = 1. / [UIScreen mainScreen].scale;
        self.backImageLayer.borderColor = [UIColor whiteColor].CGColor;
        [self.contentView.layer addSublayer:self.backImageLayer];
        
        self.middleImageLayer = [CALayer layer];
        self.middleImageLayer.borderWidth = 1. / [UIScreen mainScreen].scale;
        self.middleImageLayer.borderColor = [UIColor whiteColor].CGColor;
        [self.contentView.layer addSublayer:self.middleImageLayer];
        
        self.frontImageLayer = [CALayer layer];
        self.frontImageLayer.borderWidth = 1. / [UIScreen mainScreen].scale;
        self.frontImageLayer.borderColor = [UIColor whiteColor].CGColor;
        [self.contentView.layer addSublayer:self.frontImageLayer];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat frontX              = 10.;
    CGFloat frontY              = 10.;
    CGFloat frontH              = CGRectGetHeight(self.contentView.bounds) - frontY * 2;
    CGFloat frontW              = frontH;
    self.frontImageLayer.frame  = CGRectMake(frontX, frontY, frontW, frontH);
    
    CGFloat middleX             = frontX + 2;
    CGFloat middleY             = frontY - 2;
    CGFloat middleH             = frontH - 4;
    CGFloat middleW             = middleH;
    self.middleImageLayer.frame = CGRectMake(middleX, middleY, middleW, middleH);
    
    CGFloat backX               = middleX + 2;
    CGFloat backY               = middleY - 2;
    CGFloat backH               = middleH - 4;
    CGFloat backW               = backH;
    self.backImageLayer.frame   = CGRectMake(backX, backY, backW, backH);
    
    CGFloat labelX              = CGRectGetMaxX(self.frontImageLayer.frame) + 20;
    CGFloat labelY              = frontY;
    CGFloat labelH              = frontH;
    CGFloat labelW              = CGRectGetWidth(self.contentView.frame) - labelX - 30;
    self.titleLabel.frame       = CGRectMake(labelX, labelY, labelW, labelH);
}

- (void)setCollection:(PHAssetCollection *)collection{
    _collection = collection;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] init];
        PHFetchResult<PHAsset*>* assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];

        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:collection.localizedTitle
                                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}]];
            
            [attributedString appendAttributedString:[[NSAttributedString alloc]
                                                      initWithString:[NSString stringWithFormat:@"\n\n%ld",(long)assets.count]
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor lightGrayColor]}]];
            
            PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
            options.resizeMode = PHImageRequestOptionsResizeModeExact;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
            
            [@[weakSelf.frontImageLayer,weakSelf.middleImageLayer,weakSelf.backImageLayer] enumerateObjectsUsingBlock:^(CALayer*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (assets.count > idx) {
                    [[PHImageManager defaultManager] requestImageForAsset:[assets objectAtIndex:idx]
                                                               targetSize:KSSizeScreenScale(obj.bounds.size)
                                                              contentMode:PHImageContentModeAspectFill options:options
                                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                                obj.contents = (__bridge id _Nullable)(result.CGImage);
                                                            }];
                }else{
                    *stop = YES;
                }
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.titleLabel.attributedText = attributedString;
            });
        });
        
    });
}

@end

NSString * const KSPhotoAlbumListCellID = @"KSPhotoAlbumListCellID";

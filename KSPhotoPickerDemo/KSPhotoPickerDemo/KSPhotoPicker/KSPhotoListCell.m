//
//  KSPhotoListCell.m
//  test
//
//  Created by Mr.kong on 2017/2/15.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSPhotoListCell.h"

@interface KSPhotoListCellVideoView : UIView
@property (nonatomic, strong) CALayer                   * imageLayer;
@property (nonatomic, strong) CAGradientLayer           * gradientLayer;
@property (nonatomic, strong) UILabel                   * timeLabel;
@end

@implementation KSPhotoListCellVideoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors                       = @[(__bridge id _Nullable)[[UIColor blackColor] colorWithAlphaComponent:0.0].CGColor,
                                                            (__bridge id _Nullable)[[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor];
        self.gradientLayer.startPoint                   = CGPointMake(0, 0);
        self.gradientLayer.endPoint                     = CGPointMake(0, 1);
        [self.layer addSublayer:self.gradientLayer];
        
        self.imageLayer                                 = [CALayer layer];
        self.imageLayer.contents                        = (__bridge id _Nullable)([UIImage imageNamed:@"KSPhotoBundle.bundle/KSAssetTypeVideo"].CGImage);
        [self.layer addSublayer:self.imageLayer];
        
        self.timeLabel                                  = [[UILabel alloc] init];
        self.timeLabel.font                             = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor                        = [UIColor whiteColor];
        self.timeLabel.textAlignment                    = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.gradientLayer.frame                            = self.bounds;
    
    CGFloat margin                                      = 5.;
    CGFloat imageLayerH                                 = 10.;
    CGFloat imageLayerW                                 = 14.;
    CGFloat imageLayerY                                 = (CGRectGetHeight(self.bounds) - imageLayerH ) / 2;
    
    self.imageLayer.frame                               = CGRectMake(margin,
                                                                     imageLayerY,
                                                                     imageLayerW,
                                                                     imageLayerH);
    
    CGFloat timeLabelX                                  = CGRectGetMaxX(self.imageLayer.frame);
    CGFloat timeLabelY                                  = 0;
    CGFloat timeLabelW                                  = CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.imageLayer.frame) - 5;
    CGFloat timeLabelH                                  = CGRectGetHeight(self.bounds);
    
    self.timeLabel.frame                                = CGRectMake(timeLabelX,
                                                                     timeLabelY,
                                                                     timeLabelW,
                                                                     timeLabelH);
    
}

@end




@interface KSPhotoListCell ()
@property (nonatomic, strong) CALayer                   * imageLayer;
@property (nonatomic, strong) UIButton                  * showButton;
@property (nonatomic, strong) UIButton                  * selectedIconButton;
@property (nonatomic, strong) KSPhotoListCellVideoView  * videoView;

@end

@implementation KSPhotoListCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageLayer = [CALayer layer];
        [self.contentView.layer addSublayer:self.imageLayer];
        
        [self.contentView addSubview:self.videoView];
        
        [self.contentView addSubview:self.selectedIconButton];
        
        [self.contentView addSubview:self.showButton];
        
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageLayer.frame = self.contentView.bounds;
    
    self.selectedIconButton.frame                       = CGRectMake(0,
                                                                     0,
                                                                     CGRectGetWidth(self.contentView.bounds),
                                                                     CGRectGetHeight(self.contentView.bounds) / 2);
    
    self.showButton.frame                               = CGRectMake(0,
                                                                     CGRectGetHeight(self.contentView.bounds) / 2,
                                                                     CGRectGetWidth(self.contentView.bounds),
                                                                     CGRectGetHeight(self.contentView.bounds) / 2);
    
    self.videoView.frame                                = CGRectMake(0,
                                                                     CGRectGetHeight(self.contentView.bounds) - 20,
                                                                     CGRectGetWidth(self.contentView.bounds),
                                                                     20);
}

- (void)prepareForReuse{
    self.imageLayer.contents = nil;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.selectedIconButton.selected = selected;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UITouch* touch = [touches anyObject];
    CGPoint local = [touch locationInView:self.selectedIconButton];
    
    if (CGRectContainsPoint(self.selectedIconButton.bounds, local)) {
        [self startAnimated:self.selected];
    }
}

- (void)startAnimated:(BOOL)animated{
    [self.selectedIconButton.imageView.layer removeAllAnimations];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.2
                     animations:^{
                         weakSelf.selectedIconButton.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                     } completion:^(BOOL finished) {
                         weakSelf.selectedIconButton.imageView.transform = CGAffineTransformIdentity;
                     }];
}

- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        weakSelf.videoView.hidden = asset.mediaType != PHAssetMediaTypeVideo;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            if (asset.mediaType == PHAssetMediaTypeVideo) {
                //视频时间
                NSInteger minute                            = asset.duration / 60;
                NSInteger second                            = lround(asset.duration) % 60;
                NSMutableString* timeStr                    = [NSMutableString stringWithFormat:@"%02ld:%02ld",(long)minute,(long)second];
                
                //视频view
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.videoView.timeLabel.text       = timeStr;
                });
            }
        });
        
        //请求图片
        PHImageRequestOptions* options                  = [[PHImageRequestOptions alloc] init];
        options.resizeMode                              = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode                            = PHImageRequestOptionsDeliveryModeOpportunistic;
        
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                          targetSize:KSSizeScreenScale(self.imageLayer.bounds.size)
                                                         contentMode:PHImageContentModeAspectFill
                                                             options:options
                                                       resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                           weakSelf.imageLayer.contents = (__bridge id _Nullable)(result.CGImage);
                                                       }];
    });
}

- (void)showButtonAction:(UIButton*)button{
    if (_delegate && [_delegate respondsToSelector:@selector(photoListCell:didSelectedIndexPath:)]) {
        [_delegate photoListCell:self didSelectedIndexPath:self.indexPath];
    }
}

- (UIButton *)showButton{
    if (!_showButton) {
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showButton addTarget:self
                        action:@selector(showButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _showButton;
}

- (UIButton *)selectedIconButton{
    if (!_selectedIconButton) {
        _selectedIconButton                             = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_selectedIconButton setImage:[UIImage imageNamed:@"KSPhotoBundle.bundle/KSAssetSelected"]
                             forState:UIControlStateSelected];
        [_selectedIconButton setImage:[UIImage imageNamed:@"KSPhotoBundle.bundle/KSAssetUnSelected"]
                             forState:UIControlStateNormal];
        
        _selectedIconButton.imageEdgeInsets             = UIEdgeInsetsMake(5, -5, -5, 5);
        _selectedIconButton.contentVerticalAlignment    = UIControlContentVerticalAlignmentTop;
        _selectedIconButton.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentRight;
        _selectedIconButton.userInteractionEnabled      = NO;
    }
    return _selectedIconButton;
}

- (KSPhotoListCellVideoView *)videoView{
    if (!_videoView) {
        _videoView                                      = [[KSPhotoListCellVideoView alloc] init];
    }
    
    return _videoView;
}
@end

NSString * const KSPhotoListCellID = @"KSPhotoListCellID";

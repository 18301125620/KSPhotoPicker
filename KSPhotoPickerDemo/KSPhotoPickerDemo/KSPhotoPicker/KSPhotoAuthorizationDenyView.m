//
//  KSPhotoAuthorizationDenyView.m
//  test
//
//  Created by Mr.kong on 2017/2/22.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSPhotoAuthorizationDenyView.h"

@interface KSPhotoAuthorizationDenyView ()
@property (nonatomic, strong) CALayer   * imageLayer;
@property (nonatomic, strong) UILabel   * descLabel;

@end

@implementation KSPhotoAuthorizationDenyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.layer addSublayer:self.imageLayer];
        [self addSubview:self.descLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat imageLayerW                 = 87.;
    CGFloat imageLayerH                 = 82;
    CGFloat imageLayerX                 = (CGRectGetWidth(self.bounds) - imageLayerW) / 2.;
    CGFloat imageLayerY                 = (CGRectGetHeight(self.bounds) - imageLayerH) / 3.;
    self.imageLayer.frame               = CGRectMake(imageLayerX, imageLayerY, imageLayerW, imageLayerH);
    
    CGFloat descLabelW                  = CGRectGetWidth(self.bounds);
    CGFloat descLabelH                  = 20;
    CGFloat descLabelX                  = 0;
    CGFloat descLabelY                  = CGRectGetMaxY(self.imageLayer.frame) + 30;
    self.descLabel.frame                = CGRectMake(descLabelX, descLabelY, descLabelW, descLabelH);
}

- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel                      = [[UILabel alloc] init];
        _descLabel.text                 = NSLocalizedStringFromTable(@"Denied", @"KSPhotoString", nil);
        _descLabel.font                 = [UIFont systemFontOfSize:17];
        _descLabel.textAlignment        = NSTextAlignmentCenter;
        _descLabel.textColor            = [UIColor colorWithRed:202. / 255 green:202. / 255 blue:202. / 255 alpha:1.];
    }
    return _descLabel;
}
- (CALayer *)imageLayer{
    if (!_imageLayer) {
        _imageLayer                     = [CALayer layer];
        _imageLayer.contents            = (__bridge id _Nullable)([UIImage imageNamed:@"KSPhotoBundle.bundle/KSPhotoAuthorizationDeny"].CGImage);
    }
    return _imageLayer;
}

@end

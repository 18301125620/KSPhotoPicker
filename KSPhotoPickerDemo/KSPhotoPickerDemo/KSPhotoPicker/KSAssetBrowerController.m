//
//  KSAssetBrowerController.m
//  test
//
//  Created by Mr.kong on 2017/2/18.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSAssetBrowerController.h"

static float const kDuration                                        = 0.2f;
static float const kMinScale                                        = 1.f;
static float const kMaxScale                                        = 2.f;
static float const kInitAlpha                                       = 0.f;
static float const kFinalAlpha                                      = 1.f;

@interface KSAssetBrowerController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView      * scrollView;
@property (nonatomic, strong) UIImageView       * imageView;
@property (nonatomic, assign) CGRect              contentRect;
@property (nonatomic, assign) CGRect              imageViewFrame;

@end

@implementation KSAssetBrowerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.providesPresentationContextTransitionStyle             = YES;
        self.definesPresentationContext                             = YES;
        self.modalPresentationStyle                                 = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.scrollView];
    self.view.alpha                                                 = kInitAlpha;
    self.view.backgroundColor                                       = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        
        [[PHImageManager defaultManager] requestImageForAsset:self.asset
                                                   targetSize:KSSizeScreenScale(self.imageViewFrame.size)
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:options
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    
                                                    weakSelf.imageView.image = result;
                                                }];
    });
    
    //单击
    UITapGestureRecognizer* sigleTap = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(sigleTapAction:)];
    
    sigleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:sigleTap];
    
    //双击
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(doubleTapAction:)];
    
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    [sigleTap requireGestureRecognizerToFail:doubleTap];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self show];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat insetY = (CGRectGetHeight(scrollView.bounds) - CGRectGetHeight(_imageView.frame))/2;
    insetY = MAX(insetY, 0.0);
    if (ABS(_imageView.frame.origin.y - insetY) > 0.5) {
        CGRect imageViewFrame = _imageView.frame;
        
        imageViewFrame = CGRectMake(imageViewFrame.origin.x,
                                    insetY,
                                    imageViewFrame.size.width,
                                    imageViewFrame.size.height);
        
        _imageView.frame = imageViewFrame;
    }
}

- (void)sigleTapAction:(UITapGestureRecognizer*)gesture{
    [self hide];
}

- (void)doubleTapAction:(UITapGestureRecognizer*)gesture{

    CGFloat touchX = [gesture locationInView:gesture.view].x;
    CGFloat touchY = [gesture locationInView:gesture.view].y;
    touchX *= 1/self.scrollView.zoomScale;
    touchY *= 1/self.scrollView.zoomScale;
    touchX += self.scrollView.contentOffset.x;
    touchY += self.scrollView.contentOffset.y;
    
    if (self.scrollView.zoomScale != kMinScale) {
        [self.scrollView setZoomScale:kMinScale animated:YES];
        
    } else {
        
        CGFloat xsize = self.scrollView.bounds.size.width / kMaxScale;
        CGFloat ysize = self.scrollView.bounds.size.height / kMaxScale;
        [self.scrollView zoomToRect:CGRectMake(touchX - xsize/2,
                                               touchY - ysize/2,
                                               xsize,
                                               ysize)
                           animated:YES];
        
    }
}

- (void)show{
    //展现
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.view.alpha            = kFinalAlpha;
                         weakSelf.imageView.frame       = weakSelf.imageViewFrame;
    } completion:NULL];
}

- (void)hide{
    //消失
    
    if (self.scrollView.zoomScale != kMinScale) {
        [self.scrollView setZoomScale:kMinScale animated:YES];
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.view.alpha            = kInitAlpha;
                         weakSelf.imageView.frame       =  weakSelf.contentRect;
    } completion:^(BOOL finished) {
        [weakSelf dismissViewControllerAnimated:NO completion:NULL];
    }];
}

//lazy
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView                                  = [[UIImageView alloc] init];
        _imageView.frame                            = self.contentRect;
        _imageView.contentMode                      = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView                                 = [[UIScrollView alloc] init];
        _scrollView.delegate                        = self;
        _scrollView.minimumZoomScale                = kMinScale;
        _scrollView.maximumZoomScale                = kMaxScale;
        _scrollView.showsVerticalScrollIndicator    = NO;
        _scrollView.showsHorizontalScrollIndicator  = NO;
        [_scrollView addSubview:self.imageView];
    }
    return _scrollView;
}

- (CGRect)contentRect{
    if (CGRectEqualToRect(_contentRect, CGRectZero)) {
        _contentRect                                = [self.contentView.superview convertRect:self.contentView.frame
                                                                                       toView:[UIApplication sharedApplication].keyWindow];
    }
    return _contentRect;
}

- (CGRect)imageViewFrame{
    if (CGRectEqualToRect(_imageViewFrame, CGRectZero)) {
        float screenW                               = CGRectGetWidth(self.view.bounds);
        float screenH                               = CGRectGetHeight(self.view.bounds);
        float imageViewH                            = 0;
        
        if (self.asset.pixelWidth != 0) {
            imageViewH                              = screenW * (self.asset.pixelHeight * 1.0 / self.asset.pixelWidth);
        }
        
        
        _imageViewFrame                             = CGRectMake(0,
                                                      (screenH - imageViewH) * 0.5,
                                                      screenW,
                                                      imageViewH);
    }
    return _imageViewFrame;
}
@end


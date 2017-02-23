//
//  UIView+Badge.m
//  test
//
//  Created by Mr.kong on 2017/2/22.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "UIView+Badge.h"
#import <objc/runtime.h>

static const char *  kBadgeViewKey      = "kBadgeViewKey";

@implementation UIView (Badge)

- (void)setBadge:(NSInteger)badge{
    self.badgeLabel.hidden              = badge == 0;
    
    CGRect frame                        = self.badgeLabel.frame;
    
    if (badge < 10) {
        self.badgeLabel.text            = [NSString stringWithFormat:@"%ld",badge];
    }else if (badge > 99){
        self.badgeLabel.text            = @"99+";
        frame.size.width                = 24;
    }else{
        self.badgeLabel.text            = [NSString stringWithFormat:@"%ld",badge];
        frame.size.width                = 18;
    }
    self.badgeLabel.frame               = frame;
}

- (NSInteger)badge{
    return self.badgeLabel.text.integerValue;
}

- (UILabel*)badgeLabel{
    UILabel* badgeLabel                 = objc_getAssociatedObject(self, kBadgeViewKey);
    if (!badgeLabel) {
        float badgeLabelW               = 14;
        
        badgeLabel                      = [[UILabel alloc] init];
        badgeLabel.frame                = CGRectMake(CGRectGetWidth(self.bounds) - badgeLabelW,
                                                     0,
                                                     badgeLabelW,
                                                     badgeLabelW);
        
        badgeLabel.layer.cornerRadius   = badgeLabelW / 2.;
        badgeLabel.layer.masksToBounds  = YES;
        badgeLabel.backgroundColor      = [UIColor redColor];
        badgeLabel.textColor            = [UIColor whiteColor];
        badgeLabel.font                 = [UIFont systemFontOfSize:10];
        badgeLabel.textAlignment        = NSTextAlignmentCenter;
        [self addSubview:badgeLabel];
        
        objc_setAssociatedObject(self, kBadgeViewKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return badgeLabel;
}

@end

//
//  HzReflectionView.m
//  ZanderLayerTest
//
//  Created by ZanderHo on 15/8/10.
//  Copyright (c) 2015年 ZanderHo. All rights reserved.
//

#import "HzReflectionView.h"

@interface HzReflectionView ()

@property (strong, nonatomic) CAReplicatorLayer *replicatorLayer;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) CALayer *reflectionLayer;
@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation HzReflectionView

#pragma mark - getter and setter 

- (void)setContentView:(UIView *)contentView {
    if (_contentView != contentView) {
        [_contentView.layer removeFromSuperlayer];
        
        self.widthConstraint.constant = CGRectGetWidth(contentView.bounds);
        
        //乘1.5倍率，因为倒影占本体的一半高度，所以整个view的高度为本体的1.5倍
        self.heightConstraint.constant = CGRectGetHeight(contentView.bounds) * 1.5f;
        
        [self layoutIfNeeded];
        
        self.replicatorLayer.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(contentView.bounds), CGRectGetHeight(contentView.bounds) * 1.5);
        self.replicatorLayer.position = CGPointMake(CGRectGetWidth(self.frame) / 2, 0.0f);
        
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DScale(transform, 1.0, -1.0, 1.0);
        transform = CATransform3DTranslate(transform, 0.0, -CGRectGetHeight(contentView.bounds) * 2, 0.0);
        
        self.replicatorLayer.instanceTransform = transform;
        
        CALayer *contentLayer = contentView.layer;
        contentLayer.anchorPoint = CGPointMake(0.0f, 0.0f);
        contentLayer.position = CGPointMake(0.0f, 0.0f);
        [self.replicatorLayer addSublayer:contentLayer];
        
        self.gradientLayer.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(contentView.bounds), CGRectGetHeight(contentView.bounds) * 0.5 + 1.0);
        self.gradientLayer.position = CGPointMake(CGRectGetWidth(contentView.bounds) / 2, CGRectGetHeight(contentView.bounds));
        
        
        if (self.replicatorLayer.superlayer == nil) {
            [self.layer addSublayer:self.replicatorLayer];
        }
        
        if (self.gradientLayer.superlayer == nil) {
//            [self.layer addSublayer:self.gradientLayer];
        }
        
        UIImageView *maskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_mask"]];
        
        _contentView = contentView;
    }
}

- (CAReplicatorLayer *)replicatorLayer {
    if (!_replicatorLayer) {
        _replicatorLayer = [CAReplicatorLayer layer];
        _replicatorLayer.contentsScale = [[UIScreen mainScreen] scale];
        _replicatorLayer.masksToBounds = YES;
        _replicatorLayer.anchorPoint = CGPointMake(0.5, 0.0);
        _replicatorLayer.instanceCount = 2;
        _replicatorLayer.instanceAlphaOffset = -0.5;
    }
    
    return _replicatorLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.25].CGColor];
        _gradientLayer.anchorPoint = CGPointMake(0.5, 0.0);
        _gradientLayer.zPosition = 1.0f;
        _gradientLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    
    return _gradientLayer;
}

- (NSLayoutConstraint *)widthConstraint {
    if (!_widthConstraint) {
        _widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:100.0f];
        [self addConstraint:_widthConstraint];
    }
    
    return _widthConstraint;
}

- (NSLayoutConstraint *)heightConstraint {
    if (!_heightConstraint) {
        _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:20.0f];
        [self addConstraint:_heightConstraint];
    }
    
    return _heightConstraint;
}

@end

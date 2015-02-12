//
//  MCNewCustomLayer.m
//  MCCore
//
//  Created by Vinícius Rodrigues on 24/01/2014.
//  Copyright (c) 2014 MyAppControls. All rights reserved.
//

#import "MCNewCustomLayer.h"
#import "MCNewCustomLayeredView.h"
#import "MCUtil.h"

@interface MCNewCustomLayer()

@property (nonatomic) BOOL isCopy;
@property (nonatomic) BOOL hasCopy;

@end

@implementation MCNewCustomLayer {
    NSMutableArray *fromValues;
    NSMutableArray *toValues;
}

@dynamic value;

- (NSString*)description
{
    return [NSString stringWithFormat:@"<MCNewCustomLayer>identifier: %@", self.identifier];
}

#pragma mark Initialization Methods

- (void)setDefaults
{
    self.animationEnabled   = YES;
    self.isAllowedToAnimate = YES;
    self.animationDuration  = 0.5;
    self.contentsScale      = [UIScreen mainScreen].scale;
}

- (void)internalSetUp
{
    self.mainPathImage = nil;
    self.isPresentationLayer = NO;
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSublayer:self.textLabel.layer];
}

- (void)setUp {
    
}

- (id)init
{
    self = [super init];
    if (self) {
        [self internalSetUp];
        [self setDefaults];
        [self setUp];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        [self internalSetUp];
        [self setDefaults];
        [self setUp];
        
        self.frame = frame;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalSetUp];
        [self setDefaults];
        [self setUp];
    }
    
    return self;
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    
    if (self)
    {
        [self setDefaults];
        
        MCNewCustomLayer *other = (MCNewCustomLayer*)layer;
        self.value              = other.value;
        self.textLabel          = other.textLabel;
        self.selectionStatus    = other.selectionStatus;
        self.animationDuration  = other.animationDuration;
        self.mainPath           = CGPathCreateMutableCopy(other.mainPath);
        self.fillColor          = CGColorCreateCopy(other.fillColor);
        self.strokeColor        = CGColorCreateCopy(other.strokeColor);
        self.mainPathImage      = other.mainPathImage;
        self.identifier         = other.identifier;
        self.parentLayeredView  = other.parentLayeredView;
        self.isAllowedToAnimate = other.isAllowedToAnimate;
        self.imageBoundsStyle   = other.imageBoundsStyle;
        
        self.isPresentationLayer  = YES;
    }
    
    return self;
}

#pragma mark Animation Methods

+ (NSArray*)animatableKeys {
    return nil;
}

+ (NSArray*)shouldNotAnimateKeysHoldingDefaultValue {
    return nil;
}

- (id<CAAction>)makeAnimationForKey:(NSString*)key
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
    
    animation.duration              = self.animationDuration;
    animation.fromValue             = [self.modelLayer valueForKey:key];
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate              = self;
    animation.removedOnCompletion   = YES;
    
    return animation;
}

-(id<CAAction>)actionForKey:(NSString *)event
{
    if (self.animationEnabled && self.isAllowedToAnimate)
    {
        if ([[self.class animatableKeys] containsObject:event])
        {
            if ([[self valueForKey:event] intValue] != 0) {
                return [self makeAnimationForKey:event];
            }
            else {
                if (![[self.class shouldNotAnimateKeysHoldingDefaultValue] containsObject:event]) {
                    return [self makeAnimationForKey:event];
                }
            }
        }
    }

    return [super actionForKey:event];
}

+ (BOOL)needsDisplayForKey:(NSString *)event
{
    for (NSString *key in [self.class animatableKeys]) {
        if ([key isEqualToString:event]) {
            return YES;
        }
    }

    return [super needsDisplayForKey:event];
}

#pragma mark Drawing Methods

- (CGRect)mainPathImageBounds
{
    switch (self.imageBoundsStyle) {
        case MCNewCustomLayerImageBoundsFullRect:
            return self.bounds;
        case MCNewCustomLayerImageBoundsItemRect:
            return CGPathGetBoundingBox(self.mainPath);
    }
    
    NSLog(@"invalid imageBoundsStyle");
    return CGRectZero;
}

- (void)drawMainPathImageInContext:(CGContextRef)context
{
    if (self.mainPathImage && self.mainPath && !CGPathIsEmpty(self.mainPath))
    {
        CGContextSaveGState(context);
        
        CGContextAddPath(context, self.mainPath);
        CGContextClip(context);
        CGContextDrawImage(context, [self mainPathImageBounds], self.mainPathImage.CGImage);
        
        CGContextRestoreGState(context);
    }
}

- (void)customDrawInContext:(CGContextRef)context
{
    
}

- (void)drawInContext:(CGContextRef)context
{
    if (!self.isPresentationLayer) {
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    self.mainPath = (CGMutablePathRef)CGPathCreateCopy(path);
    
    CGContextSaveGState(context);
    
    [self customDrawInContext:context];
    [self drawMainPathImageInContext:context];
    
    CGContextRestoreGState(context);
    
    CGPathRelease(path);
    
    self.isAllowedToAnimate = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeAllAnimations];
}

@end

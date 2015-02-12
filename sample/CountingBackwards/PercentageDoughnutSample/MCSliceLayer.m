//
//  MCSliceLayer.m
//  PercentageDoughnutView
//
//  Created by Vinícius Rodrigues on 5/12/2013.
//  Copyright (c) 2013 MyAppControls. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "MCSliceLayer.h"

@interface MCSliceLayer()

@property (nonatomic) CGFloat lineWidth;

@end

@implementation MCSliceLayer

@dynamic startAngle;
@dynamic endAngle;
@dynamic center_x;
@dynamic center_y;

- (void)setDefaults
{
    [super setDefaults];
    
    self.linePercentage             = 1.0;
    self.showText                   = YES;
    self.selectedBackgroundColor    = [MCUtil iOS7DefaultBlueColor];
    self.fillColor                  = [MCUtil iOS7DefaultGrayColorForBackground].CGColor;
    self.strokeColor                = [MCUtil iOS7LightGrayColorForLines].CGColor;
    self.textColor                  = [MCUtil iOS7DarkGrayColorForLines];
    self.selectedTextColor          = [UIColor colorWithCGColor:self.fillColor];
    
    self.textDistancePercentageFromCenter = 0.6;
    self.distancePercentageOnSelection = 0.1;
    self.strokePercentage = 0.005;
}

+ (NSArray*)animatableKeys {
    return [[NSArray alloc] initWithObjects:@"startAngle", @"endAngle", @"center_x", @"center_y", nil];
}

+ (NSArray*)shouldNotAnimateKeysHoldingDefaultValue {
    return [[NSArray alloc] initWithObjects:@"center_x", @"center_y", nil];
}

- (id<CAAction>)makeAnimationForKey:(NSString*)key
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
    
    animation.duration = self.animationDuration;
    
    if ([key isEqualToString:@"startAngle"]) {
        animation.fromValue = [NSNumber numberWithFloat:((MCSliceLayer*)self.modelLayer).startAngle];
    }
    else  if ([key isEqualToString:@"endAngle"]) {
        animation.fromValue = [NSNumber numberWithFloat:((MCSliceLayer*)self.modelLayer).endAngle];
    }
    else  if ([key isEqualToString:@"center_x"]) {
        animation.fromValue = [NSNumber numberWithFloat:((MCSliceLayer*)self.modelLayer).center_x];
        animation.duration *= 0.2;
    }
    else  if ([key isEqualToString:@"center_y"]) {
        animation.fromValue = [NSNumber numberWithFloat:((MCSliceLayer*)self.modelLayer).center_y];
        animation.duration *= 0.2;
    }
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    
    return animation;
}

- (CGFloat)calcRadiusFromFrame:(CGRect)frame {
    return [MCUtil getMinRadiusOnRect:frame]/(1+self.distancePercentageOnSelection);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.center_x       = CGRectGetMidX(frame);
        self.center_y       = CGRectGetMidY(frame);
        
        // adjusts the external radius so that the selected
        // slices still fit inside of the container view bound's
        self.externalRadius = [self calcRadiusFromFrame:frame];
    }
    return self;
}

- (id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer:layer]) {
        MCSliceLayer *other                     = (MCSliceLayer *)layer;
        self.startAngle                         = other.startAngle;
        self.endAngle                           = other.endAngle;
        self.center_x                           = other.center_x;
        self.center_y                           = other.center_y;
        self.internalRadius                     = other.internalRadius;
        self.externalRadius                     = other.externalRadius;
        self.linePercentage                     = other.linePercentage;
        self.selectionStatus                    = other.selectionStatus;
        self.selectedBackgroundColor            = other.selectedBackgroundColor;
        self.textColor                          = other.textColor;
        self.selectedTextColor                  = other.selectedTextColor;
        self.strokePercentage                   = other.strokePercentage;
        self.lineWidth                          = other.lineWidth;
        self.showText                           = other.showText;
        self.distancePercentageOnSelection      = other.distancePercentageOnSelection;
        self.textDistancePercentageFromCenter   = other.textDistancePercentageFromCenter;
    }
    return self;
}

- (CGAffineTransform)getRotatedAffineTransform
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // translate to the center to rotate, then translate back to (0,0)
    // the rotation occours arround the (0,0) point.
    transform = CGAffineTransformMakeTranslation(center.x, center.y);
    transform = CGAffineTransformRotate(transform, DEG2RAD(-90));
    transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
    
    return transform;
}

- (void)customDrawInContext:(CGContextRef)context
{
    CGAffineTransform transform = [self getRotatedAffineTransform];
    
    CGFloat strokeWidth = (self.externalRadius - self.internalRadius)*self.strokePercentage;
    
    CGPathAddArc(self.mainPath, &transform,
                    self.center_x, self.center_y,
                    self.externalRadius - self.lineWidth/2,
                    self.startAngle, self.endAngle,
                    0);
    
    switch (self.selectionStatus) {
        case MCNewCustomLayerSelectionStatusNotSelected:
            if (!self.mainPathImage) {
                CGContextSetFillColorWithColor(context, self.fillColor);
            }
            CGContextSetStrokeColorWithColor(context, self.strokeColor);
            break;
        case MCNewCustomLayerSelectionStatusSelected:
            if (!self.mainPathImage) {
                CGContextSetFillColorWithColor(context, self.selectedBackgroundColor.CGColor);
            }
            CGContextSetStrokeColorWithColor(context, self.selectedBackgroundColor.CGColor);
            break;
    }
    
    CGContextSetLineWidth(context, self.lineWidth - strokeWidth/2);
    CGContextAddPath(context, self.mainPath);
    CGContextReplacePathWithStrokedPath(context);
    CGContextSetLineWidth(context, strokeWidth/2);
    self.mainPath = (CGMutablePathRef)CGContextCopyPath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGFloat pathCenterRadiusPercentage = self.textDistancePercentageFromCenter;
    CGPoint pathCenter = [self getPathCenterWithRadiusPercentage:pathCenterRadiusPercentage];
    pathCenter = CGPointApplyAffineTransform(pathCenter, transform);
    
    CGFloat width = 2*(sqrtf(powf(self.externalRadius*pathCenterRadiusPercentage, 2)*0.3));
    
    if (self.showText) {
        if (fabsf(self.startAngle-self.endAngle) > DEG2RAD(20)) {
            self.textLabel.bounds = CGRectMake(0, 0,
                                               width,
                                               self.externalRadius*0.5);
            
            self.textLabel.center = CGPointMake(pathCenter.x, pathCenter.y);
            self.textLabel.layer.position = CGPointMake(pathCenter.x, pathCenter.y);
            
            switch (self.selectionStatus) {
                case MCNewCustomLayerSelectionStatusNotSelected:
                    self.textLabel.textColor = self.textColor;
                    break;
                case MCNewCustomLayerSelectionStatusSelected:
                    self.textLabel.textColor = self.selectedTextColor;
                    break;
            }
            
            // shows the label in case it was hidden in the last drawing.
            [self.textLabel setHidden:NO];
        }
        else {
            // hides the label if the angle is too small.
            [self.textLabel setHidden:YES];
        }
    }
}

#pragma mark Custom Setters

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.center_x       = CGRectGetMidX(frame);
    self.center_y       = CGRectGetMidY(frame);
    
    // adjusts the external radius so that the selected
    // slices still fit inside of the container view bound's
    self.externalRadius = [self calcRadiusFromFrame:frame];
}

- (void)setExternalRadius:(CGFloat)externalRadius {
    _externalRadius = externalRadius;
    self.internalRadius = _externalRadius*(1-self.linePercentage);
    self.lineWidth = _externalRadius-_internalRadius;
}

- (void)setLinePercentage:(CGFloat)linePercentage {
    linePercentage = [MCUtil verifyPercentageBoundsForValue:linePercentage];
    _linePercentage = linePercentage;
    self.internalRadius = self.externalRadius*(1-linePercentage);
}

- (void)setTextDistancePercentageFromCenter:(CGFloat)textDistancePercentageFromCenter {
    textDistancePercentageFromCenter = [MCUtil verifyPercentageBoundsForValue:textDistancePercentageFromCenter];
    _textDistancePercentageFromCenter = textDistancePercentageFromCenter;
}

- (void)setDistancePercentageOnSelection:(CGFloat)distancePercentageOnSelection {
    distancePercentageOnSelection = [MCUtil verifyPercentageBoundsForValue:distancePercentageOnSelection];
    _distancePercentageOnSelection = distancePercentageOnSelection;
    
    // adjusts the external radius so that the selected
    // slices still fit inside of the container view bound's
    self.externalRadius = [self calcRadiusFromFrame:self.frame];
}

- (void)setInternalRadius:(CGFloat)internalRadius {
    _internalRadius = internalRadius;
    self.lineWidth  = _externalRadius-_internalRadius;
}

#pragma mark Animation Delegate

- (void)animationDidStart:(CAAnimation *)anim {
    if ([self.arcDelegate respondsToSelector:@selector(animationDidStart:)]) {
        [self.arcDelegate animationDidStart:anim];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self.arcDelegate respondsToSelector:@selector(animationDidStop:finished:)]) {
        [self.arcDelegate animationDidStop:anim finished:flag];
    }
}

#pragma mark PathCenter Methods

- (CGPoint)getStartAnglePoint {
    return CGPointMake(self.externalRadius*cosf(self.startAngle)+self.center_x,
                       self.externalRadius*sinf(self.startAngle)+self.center_y);
}

- (CGPoint)getEndAnglePoint {
    return CGPointMake(self.externalRadius*cosf(self.endAngle)+self.center_x,
                       self.externalRadius*sinf(self.endAngle)+self.center_y);
}

- (CGPoint)getTanIntersectionPoint {
    CGFloat x1 = [self getStartAnglePoint].x;
    CGFloat y1 = [self getStartAnglePoint].y;
    
    CGFloat x2 = [self getEndAnglePoint].x;
    CGFloat y2 = [self getEndAnglePoint].y;
    
    CGFloat A = tanf(M_PI_2+self.startAngle);
    CGFloat B = tanf(M_PI_2+self.endAngle);
    CGFloat xt = (A*x1 - B*x2 + y2 - y1)/(A-B);
    CGFloat yt = B*(xt - x2) + y2;
    
    return CGPointMake(xt, yt);
}

- (CGPoint)getPathCenterWithRadiusPercentage:(CGFloat)radiusPercentage {
    CGFloat radius = self.externalRadius*radiusPercentage;
    
    CGFloat midAngle = (self.startAngle + self.endAngle)/2;
    
    CGPoint point = CGPointMake(cosf(midAngle)*radius+self.center_x,
                                sinf(midAngle)*radius+self.center_y);
    
    return point;
    
//    CGFloat xc = self.center_x;
//    CGFloat yc = self.center_y;
//    
//    CGPoint tanIntersectionPoint = [self getTanIntersectionPoint];
//    CGFloat xt = tanIntersectionPoint.x;
//    CGFloat yt = tanIntersectionPoint.y;
//    
//    CGFloat m = (yc - yt)/(xc - xt);
//    CGFloat alpha = atanf(m);
//    
//    CGFloat x1, y1;
//    CGFloat x2, y2;
//    
//    x1 = radius*cosf(alpha)+xc;
//    y1 = radius*sinf(alpha)+yc;
//    x2 = -radius*cosf(alpha)+xc;
//    y2 = -radius*sinf(alpha)+yc;
//    
//    CGPoint fromPoint = CGPointMake(xt, yt);
//    CGPoint point1 = CGPointMake(x1, y1);
//    CGPoint point2 = CGPointMake(x2, y2);
//    
//    if (fabs(self.endAngle - self.startAngle) <= DEG2RAD(180)) {
//        return [MCUtil getClosestPointFrom:fromPoint between:point1 and:point2];
//    }
//    else {
//        return [MCUtil getFurthestPointFrom:fromPoint between:point1 and:point2];
//    }
}

#pragma mark Selection Status Methods

- (void)setSelectionStatus:(MCNewCustomLayerSelectionStatus)status {
    if (self.selectionStatus == status) {
        return;
    }
    
    [super setSelectionStatus:status];
    
    CGAffineTransform transform = [self getRotatedAffineTransform];
    CGPoint frameCenter = CGPointApplyAffineTransform([MCUtil getCenterOfRect:self.bounds], transform);
    CGPoint pathCenter = [self getPathCenterWithRadiusPercentage:self.distancePercentageOnSelection];
    
    switch (status) {
        case MCNewCustomLayerSelectionStatusSelected:
            self.center_x = pathCenter.x;
            self.center_y = pathCenter.y;
            break;
        case MCNewCustomLayerSelectionStatusNotSelected:
            self.center_x = frameCenter.x;
            self.center_y = frameCenter.y;
            break;
            
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

@end

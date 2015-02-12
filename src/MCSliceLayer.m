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
    self.shouldAntialise            = YES;
    self.textDistancePercentageFromCenter = 0.6;
    self.distancePercentageOnSelection = 0.0;
    self.strokePercentage           = 0.005;
    
    self.gradientColor1             = [MCUtil iOS7DefaultBlueColor];
    self.gradientColor2             = [MCUtil iOS7DefaultGrayColorForBackground];;
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

    if (self.animationTimingFuncion) {
        animation.timingFunction = self.animationTimingFuncion;
    }
    else {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    }
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
        self.animationTimingFuncion             = other.animationTimingFuncion;
        self.shouldAntialise                    = other.shouldAntialise;
        self.enableGradient                     = other.enableGradient;
        self.gradientColor1                     = other.gradientColor1;
        self.gradientColor2                     = other.gradientColor2;
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

typedef UIColor * (^floatColorBlock)(CGFloat);

-(CGPoint) pointForTrapezoidWithAngle:(CGFloat)a andRadius:(CGFloat)r  forCenter:(CGPoint)p{
    return CGPointMake(p.x + r*cos(a), p.y + r*sin(a));
}

-(void)drawGradientInContext:(CGContextRef)ctx
               startingAngle:(CGFloat)startingAngle
                 endingAngle:(CGFloat)endingAngle
                   intRadius:(CGFloat)intRadius
                   outRadius:(CGFloat)outRadius
           withGradientBlock:(floatColorBlock)colorBlock
                  withSubdiv:(int)subdivCount
                  withCenter:(CGPoint)center
                   withScale:(CGFloat)scale
{
    
//    NSLog(@"startingAngle = %f", startingAngle);
//    NSLog(@"endingAngle = %f", endingAngle);
    CGFloat diff = endingAngle - startingAngle;
    
    if (diff <= 0.001) {
        return;
    }
    
    startingAngle = startingAngle - DEG2RAD(90);
    endingAngle = endingAngle - DEG2RAD(90);
//
//    CGFloat angleDelta = (endingAngle-startingAngle)/subdivCount;
    
    CGContextSaveGState(ctx);
    
    float angleDelta = (endingAngle-startingAngle)/subdivCount;
    
    CGPoint p0,p1,p2,p3, p4,p5;
    float currentAngle=startingAngle;
    p4=p0 = [self pointForTrapezoidWithAngle:currentAngle andRadius:intRadius forCenter:center];
    p5=p3 = [self pointForTrapezoidWithAngle:currentAngle andRadius:outRadius forCenter:center];
    CGMutablePathRef innerEnveloppe=CGPathCreateMutable(),
    outerEnveloppe=CGPathCreateMutable();
    
    CGPathMoveToPoint(outerEnveloppe, 0, p3.x, p3.y);
    CGPathMoveToPoint(innerEnveloppe, 0, p0.x, p0.y);
    
    
    CGContextSetLineWidth(ctx, 1);
    
    for (int i=0;i<subdivCount;i++)
    {
//        CGMutablePathRef gradientPath = CGPathCreateMutable();
//        
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        
//        CGFloat strokeWidth = (self.externalRadius - self.internalRadius)*self.strokePercentage;
//        
//        CGFloat angle1 = startingAngle+angleDelta*i;
//        CGFloat angle2 = startingAngle+angleDelta*(i+1);
//        
//        CGPathAddArc(gradientPath, &transform,
//                     self.center_x, self.center_y,
//                     self.externalRadius - self.lineWidth/2,
//                     angle1, angle2,
//                     0);
//        
//        UIColor *c = colorBlock((CGFloat)i/subdivCount);
//        
//        CGContextSetFillColorWithColor(ctx, c.CGColor);
//        CGContextSetFlatness(ctx, 0);
//        CGContextSetLineWidth(ctx, self.lineWidth - strokeWidth/2);
//        CGContextAddPath(ctx, gradientPath);
//        CGContextReplacePathWithStrokedPath(ctx);
//        CGContextSetLineWidth(ctx, strokeWidth/2);
//        
//        // draw the path
//        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        
        float fraction = (float)i/subdivCount;
        currentAngle=startingAngle+fraction*(endingAngle-startingAngle);
        CGMutablePathRef trapezoid = CGPathCreateMutable();
        
        p1 = [self pointForTrapezoidWithAngle:currentAngle+angleDelta andRadius:intRadius forCenter:center];
        p2 = [self pointForTrapezoidWithAngle:currentAngle+angleDelta andRadius:outRadius forCenter:center];
        
        CGPathMoveToPoint(trapezoid, 0, p0.x, p0.y);
        CGPathAddLineToPoint(trapezoid, 0, p1.x, p1.y);
        CGPathAddLineToPoint(trapezoid, 0, p2.x, p2.y);
        CGPathAddLineToPoint(trapezoid, 0, p3.x, p3.y);
        CGPathCloseSubpath(trapezoid);
        
        CGPoint centerofTrapezoid = CGPointMake((p0.x+p1.x+p2.x+p3.x)/4, (p0.y+p1.y+p2.y+p3.y)/4);
        
        CGAffineTransform t = CGAffineTransformMakeTranslation(-centerofTrapezoid.x, -centerofTrapezoid.y);
        CGAffineTransform s = CGAffineTransformMakeScale(scale, scale);
        CGAffineTransform concat = CGAffineTransformConcat(t, CGAffineTransformConcat(s, CGAffineTransformInvert(t)));
        CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(trapezoid, &concat);
        
        CGContextAddPath(ctx, scaledPath);
        CGContextSetFillColorWithColor(ctx,colorBlock(fraction).CGColor);
        CGContextSetStrokeColorWithColor(ctx, colorBlock(fraction).CGColor);
        CGContextSetMiterLimit(ctx, 0);
        
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        CGPathRelease(trapezoid);
        p0=p1;
        p3=p2;
        
        CGPathAddLineToPoint(outerEnveloppe, 0, p3.x, p3.y);
        CGPathAddLineToPoint(innerEnveloppe, 0, p0.x, p0.y);
    }
    
    CGContextSetLineWidth(ctx, 0);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextAddPath(ctx, outerEnveloppe);
    CGContextAddPath(ctx, innerEnveloppe);
    CGContextMoveToPoint(ctx, p0.x, p0.y);
    CGContextAddLineToPoint(ctx, p3.x, p3.y);
    CGContextMoveToPoint(ctx, p4.x, p4.y);
    CGContextAddLineToPoint(ctx, p5.x, p5.y);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (floatColorBlock)gradientBlockWithColor1:(UIColor*)color1 andColor2:(UIColor*)color2
{
    floatColorBlock gradientBlock = ^UIColor *(CGFloat f)
    {
        const CGFloat *components1 = CGColorGetComponents(color1.CGColor);
        const CGFloat *components2 = CGColorGetComponents(color2.CGColor);
        
        CGFloat red1 = components1[0];
        CGFloat red2 = components2[0];
        CGFloat green1 = components1[1];
        CGFloat green2 = components2[1];
        CGFloat blue1 = components1[2];
        CGFloat blue2 = components2[2];
        CGFloat alpha1 = components1[3];
        CGFloat alpha2 = components2[3];
        
        return [UIColor colorWithRed:red2*f     + red1*(1-f)
                               green:green2*f   + green1*(1-f)
                                blue:blue2*f    + blue1*(1-f)
                               alpha:alpha2*f   + alpha1*(1-f)];
        
    };
    
    return gradientBlock;
}

- (void)drawGradientInContext:(CGContextRef)context
{
    CGFloat gradientAngle = DEG2RAD(40)*cosf(self.endAngle/4);
    
    // ignore the last 3 decimal points
    int roundedGradientAngle = gradientAngle*1000;
    gradientAngle = roundedGradientAngle/1000.0;
    
    CGFloat startingAngle = self.endAngle-gradientAngle;
    startingAngle = MAX(startingAngle, 0);
    
    [self drawGradientInContext:context
                  startingAngle:self.startAngle
                    endingAngle:startingAngle
                      intRadius:self.internalRadius
                      outRadius:self.externalRadius
              withGradientBlock:[self gradientBlockWithColor1:self.gradientColor1 andColor2:self.gradientColor1]
                     withSubdiv:100
                     withCenter:CGPointMake(self.center_x, self.center_y)
                      withScale:1];
    
    [self drawGradientInContext:context
                  startingAngle:startingAngle
                    endingAngle:self.endAngle
                      intRadius:self.internalRadius
                      outRadius:self.externalRadius
              withGradientBlock:[self gradientBlockWithColor1:self.gradientColor1 andColor2:self.gradientColor2]
                     withSubdiv:100
                     withCenter:CGPointMake(self.center_x, self.center_y)
                      withScale:1];
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
    
    switch (self.selectionStatus)
    {
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
    
    CGContextSetAllowsAntialiasing(context, self.shouldAntialise);
    CGContextSetLineWidth(context, self.lineWidth - strokeWidth/2);
    CGContextAddPath(context, self.mainPath);
    CGContextReplacePathWithStrokedPath(context);
    CGContextSetLineWidth(context, strokeWidth/2);
    self.mainPath = (CGMutablePathRef)CGContextCopyPath(context);
    
    // draw the path
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    // gradient
    if (self.enableGradient) {
        [self drawGradientInContext:context];
    }
    
    
    CGFloat pathCenterRadiusPercentage = self.textDistancePercentageFromCenter;
    CGPoint pathCenter = [self getPathCenterWithRadiusPercentage:pathCenterRadiusPercentage];
    pathCenter = CGPointApplyAffineTransform(pathCenter, transform);
    
    CGFloat width = 2*(sqrtf(powf(self.externalRadius*pathCenterRadiusPercentage, 2)*0.3));
    
    if (self.showText)
    {
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

- (CGPoint)getPointFromAngle:(CGFloat)angle {
    return CGPointMake(self.externalRadius*cosf(angle)+self.center_x,
                       self.externalRadius*sinf(angle)+self.center_y);
}

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

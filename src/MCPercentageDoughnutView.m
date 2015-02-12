//
//  MCPercentageDoughnutView.m
//  MCPercentageDoughnutView
//
//  Created by Vinícius Rodrigues on 14/12/2013.
//  Copyright (c) 2013 MyAppControls. All rights reserved.
//

#import "MCPercentageDoughnutView.h"
#import "MCNewCustomLayeredView+MCCustomLayeredViewSubclass.h"

typedef enum {
    MCPercentageDoughnutViewStateNormal,
    MCPercentageDoughnutViewStatePushed
} MCPercentageDoughnutViewTouchState;

@interface MCPercentageDoughnutView()

@property (nonatomic, retain) UIView *centerView;
@property (nonatomic) MCPercentageDoughnutViewTouchState touchState;

@end

@implementation MCPercentageDoughnutView

- (void)setDefaults
{
    [super setDefaults];
    
    self.linePercentage                 = 0.15;
    self.borderPercentage               = 0;
    self.showTextLabel                  = YES;
    self.animationDuration              = 0.5;
    self.unfillColor                    = [MCUtil iOS7DefaultGrayColorForBackground];
    self.borderColorForFilledArc        = [UIColor blackColor];
    self.borderColorForUnfilledArc      = [UIColor clearColor];
    self.borderPercentageForFilledArc   = -1;
    self.borderPercentageForUnfilledArc = -1;
    self.adjustsFontSizeAutomatically   = YES;
    self.roundedImageOverlapPercentage  = 0;
    self.touchState                     = MCPercentageDoughnutViewStateNormal;
    self.gradientColor1                 = [MCUtil iOS7DefaultBlueColor];
    self.gradientColor2                 = [MCUtil iOS7DefaultGrayColorForBackground];
    
    _percentage                         = 0.0;
    _initialPercentage                  = 0.0;
    
    _centerView  = [[UIView alloc] init];
    _textLabel   = [[UILabel alloc] init];
}

- (void)willDrawSublayers
{
    if (!self.fillColor) {
        self.fillColor = self.tintColor;
    }
}

- (Class)classForSublayers {
    return [MCSliceLayer class];
}

- (NSInteger)dataSourceNumberOfItemsInView:(MCNewCustomLayeredView *)view {
    return 3;
}

- (MCNewCustomLayer*)itemForIndex:(NSInteger)index withReuseItem:(MCNewCustomLayer *)reuseItem
{
    MCSliceLayer *slice = (MCSliceLayer*)[super itemForIndex:index withReuseItem:reuseItem];
    
    slice.animationDuration = self.animationDuration;
    slice.animationEnabled = self.animationEnabled;
    slice.imageBoundsStyle = self.imageBoundsStyle;
    slice.animationTimingFuncion = self.animationTimingFuncion;
    
    if (index == 0)
    {
        slice.animationEnabled = NO;
        slice.strokeColor   = self.borderColorForUnfilledArc.CGColor;
        slice.fillColor     = self.unfillColor.CGColor;
        slice.startAngle    = DEG2RAD(0);
        slice.endAngle      = DEG2RAD(D_360);
        slice.mainPathImage = self.imageForUnfilledArc;
        if (self.borderPercentageForUnfilledArc > 0) {
            slice.strokePercentage = self.borderPercentageForUnfilledArc;
        }
        else {
            slice.strokePercentage = self.borderPercentage;
        }
        
        slice.enableGradient        = self.enableGradient;
        slice.gradientColor1        = self.gradientColor2;
        slice.gradientColor2        = self.gradientColor2;
    }
    else if (index == 1)
    {
        slice.strokeColor   = self.borderColorForFilledArc.CGColor;
        slice.fillColor     = self.fillColor.CGColor;
        slice.startAngle    = DEG2RAD(0);
        
        if (self.firstDraw) {
            slice.endAngle = DEG2RAD(D_360*self.initialPercentage);
        }
        slice.endAngle = DEG2RAD(D_360*self.percentage);
        
        slice.mainPathImage = self.imageForFilledArc;
        if (self.borderPercentageForFilledArc > 0) {
            slice.strokePercentage = self.borderPercentageForFilledArc;
        }
        else {
            slice.strokePercentage = self.borderPercentage;
        }
        slice.strokePercentage      = 0;
        slice.enableGradient        = self.enableGradient;
        slice.gradientColor1        = self.gradientColor1;
        slice.gradientColor2        = self.gradientColor2;
        slice.externalRadius = 10;
    }
    
    slice.linePercentage = self.linePercentage;
    if (self.enableGradient) {
        slice.distancePercentageOnSelection = 0.02;
    }
    else {
        slice.distancePercentageOnSelection = 0.0;
    }
    
    // central rounded layer
    if (index >= 2)
    {
        slice.imageBoundsStyle = MCNewCustomLayerImageBoundsItemRect;
        
        switch (self.touchState) {
            case MCPercentageDoughnutViewStateNormal:
                slice.mainPathImage = [MCUtil flippedImage:self.roundedBackgroundImage byAxis:0];
                break;
            case MCPercentageDoughnutViewStatePushed:
                if (self.roundedBackgroundImageForPushedState)
                {
                    slice.mainPathImage = [MCUtil flippedImage:self.roundedBackgroundImageForPushedState byAxis:0];
                }
                else {
                    slice.mainPathImage = [MCUtil flippedImage:self.roundedBackgroundImage byAxis:0];
                }
            default:
                break;
        }
        slice.animationEnabled = NO;
        slice.strokeColor   = [UIColor clearColor].CGColor;
        slice.fillColor     = [UIColor clearColor].CGColor;
        slice.startAngle    = DEG2RAD(0);
        slice.endAngle      = DEG2RAD(D_360);
        slice.shouldAntialise = NO;
        slice.strokePercentage = 0.0;
        slice.linePercentage = 1.0;
        slice.externalRadius = [MCUtil getMinRadiusOnRect:self.bounds]*(1-(self.linePercentage-self.roundedImageOverlapPercentage));
    }
    
    return slice;
}

- (void)customLayeredView:(MCNewCustomLayeredView *)customLayeredView
  didTouchMainPathOnLayer:(MCNewCustomLayer *)layer
{
    NSInteger index = [self.containerLayer.sublayers indexOfObject:layer];
    
    if (index == 2) {
        self.touchState = MCPercentageDoughnutViewStatePushed;
        [self reloadData];
    }
}

- (void)customLayeredView:(MCNewCustomLayeredView *)customLayeredView
didReleaseMainPathOnLayer:(MCNewCustomLayer *)layer
{
    NSInteger index = [self.containerLayer.sublayers indexOfObject:layer];
    
    if (index == 2) {
        self.touchState = MCPercentageDoughnutViewStateNormal;
        [self reloadData];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPercentageDoughnutView:)]) {
            [self.delegate didSelectPercentageDoughnutView:self];
        }
    }
}

- (void)didDrawSublayers
{
    [super didDrawSublayers];
    
    MCSliceLayer *anyItem = (MCSliceLayer*)[self getItemAtIndex:0];
    
    // d = l*sqrt(2)
    CGFloat centerViewSideSize      = anyItem.internalRadius*2/sqrt(2);

    // calculate bounds and frames based on the
    // slices radius.
    self.centerView.bounds          = CGRectMake(0, 0, centerViewSideSize, centerViewSideSize);
    self.centerView.center          = [MCUtil getCenterOfRect:self.bounds];
    
    if (self.adjustsFontSizeAutomatically)
    {
        self.textLabel.font = [self.textLabel.font fontWithSize:self.centerView.frame.size.width];
    }
    self.textLabel.frame = self.centerView.bounds;
    
    
    if (self.centerView.superview != nil) {
        [self.centerView removeFromSuperview];
    }
    for (UIView *centerViewSubview in self.centerView.subviews) {
        [centerViewSubview removeFromSuperview];
    }
    for (int i = 0; i < self.centerView.subviews.count; i++) {
        UIView *view = [self.centerView.subviews objectAtIndex:i];
        view = nil;
    }
    
    // add center view
    [self addSubview:self.centerView];
    
    // center view defined by user
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(viewForCenterOfPercentageDoughnutView:withCenterView:)]) {
            [self.centerView addSubview:[self.dataSource viewForCenterOfPercentageDoughnutView:self
                                                                                withCenterView:self.centerView]];
        }
    }
    
    // add center label
    if (self.showTextLabel) {
        [self.centerView addSubview:self.textLabel];
        
        self.textLabel.backgroundColor            = [UIColor clearColor];
        self.textLabel.textAlignment              = NSTextAlignmentCenter;
        self.textLabel.adjustsFontSizeToFitWidth  = self.adjustsFontSizeAutomatically;
        self.textLabel.baselineAdjustment         = UIBaselineAdjustmentAlignCenters;
        
        if (self.textStyle != MCPercentageDoughnutViewTextStyleUserDefined) {
            self.textLabel.text = [NSString stringWithFormat:@"%.*f%%", (int)self.decimalPlaces, self.percentage*100];
        }
    }
}

#pragma mark Custom Setters

- (void)setPercentageDoughnutViewTextStyle:(MCPercentageDoughnutViewTextStyle)textStyle
{
    if (textStyle == MCPercentageDoughnutViewTextStyleUserDefined)
    {
        self.textLabel.text = @"";
    }
    
    _textStyle = textStyle;
}

- (void)setBorderPercentageForFilledArc:(CGFloat)borderPercentageForFilledArc
{
    _borderPercentageForFilledArc = [MCUtil verifyBoundsForValue:borderPercentageForFilledArc lowerBound:0 upperBound:1];
}

- (void)setBorderPercentageForUnfilledArc:(CGFloat)borderPercentageForUnfilledArc
{
    _borderPercentageForUnfilledArc = [MCUtil verifyBoundsForValue:borderPercentageForUnfilledArc lowerBound:0 upperBound:0.5];
}

- (void)setPercentage:(CGFloat)percentage
{
//    CGFloat oldPercentage = _percentage;
    
    if (percentage > 1.0) {
        percentage = 1.0;
    }
    if (percentage < 0) {
        percentage = 0;
    }
    
    if (self.textStyle == MCPercentageDoughnutViewTextStyleAutomaticShowsPercentage) {
        self.textLabel.text = [NSString stringWithFormat:@"%.*f%%", (int)self.decimalPlaces, percentage*100];
    }
    
    _percentage = percentage;
    [self reloadData];
}
    
@end

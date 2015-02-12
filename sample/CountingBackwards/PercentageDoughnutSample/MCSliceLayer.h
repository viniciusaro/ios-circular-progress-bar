//
//  MCSliceLayer.h
//  PercentageDoughnutView
//
//  Created by Vinícius Rodrigues on 5/12/2013.
//  Copyright (c) 2013 MyAppControls. All rights reserved.
//

#import "MCUtil.h"
#import "MCNewCustomLayer.h"

@protocol MCSliceLayerDelegate <NSObject>

@optional
- (void)animationDidStart:(CAAnimation *)anim;
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end

@interface MCSliceLayer : MCNewCustomLayer

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic) CGFloat center_x;
@property (nonatomic) CGFloat center_y;
@property (nonatomic) CGFloat value;

@property (nonatomic) CGFloat linePercentage;
@property (nonatomic) CGFloat strokePercentage;
@property (nonatomic) CGFloat textDistancePercentageFromCenter; //percentage of the radius

// value that defines witch percentage of the radius will
// each slice move away from the center when selected
// modifying this value automatically changes the
// external radius value, so that the slices are guaranteed to be
// inside the container view's bounds when selected
@property (nonatomic) CGFloat distancePercentageOnSelection;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *selectedTextColor;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;

@property (nonatomic) BOOL showText;
@property (nonatomic) CGFloat externalRadius;
@property (nonatomic) CGFloat internalRadius;

@property (strong, nonatomic) id<MCSliceLayerDelegate> arcDelegate;

@end

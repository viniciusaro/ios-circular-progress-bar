//
//  MCNewCustomLayer.h
//  MCCore
//
//  Created by Vinícius Rodrigues on 24/01/2014.
//  Copyright (c) 2014 MyAppControls. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MCNewCustomLayeredView;

typedef enum {
    MCNewCustomLayerSelectionStatusNotSelected,
    MCNewCustomLayerSelectionStatusSelected
} MCNewCustomLayerSelectionStatus;

typedef enum {
    MCNewCustomLayerImageBoundsFullRect,
    MCNewCustomLayerImageBoundsItemRect
} MCNewCustomLayerImageBoundsStyle;

@interface MCNewCustomLayer : CAShapeLayer

// drawing properties
@property (nonatomic) CGMutablePathRef mainPath;
@property (strong, nonatomic) UIImage* mainPathImage;
@property (strong, nonatomic) UILabel *textLabel;

// animation properties
@property (nonatomic) NSTimeInterval animationDuration;
@property (nonatomic) BOOL animationEnabled;
@property (nonatomic) BOOL isAllowedToAnimate;

// -------------------
@property (nonatomic) MCNewCustomLayerSelectionStatus selectionStatus;
@property (nonatomic) MCNewCustomLayerImageBoundsStyle imageBoundsStyle;
@property (nonatomic) CGFloat value;
@property (nonatomic, strong) id identifier;
@property (nonatomic, strong) MCNewCustomLayeredView *parentLayeredView;
@property (nonatomic) BOOL isPresentationLayer;


// initialization methods
- (void)setUp;
- (void)setDefaults;
- (id)initWithFrame:(CGRect)frame;


// animation methods ----------------------------------
// the keys listed on this array should be animated on value change
+ (NSArray*)animatableKeys;

// the keys listed on this array are not animated if
// they hold the default value (0).
+ (NSArray*)shouldNotAnimateKeysHoldingDefaultValue;
// animation methods ----------------------------------


// drawing methods
- (CGRect)mainPathImageBounds;
- (void)customDrawInContext:(CGContextRef)context;

@end

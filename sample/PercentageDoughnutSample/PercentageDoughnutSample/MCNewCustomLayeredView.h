//
//  MCNewCustomLayeredView.h
//  MCCore
//
//  Created by Vinícius Rodrigues on 24/01/2014.
//  Copyright (c) 2014 MyAppControls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MCNewCustomLayer.h"

@class MCNewCustomLayeredView;
@class MCNewCustomLayer;

@interface MCNewCustomLayeredView : UIView

@property (strong, nonatomic) MCNewCustomLayer *containerLayer;

/*
 Defines the duration of the animations.
 */
@property (nonatomic) NSTimeInterval animationDuration;

/*
 Defines weather the animations are enabled.
 */
@property (nonatomic) BOOL animationEnabled;

/*
 Defines the view should animate when is first drawn
 */
@property (nonatomic) BOOL animatesBegining;

//-------------------
/*
 Controlers that contain labels that can show numbers automatically (like the value of an item)
 can use this property to set the number of decimal places shown.
 */
@property (nonatomic) NSInteger decimalPlaces;

/*
 Defines weather multiple items can be selected at once.
 */
@property (nonatomic) BOOL allowsMultipleSelection;

/*
 Defines the bounds of the images shown at each item.
 MCNewCustomLayeredViewImageBoundsFullRect = the image will be drawn with the size of the controler's bouds and cliped to the bounds of the item
 MCNewCustomLayeredViewImageBoundsItemRect = the image will be drawn with the size of the item
 */
@property (nonatomic) MCNewCustomLayerImageBoundsStyle imageBoundsStyle;


// animation propertyes
@property (strong, nonatomic, readonly) NSMutableArray *layerCopies;
@property (nonatomic, readonly) BOOL firstDraw;


// custom layer management methods
/*
 Selects the item at the specified index
 */
- (void)selectItemAtIndex:(NSUInteger)index;

/*
 Deselects the item at the specified index
 */
- (void)deselectItemAtIndex:(NSUInteger)index;

/*
 Deselects all items
 */
- (void)deselectAllItems;

// drawing methods
/*
 Causes the control to redraw it self, calling all the data source methods
 to apply the new data.
 */
- (void)reloadData;

/*
 Animates the control
 */
- (void)animate;

@end

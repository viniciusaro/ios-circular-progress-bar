//
//  MCPercentageDoughnutView.h
//  MCPercentageDoughnutView
//
//  Created by Vinícius Rodrigues on 14/12/2013.
//  Copyright (c) 2013 MyAppControls. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCCore.h"

@class MCPercentageDoughnutView;

typedef enum {
    MCPercentageDoughnutViewTextStyleAutomaticShowsPercentage,
    MCPercentageDoughnutViewTextStyleUserDefined
} MCPercentageDoughnutViewTextStyle;

@protocol MCPercentageDoughnutViewDataSource <NSObject>

@required

/*
 Defines a view to be used in the center of the doughnut instead of the textLabel.
 It`s frame is automatically resized to fit the maximum space available on the center. The corners
 of the view will always touch the doughnut`s border.
 */
- (UIView*)viewForCenterOfPercentageDoughnutView:(MCPercentageDoughnutView*)pecentageDoughnutView
                                  withCenterView:(UIView*)centerView;

@end

@protocol MCPercentageDoughnutViewDelegate <NSObject>

@required

/*
 Method called on the delegate method when the percentage doughnut view is touched.
 The touches are only considered on the central layer.
 */
- (void)didSelectPercentageDoughnutView:(MCPercentageDoughnutView*)percentageDoughnut;

@end

@interface MCPercentageDoughnutView : MCNewCustomLayeredView

/*
 Sets the percentage of the view.
 */
@property (nonatomic) CGFloat percentage;

/*
 Sets the percentage of the view.
 */
@property (nonatomic) CGFloat initialPercentage;

/*
 Defines the border percentage for both filled and unfilled portions.
 */
@property (nonatomic) CGFloat borderPercentage;

/*
 The label of the text in the center of the doughnut.
 */
@property (nonatomic, retain) UILabel *textLabel;

/*
 The color for the filled portion of the doughnut.
 */
@property (nonatomic, retain) UIColor *fillColor;

/*
 The color for the unfilled portion of the doughnut.
 */
@property (nonatomic, retain) UIColor *unfillColor;

/*
 Defines the percentage of the rounded image will overlap the progress
 bars. Useful when using images with shadows.
 */
@property (nonatomic) CGFloat roundedImageOverlapPercentage;

/*
 The color for the border of the filled portion of the doughnut.
 */
@property (nonatomic, retain) UIColor *borderColorForFilledArc;

/*
 The color for the border of the of the unfilled portion of the doughnut.
 */
@property (nonatomic, retain) UIColor *borderColorForUnfilledArc;

/*
 Defines the image for the filled portion of the arc. If this property is set
 the color for the filled portion is ignored.
 */
@property (nonatomic, retain) UIImage *imageForFilledArc;

/*
 Defines the image for the unfilled portion of the arc. If this property is set
 the color for the unfilled portion is ignored.
 */
@property (nonatomic, retain) UIImage *imageForUnfilledArc;

/*
 Defines the image for the rounded background of the doughnut
 */
@property (nonatomic, retain) UIImage *roundedBackgroundImage;

/*
 Defines the image for the rounded background of the doughnut to be used when the
 doughnut is pushed. This image will replace the roundedBackgroundImage while
 the doughnut is being pressed.
 */
@property (nonatomic, retain) UIImage *roundedBackgroundImageForPushedState;

/*
 Defines the first gradient color for the filled segment. The gradient goes from
 gradientColor1 to gradientColor2 and ocuppies 40 degrees of the head of the
 segment. The size of the gradient is calculated by a cos function and it is max
 at 180 degrees and 0 at 0 degrees and 360 degrees.
 The most common use is to set this color to be the same as the fillColor.
 */
@property (nonatomic, strong) UIColor *gradientColor1;

/*
 Defines the second gradient color for the filled segment. The most common use is
 to set this color to be the same as the unfled segment's color.
 */
@property (nonatomic, strong) UIColor *gradientColor2;


/*
 Defines if the control should build a gradient at the head of the filled segment
 */
@property (nonatomic) BOOL enableGradient;

/*
 The percentage of the border of the filled portion of the doughnut.
 If this property is set, it is used for this arc instead of the value set on the borderPercentage property
 1: the full width of the arc is filled with the border.
 0: no border
 */
@property (nonatomic) CGFloat borderPercentageForFilledArc;

/*
 The percentage of the border of the unfilled portion of the doughnut.
 If this property is set, it is used for this arc instead of the value set on the borderPercentage property
 1: the full width of the arc is filled with the border.
 0: no border
 */
@property (nonatomic) CGFloat borderPercentageForUnfilledArc;

/*
 Defines the data source of the percentage doughnut
 */
@property (nonatomic, assign) id<MCPercentageDoughnutViewDataSource>dataSource;

/*
 Defines the delegate of the percentage doughnut
 */
@property (nonatomic, assign) id<MCPercentageDoughnutViewDelegate>delegate;

/*
 Defines the percentage of the doughnut related to the ratios of the doughnut. The ratios
 is defined by the frame of the view.
 1: full doughnut, no central space
 0: no doughnut
 */
@property (nonatomic) CGFloat linePercentage;

/*
 Defines if the text label in the center should appear or not
 */
@property (nonatomic) BOOL showTextLabel;

/*
 Defines if the text label should adjust it's font size automatically based
 on the percentage frame.
 Default: YES
 */
@property (nonatomic) BOOL adjustsFontSizeAutomatically;

/*
 MCPercentageDoughnutViewTextStyleAutomaticShowsPercentage: ignores the value set for the label and
 automatically updates the label based on the value of the percentage property.
 MCPercentageDoughnutViewTextStyleUserDefined: shows the value stored on the textLabel.text property.
 */
@property (nonatomic) MCPercentageDoughnutViewTextStyle textStyle;

/*
 Defines the pacing of the animation. To create a CAMediaTimingFunction object:
 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
 
 ----
 Possible function names:
 NSString * const kCAMediaTimingFunctionLinear;
 NSString * const kCAMediaTimingFunctionEaseIn;
 NSString * const kCAMediaTimingFunctionEaseOut;
 NSString * const kCAMediaTimingFunctionEaseInEaseOut;
 NSString * const kCAMediaTimingFunctionDefault;
 
 As described on the Apple documentation:
 https://developer.apple.com/library/mac/documentation/cocoa/reference/CAMediaTimingFunction_class/Introduction/Introduction.html
 
 ----
 The default value for this property is nil, which has the same effect as kCAMediaTimingFunctionDefault
 for this control.
 */
@property (nonatomic, strong) CAMediaTimingFunction *animationTimingFuncion;

@end

/*
 Most properties are mnemonic and pretty straightforward to be used. Custom types can be easily explored on the interface files provided.
 
 **Properties**
 
 *Sets the percentage of the view.*
 **@property (nonatomic) CGFloat percentage;**
 
 *Defines the border percentage for both filled and unfilled portions.*
 **@property (nonatomic) CGFloat borderPercentage;**
 
 *The label of the text in the center of the doughnut.*
 @property (nonatomic, retain) UILabel *textLabel;
 
 *The color for the filled portion of the doughnut.*
 **@property (nonatomic, retain) UIColor *fillColor;**
 
 *The color for the unfilled portion of the doughnut.*
 **@property (nonatomic, retain) UIColor *unfillColor;**
 
 *The color for the border of the filled portion of the doughnut.*
 **@property (nonatomic, retain) UIColor *borderColorForFilledArc;**
 
 *The color for the border of the of the unfilled portion of the doughnut.*
 **@property (nonatomic, retain) UIColor *borderColorForUnfilledArc;**
 
 *Defines the image for the filled portion of the arc. If this property is set
 the color for the filled portion is ignored.*
 **@property (nonatomic, retain) UIImage *imageForFilledArc;**
 
 *Defines the image for the unfilled portion of the arc. If this property is set
 the color for the unfilled portion is ignored.*
 **@property (nonatomic, retain) UIImage *imageForUnfilledArc;**
 
 *The percentage of the border of the filled portion of the doughnut.
 If this property is set, it is used for this arc instead of the value set on the borderPercentage property
 1: the full width of the arc is filled with the border.
 0: no border*
 **@property (nonatomic) CGFloat borderPercentageForFilledArc;**
 
 *The percentage of the border of the unfilled portion of the doughnut.
 If this property is set, it is used for this arc instead of the value set on the borderPercentage property
 1: the full width of the arc is filled with the border.
 0: no border*
 **@property (nonatomic) CGFloat borderPercentageForUnfilledArc;**
 
 *Defines the data source of the percentage doughnut*
 **@property (nonatomic, assign) id<MCPercentageDoughnutViewDataSource>dataSource;**
 
 *Defines the percentage of the doughnut related to the ratios of the doughnut. The ratios
 is defined by the frame of the view.
 1: full doughnut, no central space
 0: no doughnut*
 **@property (nonatomic) CGFloat linePercentage;**
 
 *Defines if the text label in the center should appear or not*
 **@property (nonatomic) BOOL showTextLabel;**
 
 *Possible values:
 MCPercentageDoughnutViewTextStyleAutomaticShowsPercentage: ignores the value set for the label and
 automatically updates the label based on the value of the percentage property.
 MCPercentageDoughnutViewTextStyleUserDefined: shows the value stored on the textLabel.text property.*
 **@property (nonatomic) MCPercentageDoughnutViewTextStyle textStyle;**
 */

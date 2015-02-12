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

typedef enum {
    MCPercentageDoughnutViewTextStyleAutomaticShowsPercentage,
    MCPercentageDoughnutViewTextStyleUserDefined
} MCPercentageDoughnutViewTextStyle;

@interface MCPercentageDoughnutView : MCNewCustomLayeredView

/*
 Sets the percentage of the view.
 */
@property (nonatomic) CGFloat percentage;

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

@end

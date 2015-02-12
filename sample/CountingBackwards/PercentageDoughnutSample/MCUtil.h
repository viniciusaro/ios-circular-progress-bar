//
//  MCUtil.h
//  PercentageDoughnut
//
//  Created by Vinícius Rodrigues on 20/11/2013.
//  Copyright (c) 2013 MyAppControls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#define DEG2RAD(angle) ((angle) / 180.0 * M_PI)
#define RAD2DEG(rad) (rad * 180.0 / M_PI)
#define D_360 359.99
#define D_2 2.00001

typedef void (^Block)();
typedef void (^BlockWithArgument)(id obj);

@interface MCUtil : NSObject

// rect methods
+ (CGRect)rectWithCenterOnOriginOfRect:(CGRect)rect;
+ (CGPoint)getCenterOfRect:(CGRect)rect;
+ (CGFloat)getMinRadiusOnRect:(CGRect)rect;
+ (CGFloat)getMinRadiusOnRect:(CGRect)rect withFactor:(CGFloat)factor;
+ (CGRect)getRectFromRect:(CGRect)rect withPadding:(CGFloat)padding;
+ (CGRect)getUpperSquareOnRect:(CGRect)rect;

// points
+ (CGFloat)getDistanceBetweenPoint1:(CGPoint)point1 and:(CGPoint)point2;
+ (CGPoint)getClosestPointFrom:(CGPoint)fromPoint between:(CGPoint)point1 and:(CGPoint)point2;
+ (CGPoint)getFurthestPointFrom:(CGPoint)fromPoint between:(CGPoint)point1 and:(CGPoint)point2;
+ (CGPoint)getPointFromAngle:(CGFloat)angle radius:(CGFloat)radius center:(CGPoint)center;

// thread managers
+ (void)runOnAuxiliaryQueue:(void(^)())thread_block;
+ (void)runOnAuxiliaryQueue:(void(^)())thread_block withCompletionBlock:(void(^)())completion_block;
+ (void)runOnMainQueue:(void(^)())thread_block;
+ (void)runOnMainQueue:(void(^)())thread_block withCompletionBlock:(void(^)())completion_block;

// log
+ (void)printRect:(CGRect)rect;
+ (NSString*)getRectLogString:(CGRect)rect;

// colors
+ (UIColor*)iOS7DefaultBlueColor;
+ (UIColor*)iOS7LightGrayColorForLines;
+ (UIColor*)iOS7DarkGrayColorForLines;
+ (UIColor*)iOS7DefaultGrayColorForBackground;
+ (UIImage *)imageWithColor:(UIColor *)color withRect:(CGRect)rect;

// flat ui colors
+ (UIColor*)flatTurquoiseColor;
+ (UIColor*)flatEmeraldColor;
+ (UIColor*)flatNephritsColor;
+ (UIColor*)flatPeterRiverColor;
+ (UIColor*)flatBelizeHoleColor;
+ (UIColor*)flatAmethystColor;
+ (UIColor*)flatWetAsphaltColor;
+ (UIColor*)flatSunFlowerColor;
+ (UIColor*)flatOrangeColor;
+ (UIColor*)flatCarrotColor;
+ (UIColor*)flatPumpkinColor;
+ (UIColor*)flatAlizarinColor;
+ (UIColor*)flatPomegranateColor;
+ (UIColor*)flatCloudsColor;

// bounds
+ (CGFloat)verifyPercentageBoundsForValue:(CGFloat)floatValue;
+ (CGFloat)verifyBoundsForValue:(CGFloat)floatValue lowerBound:(CGFloat)lowerBound upperBound:(CGFloat)upperBound;

// date
+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format;
+ (NSString*)stringFromDate:(NSDate*)date;

// log

@end

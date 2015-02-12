//
//  MCUtil.m
//  PercentageDoughnut
//
//  Created by Vinícius Rodrigues on 20/11/2013.
//  Copyright (c) 2013 MyAppControls. All rights reserved.
//

#import "MCUtil.h"

@implementation MCUtil

#pragma Rect Methods

+ (CGRect)rectWithCenterOnOriginOfRect:(CGRect)rect {
    CGRect centeredRect = CGRectMake(rect.origin.x-rect.size.width/2,
                                     rect.origin.y-rect.size.height/2,
                                     rect.size.width,
                                     rect.size.height);
    
    return centeredRect;
}

+ (CGPoint)getCenterOfRect:(CGRect)rect {
    return CGPointMake(rect.size.width/2, rect.size.height/2);
}

+ (CGFloat)getMinRadiusOnRect:(CGRect)rect {
    return [MCUtil getMinRadiusOnRect:rect withFactor:1.0];
}

+ (CGFloat)getMinRadiusOnRect:(CGRect)rect withFactor:(CGFloat)factor {
    return MIN(rect.size.width, rect.size.height)/2*factor;
}

+ (CGRect)getRectFromRect:(CGRect)rect withPadding:(CGFloat)padding {
    return CGRectInset(rect, padding, padding);
}

+ (CGRect)getUpperSquareOnRect:(CGRect)rect {
    CGFloat minDimension = MIN(rect.size.width, rect.size.height);
    CGFloat center_x = CGRectGetMidX(rect);
    return CGRectMake(center_x-minDimension/2, 0, minDimension, minDimension);
}

+ (void)printRect:(CGRect)rect {
    NSLog(@"rect = (%f, %f, %f, %f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

+ (NSString*)getRectLogString:(CGRect)rect {
    return [NSString stringWithFormat:@"(%f, %f, %f, %f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

#pragma mark Point Methods

+ (CGPoint)getClosestPointFrom:(CGPoint)fromPoint between:(CGPoint)point1 and:(CGPoint)point2 {
    CGFloat distance1 = [MCUtil getDistanceBetweenPoint1:fromPoint and:point1];
    CGFloat distance2 = [MCUtil getDistanceBetweenPoint1:fromPoint and:point2];
    
    if (distance1 < distance2) {
        return point1;
    }
    return point2;
}

+ (CGPoint)getFurthestPointFrom:(CGPoint)fromPoint between:(CGPoint)point1 and:(CGPoint)point2 {
    CGFloat distance1 = [MCUtil getDistanceBetweenPoint1:fromPoint and:point1];
    CGFloat distance2 = [MCUtil getDistanceBetweenPoint1:fromPoint and:point2];
    
    if (distance1 > distance2) {
        return point1;
    }
    return point2;
}

+ (CGFloat)getDistanceBetweenPoint1:(CGPoint)point1 and:(CGPoint)point2 {
    return sqrtf((point1.x-point2.x)*(point1.x-point2.x) + (point1.y-point2.y)*(point1.y-point2.y));
}

+ (CGPoint)getPointFromAngle:(CGFloat)angle radius:(CGFloat)radius center:(CGPoint)center {
    return CGPointMake(radius*cosf(angle)+center.x,
                       radius*cosf(angle)+center.y);
}

#pragma mark Thread Methods

+ (void)runOnAuxiliaryQueue:(void(^)())thread_block {
    [MCUtil runOnAuxiliaryQueue:thread_block withCompletionBlock:nil];
}

+ (void)runOnAuxiliaryQueue:(void(^)())thread_block withCompletionBlock:(void(^)())completion_block
{
    static int identifier = 0;
    NSString *stringId = [NSString stringWithFormat:@"Auxiliary queue %d", identifier++];
    
    dispatch_queue_t queue = dispatch_queue_create([stringId UTF8String], NULL);
    dispatch_async(queue, ^{
        thread_block();
        if (completion_block) {
            completion_block();
        }
    });
}

+ (void)runOnMainQueue:(void(^)())thread_block {
    [MCUtil runOnMainQueue:thread_block withCompletionBlock:nil];
}

+ (void)runOnMainQueue:(void(^)())thread_block withCompletionBlock:(void(^)())completion_block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        thread_block();
        if (completion_block) {
            completion_block();
        }
    });
}

#pragma mark Color Methods

+ (UIColor*)iOS7DefaultBlueColor {
    return [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
}

+ (UIColor*)iOS7LightGrayColorForLines {
    return [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];
}

+ (UIColor*)iOS7DarkGrayColorForLines {
    return [UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0];
}

+ (UIColor*)iOS7DefaultGrayColorForBackground {
    return [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
}

#pragma mark - Image methods

+ (UIImage *)imageWithColor:(UIColor *)color withRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)flippedImage:(UIImage*)image byAxis:(int)axis
{
    // 0 = x 1 = y
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(axis == 0){
        // Do nothing, X is flipped normally in a Core Graphics Context
    } else if(axis == 1){
        // fix X axis
        CGContextTranslateCTM(context, 0, image.size.height);
        CGContextScaleCTM(context, 1.0f, -1.0f);
        
        // then flip Y axis
        CGContextTranslateCTM(context, image.size.width, 0);
        CGContextScaleCTM(context, -1.0f, 1.0f);
    } else if(axis == 0){
        // just flip Y
        CGContextTranslateCTM(context, image.size.width, 0);
        CGContextScaleCTM(context, -1.0f, 1.0f);
    }
    
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, image.size.width, image.size.height), image.CGImage);
    
    UIImage *flipedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return flipedImage;
}

#pragma mark Flat UI Color Methods

+ (UIColor*)flatTurquoiseColor {
    // rgb(26, 188, 156)
    return [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:1.0];
}

+ (UIColor*)flatEmeraldColor {
    // rgb(46, 204, 113)
    return [UIColor colorWithRed:46.0/255.0 green:244.0/255.0 blue:113.0/255.0 alpha:1.0];
}

+ (UIColor*)flatNephritsColor {
    // rgb(39, 174, 96)
    return [UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:1.0];
}

+ (UIColor*)flatPeterRiverColor {
    // rgb(52, 152, 219)
    return [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
}

+ (UIColor*)flatBelizeHoleColor {
    // rgb(41, 128, 185)
    return [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0];
}

+ (UIColor*)flatAmethystColor {
    // rgb(155, 89, 182)
    return [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:1.0];
}

+ (UIColor*)flatWetAsphaltColor {
    // rgb(52, 73, 94)
    return [UIColor colorWithRed:52.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0];
}

+ (UIColor*)flatSunFlowerColor {
    // rgb(241, 196, 15)
    return [UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:1.0];
}

+ (UIColor*)flatOrangeColor {
    // rgb(243, 156, 18)
    return [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:1.0];
}

+ (UIColor*)flatCarrotColor {
    // rgb(230, 126, 34)
    return [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1.0];
}

+ (UIColor*)flatPumpkinColor {
    // rgb(211, 84, 0)
    return [UIColor colorWithRed:211.0/255.0 green:84.0/255.0 blue:0.0/255.0 alpha:1.0];
}

+ (UIColor*)flatAlizarinColor {
    // rgb(231, 76, 60)
    return [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0];
}

+ (UIColor*)flatPomegranateColor {
    // rgb(192, 57, 43)
    return [UIColor colorWithRed:192.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0];
}

+ (UIColor*)flatCloudsColor {
    // rgb(236, 240, 241)
    return [UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0];
}

#pragma mark Bounds Methods

+ (CGFloat)verifyPercentageBoundsForValue:(CGFloat)floatValue {
    return [MCUtil verifyBoundsForValue:floatValue lowerBound:0.0 upperBound:1.0];
}

+ (CGFloat)verifyBoundsForValue:(CGFloat)floatValue lowerBound:(CGFloat)lowerBound upperBound:(CGFloat)upperBound {
    if (floatValue > upperBound) {
        floatValue = upperBound;
    }
    if (floatValue < lowerBound) {
        floatValue = lowerBound;
    }
    
    return floatValue;
}

#pragma mark Date Methods

+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

+ (NSString*)stringFromDate:(NSDate*)date {
    return [MCUtil stringFromDate:date withFormat:@"dd/MM/yyyy"];
}

#pragma mark Log Methods


@end

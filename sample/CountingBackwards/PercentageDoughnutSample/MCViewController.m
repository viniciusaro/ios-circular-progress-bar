//
//  MCViewController.m
//  PercentageDoughnutSample
//
//  Created by Vinícius Rodrigues on 6/05/2014.
//  Copyright (c) 2014 MyAppControls. All rights reserved.
//

#import "MCViewController.h"

@interface MCViewController () {
    int currentValue;
    bool shouldStopCountDown;
}

@end

@implementation MCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentValue = 1000;
    shouldStopCountDown = NO;
    
    self.percentageDoughnut.textStyle               = MCPercentageDoughnutViewTextStyleUserDefined;
    self.percentageDoughnut.percentage              = 1;
    self.percentageDoughnut.linePercentage          = 0.15;
    self.percentageDoughnut.animationDuration       = 1;
    self.percentageDoughnut.showTextLabel           = YES;
    self.percentageDoughnut.animatesBegining        = YES;
    self.percentageDoughnut.textLabel.textColor     = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.percentageDoughnut.textLabel.text          = [NSString stringWithFormat:@"%d", currentValue];
    self.percentageDoughnut.textLabel.font          = [UIFont italicSystemFontOfSize:10];
}

- (IBAction)countDown:(id)sender
{
    currentValue -= 1;
    self.percentageDoughnut.textLabel.text = [NSString stringWithFormat:@"%d", currentValue];
    self.percentageDoughnut.percentage = (float)currentValue/1000.0;
}

- (IBAction)startAutomaticCountDown:(id)sender
{
    shouldStopCountDown = NO;
    
    [MCUtil runOnAuxiliaryQueue:^{
        while (currentValue > 0 && !shouldStopCountDown)
        {
            [MCUtil runOnMainQueue:^{
                [self countDown:nil];
            }];
            [NSThread sleepForTimeInterval:1];
        }
    }];
}

- (IBAction)stopAutomaticCountDown:(id)sender
{
    shouldStopCountDown = YES;
}
@end

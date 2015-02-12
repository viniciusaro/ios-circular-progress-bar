//
//  MCViewController.m
//  PercentageDoughnutSample
//
//  Created by Vinícius Rodrigues on 6/05/2014.
//  Copyright (c) 2014 MyAppControls. All rights reserved.
//

#import "MCViewController.h"

@interface MCViewController ()

@end

@implementation MCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.percentageDoughnut = [[MCPercentageDoughnutView alloc] initWithFrame:CGRectMake(15, 35, 289, 311)];
    
    self.percentageDoughnut.dataSource              = self;
    self.percentageDoughnut.percentage              = 0.5;
    self.percentageDoughnut.linePercentage          = 0.15;
    self.percentageDoughnut.animationDuration       = 2;
    self.percentageDoughnut.decimalPlaces           = 1;
    self.percentageDoughnut.showTextLabel           = YES;
    self.percentageDoughnut.animatesBegining        = NO;
    self.percentageDoughnut.fillColor               = [UIColor greenColor];
    self.percentageDoughnut.unfillColor             = [MCUtil iOS7DefaultGrayColorForBackground];
    self.percentageDoughnut.textLabel.textColor     = [UIColor blackColor];
    self.percentageDoughnut.textLabel.font          = [UIFont systemFontOfSize:50];
    self.percentageDoughnut.gradientColor1          = [UIColor greenColor];
    self.percentageDoughnut.gradientColor2          = [MCUtil iOS7DefaultGrayColorForBackground];
    
    [self.view addSubview:self.percentageDoughnut];
}

- (UIView*)viewForCenterOfPercentageDoughnutView:(MCPercentageDoughnutView *)pecentageDoughnutView
                                  withCenterView:(UIView *)centerView {

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *progressContentViewController = [storyboard instantiateViewControllerWithIdentifier:@"progressContent"];
//    progressContentViewController.view.frame = centerView.bounds;
//    
//    return progressContentViewController.view;
    
    // Uncomment to see an image example
    //*
     UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brazil-shape.png"]];
    imageView.frame = centerView.bounds;
    
    return imageView;
    //*/
    
    self.percentageDoughnut.showTextLabel = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:centerView.bounds];
    label.layer.borderWidth = 1;
    label.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:@"GB(59%)"];
    [s addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(0, 2)];
    [s addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(2, 3)];
    label.attributedText = s;
    
    return label;
}

- (IBAction)percentageSliderDidChangeValue:(id)sender
{
    UISlider *slider = sender;
    self.percentageDoughnut.percentage = slider.value;
    [self.percentageDoughnut reloadData];
}

- (IBAction)widthSliderDidChangeValue:(id)sender
{
    UISlider *slider = sender;
    self.percentageDoughnut.linePercentage = slider.value;
    [self.percentageDoughnut reloadData];
}

- (IBAction)showRoundedBackgroundImg:(id)sender
{
    UISwitch *sw = (UISwitch*)sender;
    
    if (sw.isOn) {
        self.percentageDoughnut.roundedBackgroundImage = [UIImage imageNamed:@"rounded-shadowed-background"];
        self.percentageDoughnut.roundedImageOverlapPercentage = 0.08;
    }
    else {
        self.percentageDoughnut.roundedBackgroundImage = nil;
        self.percentageDoughnut.roundedImageOverlapPercentage = 0;
    }
    
    [self.percentageDoughnut reloadData];
}

- (IBAction)showGradient:(id)sender
{
    UISwitch *sw = (UISwitch*)sender;
    self.percentageDoughnut.enableGradient = sw.isOn;
    [self.percentageDoughnut reloadData];
}

@end

//
//  MCViewController.h
//  PercentageDoughnutSample
//
//  Created by Vinícius Rodrigues on 6/05/2014.
//  Copyright (c) 2014 MyAppControls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPercentageDoughnutView.h"

@interface MCViewController : UIViewController <MCPercentageDoughnutViewDataSource>

@property (strong, nonatomic) MCPercentageDoughnutView *percentageDoughnut;

@property (weak, nonatomic) IBOutlet UISlider *widthSlider;
@property (weak, nonatomic) IBOutlet UISlider *percentageSlider;
@end

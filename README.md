# iOS Circular Progress Bar
The iOS Circular Progress Bar is a great tool to present percentage based information in an elegant and simple way. The default appearance conforms to the beautiful flat design and the center space can be personalized with custom views.

Demo video: https://www.youtube.com/watch?v=LRqptLlqtnM

More info at: http://myappcontrols.binpress.com/product/ios-circular-progress-bar/2016

![alt tag](http://myappcontrols.binpress.com/images/stores/store30934/captura-de-tela-2014-09-08-às-9.39.09-am.png)

## Installation

Add all files from the src folder to your project
Import as usual: #import "MCPercentageDoughnutView.h"
Add QuartzCore.framework to your project

## Setup

MCPercentageDoughnutView can be added to your view either from the Interface Builder or through code.

#### Interface Builder (Xcode 5):

* Open the Storyboard or Xib file you want to add the pie chart to.
* Drag a new UIView from the Object Library into your view controller.
* Resize and position your new UIView as you wish (the pie chart will be drawn on the center of the new UIView).
* Make sure the new UIView is selected and choose the Identity Inspector tab on Xcode's the Utilities view (on the right).
* Change the class from UIView to MCPercentageDoughnutView.
* On the view controller's header file create an IBOutlet property of the type MCPercentageDoughnutView and link it to the object you created on the Interface Builder.

#### Through Code:
```
CGRect frame = CGRectMake(x, y, width, height);
MCPercentageDoughnutView *percentageDoughnut = [[MCPercentageDoughnutView alloc] initWithFrame:frame];
[self.view addSubview:percentageDoughnut];
```

## Example Usage
```
self.percentageDoughnut.dataSource = self;
self.percentageDoughnut.linePercentage = 0.02;
self.percentageDoughnut.percentage = 0.5;
self.percentageDoughnut.animatesBegining = NO;
```

## Credits
Brought to you by [MyAppControls](http://www.binpress.com/profile/myappcontrols/30934) team.

## Similar Projects

[iOS Bar Chart](https://github.com/vinicius-a-ro/ios-bar-chart-view)

[iOS Simple Color Picker](https://github.com/vinicius-a-ro/ios-color-picker)

[iOS Pie Chart](https://github.com/vinicius-a-ro/ios-pie-chart-view)

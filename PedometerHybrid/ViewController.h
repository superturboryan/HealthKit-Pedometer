//
//  ViewController.h
//  PedometerHybrid
//
//  Created by Ryan David Forsyth on 2019-08-31.
//  Copyright © 2019 Ryan F. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthKitManager.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *todayStepCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *last13DaysStepCountLabel;

-(void) addGradientBG;

@end


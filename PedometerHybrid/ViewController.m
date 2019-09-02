//
//  ViewController.m
//  PedometerHybrid
//
//  Created by Ryan David Forsyth on 2019-08-31.
//  Copyright © 2019 Ryan F. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addGradientBG];
    
    [[HealthKitManager sharedInstance] getTodayStepTotal:^(NSNumber *stepCount) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self todayStepCountLabel] setText:[NSString stringWithFormat:@"Today's step count: %@", stepCount]];
        });
    }];
    
//    20th to 1st
    NSDate *rightNow = [NSDate date];
    NSDate *fourteenDaysAgo = [rightNow dateByAddingTimeInterval:-13*24*60*60];
    NSCalendar *cal = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *beginningOfFourteenDaysAgo = [cal startOfDayForDate:fourteenDaysAgo];
    NSDate *beginningOfToday = [cal startOfDayForDate: rightNow];
    
    [[HealthKitManager sharedInstance] getStepCountFrom:beginningOfFourteenDaysAgo To:beginningOfToday withHandler:^(NSNumber *stepCount) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self last13DaysStepCountLabel] setText:[NSString stringWithFormat:@"Last thirteen day's step count: %@", stepCount]];
        });
    }];
    
    
}

-(void) addGradientBG
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    UIColor *darkBlue = [UIColor colorWithRed:63.0/255.0 green:43.0/255.0 blue:150.0/255.0 alpha:1];
    UIColor *lightBlue = [UIColor colorWithRed:168.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1];
    gradient.colors = @[(id)lightBlue.CGColor, (id)darkBlue.CGColor];
    [self.view.layer insertSublayer:gradient atIndex:0];
}


@end

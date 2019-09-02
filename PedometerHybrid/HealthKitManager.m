//
//  HealthKitManager.m
//  PedometerHybrid
//
//  Created by Ryan David Forsyth on 2019-09-02.
//  Copyright © 2019 Ryan F. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthKitManager.h"

@interface HealthKitManager()

@property (nonatomic, strong) HKHealthStore *hkStore;

@end

@implementation HealthKitManager

- (id)init {
    self = [super init];
    if (self) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    return self;
}

+ (HealthKitManager *) sharedInstance
{
    static dispatch_once_t onceToken;
    static HealthKitManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[HealthKitManager alloc] init];
    });
    return instance;
}

- (void) requestToReadData
{
    if ([HKHealthStore isHealthDataAvailable]) {
        
        NSSet<HKObjectType *> *typesToRead = [self dataTypesToRead];
        
        [[self hkStore] requestAuthorizationToShareTypes:nil readTypes:typesToRead completion:^(BOOL success, NSError * _Nullable error) {
            
            if (!success) {
                NSLog(@"User denied permission to HealthKit!");
            }
            else {
                NSLog(@"User allowed permission!");
            }
        }];
    }
}

-(BOOL) checkPermissionStatus
{
    if ([[self hkStore] authorizationStatusForType:(HKObjectType*)HKQuantityTypeIdentifierStepCount] == HKAuthorizationStatusSharingAuthorized &&
        [[self hkStore] authorizationStatusForType:(HKObjectType*)HKQuantityTypeIdentifierFlightsClimbed] == HKAuthorizationStatusSharingAuthorized &&
        [[self hkStore] authorizationStatusForType:(HKObjectType*)HKQuantityTypeIdentifierDistanceWalkingRunning] == HKAuthorizationStatusSharingAuthorized){
        return YES;
    }
    else return NO;
}

- (NSSet *) dataTypesToRead
{
    HKQuantityType *stepCount = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *stairCount = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    HKQuantityType *distanceWalked = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    return [NSSet setWithObjects: stepCount, stairCount, distanceWalked, nil];
}

-(void) getTodayStepTotal:(void (^)(NSNumber* stepCount))completionHandler
{
    HKQuantityType *stepType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSDate *rightNow = [NSDate date];
    NSCalendar *cal = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *thisMorning = [cal startOfDayForDate:rightNow];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:thisMorning endDate:rightNow options:HKQueryOptionNone];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:stepType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
        
        double stepCount = [[result sumQuantity] doubleValueForUnit:[HKUnit countUnit]];
        
        NSNumber *stepCountForToday = [NSNumber numberWithDouble:stepCount];
        
        completionHandler(stepCountForToday);
    }];
    
    [[self hkStore] executeQuery:query];
}

-(void) getStepCountFrom:(NSDate*)start To:(NSDate*)end withHandler: (void (^)(NSNumber* stepCount))completionHandler
{
    HKQuantityType *stepType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:start endDate:end options:HKQueryOptionNone];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:stepType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
        
        double stepCount = [[result sumQuantity] doubleValueForUnit:[HKUnit countUnit]];
        
        NSNumber *stepCountForDateRange = [NSNumber numberWithDouble:stepCount];
        
        completionHandler(stepCountForDateRange);
    }];
    
    [[self hkStore] executeQuery:query];
}


@end

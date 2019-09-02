//
//  HealthKitManager.h
//  PedometerHybrid
//
//  Created by Ryan David Forsyth on 2019-09-02.
//  Copyright © 2019 Ryan F. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface HealthKitManager : NSObject

+ (HealthKitManager *)sharedInstance;

- (void)requestToReadData;

-(BOOL) checkPermissionStatus;

- (NSSet *)dataTypesToRead;

-(void)getTodayStepTotal:(void (^)(NSNumber* stepCount))completionHandler;

-(void) getStepCountFrom:(NSDate*)start To:(NSDate*)end withHandler: (void (^)(NSNumber* stepCount))completionHandler;

@end

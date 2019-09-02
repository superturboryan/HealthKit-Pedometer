//
//  AppDelegate.h
//  PedometerHybrid
//
//  Created by Ryan David Forsyth on 2019-08-31.
//  Copyright © 2019 Ryan F. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


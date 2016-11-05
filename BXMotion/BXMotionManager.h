//
//  BXMotionManager.h
//  BXMotion
//
//  Created by baixinpan on 16/10/24.
//  Copyright © 2016年 leopardpan. All rights reserved.
//

#import <Foundation/Foundation.h>

// the device state
typedef NS_ENUM(NSUInteger, ActivityStatus) {
    Unknown = 0,
    Stationary = 7, // not moving
    Walking = 1,
    Running = 2,
    Cycling = 3, // bicycle
    Automotive = 4, // vehicle
    
};

typedef void (^_BXMotionActivityBlock)(NSUInteger status, NSString *activity);
typedef void (^_BXMotionAccelerometerBlock)(double x,double y,double z);
typedef void (^_BXMotionGyroBlock)(double x,double y,double z);

@interface BXMotionManager : NSObject

// accelerometerUpdateInterval
@property (nonatomic, assign) NSTimeInterval alInterval;

@property (copy, nonatomic) _BXMotionActivityBlock motionActivityBlock;
@property (copy, nonatomic) _BXMotionAccelerometerBlock motionAccBlock;
@property (copy, nonatomic) _BXMotionAccelerometerBlock motionGyroBlock;

// call back motionActivityBlock
- (void)startActivity;
- (void)stopActivity;

// call back motionAccBlock
- (void)startAccelerometer;
- (void)stopAccelerometer;

- (void)startGyro;
- (void)stopGyro;

@end

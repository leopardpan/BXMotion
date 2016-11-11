//
//  BXMotionManager.m
//
//  Created by baixinpan on 16/10/24.
//  Copyright © 2016年 leopardpan. All rights reserved.
//

#import "BXMotionManager.h"
#import <CoreMotion/CoreMotion.h>

@interface BXMotionManager()

@property (strong, nonatomic) CMMotionActivityManager *activityManager;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) CMPedometer *pedometer;

@end

@implementation BXMotionManager

- (BOOL)checkMotionAuthorized {
    
    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
    NSString *value = info[@"NSMotionUsageDescription"];
    if (value) {
        return YES;
    } else {
        return NO;
    }
}

- (void)startActivity {
    
    if (![self checkMotionAuthorized]) {
        // LOG : please add NSMotionUsageDescription Key-Value  in  info.plist
        return;
    }
    if (!_activityManager) {
        _activityManager = [[CMMotionActivityManager alloc] init];
    }

    __weak __typeof(self)weakSelf = self;
    
    CMMotionActivityHandler handler = ^(CMMotionActivity *activity){
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if (strongSelf) {
                [strongSelf updateUIWithMotionActivity:activity];
            }
        });
    };
    [_activityManager startActivityUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
}

- (void)updateUIWithMotionActivity:(CMMotionActivity *)activity {
    
    ActivityStatus status = Unknown;
    
    if (activity.unknown) {
        status = Unknown;
    } else if (activity.stationary) {
        status = Stationary;
    } else if (activity.walking) {
        status = Walking;
    } else if (activity.running) {
        status = Running;
    } else if (activity.cycling) {
        status = Cycling;
    } else if (activity.automotive) {
        status = Automotive;
    }
    
    if (_motionActivityBlock) {
        _motionActivityBlock(status,[self activityStatusToString:status]);
    }
}

- (void)stopActivity {
    [self.activityManager stopActivityUpdates];
}

- (NSString *)activityStatusToString:(ActivityStatus)status {

    NSString *activity = @"Unknow";
    switch (status) {
        case Unknown:
            activity = @"Unknown";
        break;
        case Stationary:
            activity = @"Stationary";
        break;
        case Walking:
            activity = @"Walking";
        break;
        case Running:
            activity = @"Running";
        break;
        case Cycling:
            activity = @"Cycling";
        break;
        case Automotive:
            activity = @"Automotive";
        break;
            
        default:
            break;
    }
    
    return activity;
}

- (void)startGyro {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.gyroUpdateInterval = _gyroInterval;
    }
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {

                                        double x = gyroData.rotationRate.x;
                                        double y = gyroData.rotationRate.y;
                                        double z = gyroData.rotationRate.z;
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (_motionGyroBlock) {
                                                _motionGyroBlock(x,y,z);
                                            }
                                        });
                                    }];
}

- (void)stopGyro {
    [self.motionManager stopGyroUpdates];
}

- (void)startAccelerometer {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = _alInterval;
    }
    
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *latestAcc, NSError *error)
     {
         
         double x = latestAcc.acceleration.x;
         double y = latestAcc.acceleration.y;
         double z = latestAcc.acceleration.z;
         dispatch_async(dispatch_get_main_queue(), ^{
             if (_motionAccBlock) {
                 _motionAccBlock(x,y,z);
             }
         });
     }];
}

- (void)stopAccelerometer {
    [_motionManager stopAccelerometerUpdates];
}


- (void)startMagnetometer {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.magnetometerUpdateInterval = _magnetometerInterval;
    [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
        
        double x = magnetometerData.magneticField.x;
        double y = magnetometerData.magneticField.y;
        double z = magnetometerData.magneticField.z;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_motionMagnetometerBlock) {
                _motionMagnetometerBlock(x,y,z);
            }
        });
    }];
}

- (void)stopMagnetometer {
    [self.motionManager stopMagnetometerUpdates];
}


- (void)startPedometer {
    if ([CMPedometer isStepCountingAvailable]) {
        if (!_pedometer) {
            CMPedometer *pedometer = [[CMPedometer alloc]init];
            
            self.pedometer = pedometer;
        }
    }

    [_pedometer startPedometerEventUpdatesWithHandler:^(CMPedometerEvent * _Nullable pedometerEvent, NSError * _Nullable error) {
        
    }];
    [_pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        CMPedometerData *data=(CMPedometerData *)pedometerData;
        NSNumber *number = data.numberOfSteps;
        NSLog(@"number = %@",number);
        if (_motionPedometerBlock) {
            _motionPedometerBlock(number);
        }
    }];
}

- (void)stopPedometer {
    [_pedometer stopPedometerUpdates];
}
@end

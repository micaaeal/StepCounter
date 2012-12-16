//
//  Pedometer.m
//  StepCounter
//
//  Created by MacbookPro on 12/16/55 BE.
//  Copyright (c) 2555 Codegears. All rights reserved.
//

#import "Pedometer.h"

#import <CoreMotion/CoreMotion.h>

//Private
@interface  Pedometer()<UIAccelerometerDelegate>
{
    double _steps;
    
    NSOperationQueue* _queue;
    
    //Accelemeter
    CMMotionManager* _motionManager;
    double _filteredAcceleration[3];
    
    __weak NSObject<PedoMeterDelegate>* _delegate;
}
@end

@implementation Pedometer

static Pedometer* _instance = nil;

+(Pedometer*)sharedIntance {
    @synchronized([Pedometer class])
    {
        if(!_instance)
            _instance = [[self alloc] init];
        return _instance;
    }
    return nil;
}

+(id)alloc
{
    @synchronized ([Pedometer class])
    {
        NSAssert(_instance == nil, @"Attempted to allocated a second instance of the Data Manager singleton");
        
        _instance = [super alloc];
        
        return _instance;
    }
    return nil;
}


-(id)init {
    self = [super init];
    if (self != nil) {
        
        // Pedometer initialized
        NSLog(@"Pedometer Singleton, init");
        
        _steps = 0;
        
        _motionManager = [[CMMotionManager alloc] init]; // motionManager is an instance variable
        
        [_motionManager setDeviceMotionUpdateInterval:0.2f];// 0.01 = 100Hz
        [_motionManager setGyroUpdateInterval:0.2f];
        [_motionManager setMagnetometerUpdateInterval:0.2f];
        [_motionManager setAccelerometerUpdateInterval:0.2f];
        
        [_motionManager setShowsDeviceMovementDisplay:YES];
        
        
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void)SetDelegate:(__weak NSObject<PedoMeterDelegate>*)delegate{
    _delegate = delegate;
}

- (Boolean)start{
    if (![_motionManager isAccelerometerActive]) {
        [_motionManager startAccelerometerUpdatesToQueue:_queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            if (error) {
                NSLog(@"Error: %@",error);
            }else{
                //Update Data
               
                CMAcceleration ac = accelerometerData.acceleration;
                
                float violence = 1.2f;
                Boolean isStep = FALSE;
                
                if (ac.x > violence || ac.x < (-1 * violence))
                    isStep = TRUE;
                if (ac.y > violence || ac.y < (-1* violence))
                    isStep = TRUE;
                if (ac.z > violence || ac.z < (-1* violence))
                    isStep = TRUE;
                
                
                
                if (isStep) {
                    _steps++;
                    
                    if (_delegate) {
                        [_delegate performSelectorOnMainThread:@selector(DidStep:) withObject:[NSNumber numberWithDouble:_steps] waitUntilDone:NO];
                        
                        //[_delegate DidStep:_steps AccelX:ac.x AccelY:ac.y AccelZ:ac.z];
                    }
                }
                
            }
        }];
        
        
        return true;
    }
    
    
    return false;
}

- (void)stop{
    if ([_motionManager isAccelerometerActive]) {
        [_motionManager stopAccelerometerUpdates];
    }
}

- (double)getStepCount{
    return _steps;
}

-(void)dealloc{
    [_queue cancelAllOperations];
    _queue = nil;
    
    [_motionManager stopAccelerometerUpdates];
    _motionManager = nil;
}

- (void)reset{
    _steps = 0;
}


//deprecate
//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
//    const float violence = 1.2;
//    BOOL shake = FALSE;
//    
//    if (acceleration.x > violence || acceleration.x < (-1* violence))
//        shake = TRUE;
//    if (acceleration.y > violence || acceleration.y < (-1* violence))
//        shake = TRUE;
//    if (acceleration.z > violence || acceleration.z < (-1* violence))
//        shake = TRUE;
//    
//    if (shake) {
//        _steps = _steps + 1;
//    }
//}

@end

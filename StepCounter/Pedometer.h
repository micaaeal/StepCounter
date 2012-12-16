//
//  Pedometer.h
//  StepCounter
//
//  Created by MacbookPro on 12/16/55 BE.
//  Copyright (c) 2555 Codegears. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PedoMeterDelegate <NSObject>
- (void) DidStep:(NSNumber*)step;
@end

@interface Pedometer : NSObject

+ (Pedometer*) sharedIntance;

- (void)SetDelegate:(NSObject<PedoMeterDelegate>*)delegate;

- (Boolean)start;
- (void)stop;

- (double)getStepCount;

- (void)reset;

@end

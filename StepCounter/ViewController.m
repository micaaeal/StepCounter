//
//  ViewController.m
//  StepCounter
//
//  Created by MacbookPro on 12/13/55 BE.
//  Copyright (c) 2555 Codegears. All rights reserved.
//

#import "ViewController.h"

#import "Pedometer.h"

@interface ViewController ()
<PedoMeterDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [btStart setEnabled:YES];
    [btStop setEnabled:NO];
    
    [[Pedometer sharedIntance] SetDelegate:self];
}

- (void)DidStep:(NSNumber*)step{
    [lblStepCount setText:[NSString stringWithFormat:@"%f", step.doubleValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    lblStepCount = nil;
    
    btStop = nil;
    btStart = nil;
    [super viewDidUnload];
}
- (IBAction)actionStart:(id)sender {
    
    if( [[Pedometer sharedIntance] start] == TRUE){
        [btStart setEnabled:NO];
        [btStop setEnabled:YES];
    }
}

- (IBAction)actionStop:(id)sender {
    
    [[Pedometer sharedIntance] stop];
    [btStop setEnabled:NO];
    [btStart setEnabled:YES];
}
@end

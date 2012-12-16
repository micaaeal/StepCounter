//
//  ViewController.h
//  StepCounter
//
//  Created by MacbookPro on 12/13/55 BE.
//  Copyright (c) 2555 Codegears. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    __weak IBOutlet UILabel *lblStepCount;
    
    __weak IBOutlet UIButton *btStart;
    __weak IBOutlet UIButton *btStop;
}

- (IBAction)actionStart:(id)sender;
- (IBAction)actionStop:(id)sender;

@end

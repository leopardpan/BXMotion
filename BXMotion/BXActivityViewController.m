//
//  BXActivityViewController.m
//  BXMotion
//
//  Created by baixinpan on 16/11/5.
//  Copyright © 2016年 pan. All rights reserved.
//

#import "BXActivityViewController.h"
#import "BXMotionManager.h"


@interface BXActivityViewController ()

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@property (nonatomic, strong) BXMotionManager *motionManager;

@end

@implementation BXActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMotionManager];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.motionManager stopActivity];
}

- (void)setMotionManager {
    
    BXMotionManager *motionManager = [[BXMotionManager alloc] init];
    self.motionManager = motionManager;
    
    [motionManager setMotionActivityBlock:^(NSUInteger status, NSString *activity) {
        if (![self.displayLabel.text isEqualToString:@"--"] && (status == 0)) {
            
        } else {
            self.displayLabel.text = activity;
        }
    }];
}
- (IBAction)startAction:(UIButton *)sender {
    if (!sender.selected) {
        [self.motionManager startActivity];
        [sender setTitle:@"停止" forState:UIControlStateNormal];
    } else {
        [self.motionManager stopActivity];
        [sender setTitle:@"开始" forState:UIControlStateNormal];
    }
    sender.selected = !sender.selected;
}



@end

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

@property (weak, nonatomic) IBOutlet UILabel *displayStepCounter;

@property (nonatomic, strong) BXMotionManager *motionManager;

@end

@implementation BXActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMotionManager];
    
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    // 监听有物品靠近还是离开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange) name:UIDeviceProximityStateDidChangeNotification object:nil];

    // Do any additional setup after loading the view.
}

- (void)proximityStateDidChange
{
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"有物品靠近");
    } else {
        NSLog(@"有物品离开");
    }
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
            dispatch_async(dispatch_get_main_queue(), ^{
                self.displayLabel.text = activity;
            });
        }
    }];
    
    [motionManager setMotionPedometerBlock:^(NSNumber *number){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.displayStepCounter.text = [NSString stringWithFormat:@"已走 %@ 步",number];
        });
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

- (IBAction)startSetpAction:(UIButton *)sender {
    if (!sender.selected) {
        [self.motionManager startPedometer];
        [sender setTitle:@"停止" forState:UIControlStateNormal];
    } else {
        [self.motionManager stopPedometer];
        [sender setTitle:@"开始" forState:UIControlStateNormal];
    }
    sender.selected = !sender.selected;
}


@end

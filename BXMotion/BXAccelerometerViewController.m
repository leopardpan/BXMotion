//
//  BXAccelerometerViewController.m
//  BXMotion
//
//  Created by baixinpan on 16/11/5.
//  Copyright © 2016年 pan. All rights reserved.
//

#import "BXAccelerometerViewController.h"
#import "BXLineChart.h"
#import "BXMotionManager.h"

@interface BXAccelerometerViewController ()

@property (weak, nonatomic) IBOutlet BXLineChart *xLineChart;
@property (weak, nonatomic) IBOutlet BXLineChart *yLineChart;
@property (weak, nonatomic) IBOutlet BXLineChart *zLineChart;

@property (nonatomic, strong) BXMotionManager *motionManager;

@property (nonatomic, strong) NSMutableArray *xArray;
@property (nonatomic, strong) NSMutableArray *yArray;
@property (nonatomic, strong) NSMutableArray *zArray;

@end

@implementation BXAccelerometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMotionManager];
    _xArray = [NSMutableArray array];
    _yArray = [NSMutableArray array];
    _zArray = [NSMutableArray array];
    
    [self setup];
    
    // Do any additional setup after loading the view.
}

- (void)setup {
    [self loadChartWithDates:_xLineChart];
    [self loadChartWithDates:_yLineChart];
    [self loadChartWithDates:_zLineChart];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.motionManager stopAccelerometer];
}

- (void)loadChartWithDates:(BXLineChart *)chartWithDates {

    // Setting up the line chart
    chartWithDates.verticalGridStep = 6;
    chartWithDates.horizontalGridStep = 3;
    chartWithDates.fillColor = nil;
    chartWithDates.animationDuration = 0;
//    chartWithDates.displayDataPoint = NO;
    chartWithDates.dataPointColor = [UIColor redColor];
//    chartWithDates.dataPointBackgroundColor = [UIColor fsDarkGray];
    chartWithDates.dataPointRadius = 2;
    chartWithDates.color = [chartWithDates.dataPointColor colorWithAlphaComponent:0.3];
    chartWithDates.valueLabelPosition = ValueLabelLeftMirrored;
    chartWithDates.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.02f ", value];
    };
}

- (void)setMotionManager {
    
    BXMotionManager *motionManager = [[BXMotionManager alloc] init];
    self.motionManager = motionManager;
    
    motionManager.alInterval = 0.5;
    
    [motionManager setMotionAccBlock:^(double x, double y, double z) {

        NSNumber *xNumber = [NSNumber numberWithFloat:x];
        [self.xArray addObject:xNumber];
        [_xLineChart setChartData:self.xArray];
        
        NSNumber *yNumber = [NSNumber numberWithFloat:y];
        [self.yArray addObject:yNumber];
        [_yLineChart setChartData:self.yArray];
        
        NSNumber *zNumber = [NSNumber numberWithFloat:z];
        [self.zArray addObject:zNumber];
        [_zLineChart setChartData:self.zArray];
        
    }];
    
    [motionManager setMotionActivityBlock:^(NSUInteger status, NSString *activity) {

    }];
}

- (IBAction)startAction:(UIButton *)sender {
    if (!sender.selected) {
        [self.motionManager startAccelerometer];
        [sender setTitle:@"停止" forState:UIControlStateNormal];
    } else {
        [self.motionManager stopAccelerometer];
        [sender setTitle:@"开始" forState:UIControlStateNormal];
    }
    sender.selected = !sender.selected;
}


@end

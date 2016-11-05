//
//  BXGyroViewController.m
//  BXMotion
//
//  Created by baixinpan on 16/11/5.
//  Copyright © 2016年 pan. All rights reserved.
//

#import "BXGyroViewController.h"
#import "BXLineChart.h"
#import "BXMotionManager.h"

@interface BXGyroViewController ()
@property (weak, nonatomic) IBOutlet BXLineChart *xLineChart;
@property (weak, nonatomic) IBOutlet BXLineChart *yLineChart;
@property (weak, nonatomic) IBOutlet BXLineChart *zLineChart;

@property (nonatomic, strong) BXMotionManager *motionManager;

@property (nonatomic, strong) NSMutableArray *xArray;
@property (nonatomic, strong) NSMutableArray *yArray;
@property (nonatomic, strong) NSMutableArray *zArray;

@end

@implementation BXGyroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMotionManager];
    _xArray = [NSMutableArray array];
    _yArray = [NSMutableArray array];
    _zArray = [NSMutableArray array];
    
    [self loadChartWithDates:_xLineChart];
    [self loadChartWithDates:_yLineChart];
    [self loadChartWithDates:_zLineChart];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.motionManager stopGyro];
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
    
    motionManager.alInterval = 1;
    
    [motionManager setMotionGyroBlock:^(double x, double y, double z) {
        //        NSString *str = [NSString stringWithFormat:@"x = %f, y = %f, z = %f",x,y,z];
        
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
}

- (IBAction)startAction:(UIButton *)sender {
    if (!sender.selected) {
        [self.motionManager startGyro];
        [sender setTitle:@"停止" forState:UIControlStateNormal];
    } else {
        [self.motionManager stopGyro];
        [sender setTitle:@"开始" forState:UIControlStateNormal];
    }
    sender.selected = !sender.selected;
}

@end

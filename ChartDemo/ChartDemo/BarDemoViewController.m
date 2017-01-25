//
//  BarDemoViewController.m
//  ChartDemo
//
//  Created by Dzy on 18/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "BarDemoViewController.h"
#import <Charts/Charts-Swift.h>
#import <AFNetworking/AFNetworking.h>

@interface BarDemoViewController () <ChartViewDelegate,IChartAxisValueFormatter>

@property (weak, nonatomic) IBOutlet BarChartView *chartView;

@end

@implementation BarDemoViewController

#pragma mark ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    
}

#pragma mark IChartAxisValueFormatter
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {

    if (axis == _chartView.xAxis) {
        return @"x";
    } else if (axis == _chartView.leftAxis) {
        return @"l";
    }else {
        return @"r";
    }

}

- (void)loadData:(NSArray *)array {

    //倒序
    NSArray *tmp = [[array reverseObjectEnumerator] allObjects];
    
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:10];

//    self.date = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = tmp[i];
        double y = 100-[dic[@"Low"] doubleValue];
      
        if (y > 0) {
            [colors addObject:[UIColor redColor]];
        }else if(y==0){
            [colors addObject:[UIColor blueColor]];
        }else {
            [colors addObject:[UIColor greenColor]];
        }
        
        BarChartDataEntry * entity = [[BarChartDataEntry alloc]initWithX:i y:ABS(y)];
        [data addObject:entity];
    }
    
    BarChartDataSet *set = [[BarChartDataSet alloc] initWithValues:data label:nil];
    set.drawValuesEnabled = NO;//禁止柱形图 数字的显示
    set.colors = colors;
    
    BarChartData *chartdata = [[BarChartData alloc] initWithDataSet:set];
    _chartView.data = chartdata;
    
    [_chartView animateWithXAxisDuration:0.1];

}

- (void)loadDatas {
    
    [[AFHTTPSessionManager manager] GET:@"http://www.youbicaifu.com/index.php/home/tape/seleAdDayKline/type_id/17/code/601001" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject[@"data"][@"all_daykey"]);
        NSArray *arr = responseObject[@"data"][@"all_daykey"];
        [self loadData:arr];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _chartView.noDataText = @"loading...";
    _chartView.chartDescription.enabled = NO;
    _chartView.legend.enabled = NO;//隐藏色块
    _chartView.scaleYEnabled = NO;
    _chartView.delegate = self;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的数据显示位置，默认是显示在上面的
    xAxis.labelCount = 4;
    xAxis.axisMinimum = 0.0;
    xAxis.valueFormatter = self;// 侧边数据显示内容样式
    xAxis.drawGridLinesEnabled = NO;//
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.valueFormatter = self;// 侧边数据显示内容样式
    leftAxis.drawZeroLineEnabled = YES;// 设置零线
    leftAxis.zeroLineColor = [UIColor whiteColor];
    leftAxis.labelPosition = YAxisLabelPositionInsideChart;
    leftAxis.drawGridLinesEnabled = NO;
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.valueFormatter = self;// 侧边数据显示内容样式
    rightAxis.labelPosition = YAxisLabelPositionInsideChart;
    rightAxis.drawGridLinesEnabled = NO;

    [self loadDatas];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

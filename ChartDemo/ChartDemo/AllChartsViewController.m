//
//  AllChartsViewController.m
//  ChartDemo
//
//  Created by Dzy on 17/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "AllChartsViewController.h"
#import <Charts/Charts-Swift.h>
#import <AFNetworking/AFNetworking.h>

#define ITEM_COUNT 12

@interface AllChartsViewController () <ChartViewDelegate, IChartAxisValueFormatter>
{
    NSArray<NSString *> *months;
}

@property (weak, nonatomic) IBOutlet CombinedChartView *chartView1;
@property (weak, nonatomic) IBOutlet CombinedChartView *chartView;

@property (nonatomic ) NSMutableArray *data;
@property (nonatomic ) NSMutableArray *date;
@property (nonatomic,strong) UILabel * markY;

@end

@implementation AllChartsViewController

- (UILabel *)markY{
    if (!_markY) {
        _markY = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 25)];
        _markY.font = [UIFont systemFontOfSize:15.0];
        _markY.textAlignment = NSTextAlignmentCenter;
        _markY.text =@"";
        _markY.textColor = [UIColor whiteColor];
        _markY.backgroundColor = [UIColor grayColor];
    }
    return _markY;
}

- (void)configChartViewWith:(CombinedChartView *)chartView {

    chartView.delegate = self;
    chartView.noDataText = @"";
    chartView.scaleYEnabled = NO;
    chartView.chartDescription.enabled = NO;
    chartView.drawGridBackgroundEnabled = NO;
    chartView.drawBarShadowEnabled = NO;
    chartView.highlightFullBarEnabled = NO;
    chartView.drawOrder = @[
                             @(CombinedChartDrawOrderBar),
                             @(CombinedChartDrawOrderCandle),
                             @(CombinedChartDrawOrderLine)
                             ];
    chartView.pinchZoomEnabled = YES;//手势缩放
    chartView.doubleTapToZoomEnabled = NO;//取消双击缩放
    chartView.dragEnabled = YES;//启用拖拽图标
    chartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    chartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    ChartLegend *l = chartView.legend;
    l.enabled = NO;
    //[chartView.xAxis setAxisLineWidth:30];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    months = @[
               @"Jan", @"Feb", @"Mar",
               @"Apr", @"May", @"Jun",
               @"Jul", @"Aug", @"Sep",
               @"Oct", @"Nov", @"Dec"
               ];
    
    [self configChartViewWith:_chartView];
    [self configChartViewWith:_chartView1];

//    l.wordWrapEnabled = YES;
//    l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
//    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
//    l.orientation = ChartLegendOrientationHorizontal;
//    l.drawInside = NO;
//    
//    ChartYAxis *rightAxis = _chartView.rightAxis;
//    rightAxis.drawGridLinesEnabled = NO;
//    rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
//    
//    ChartYAxis *leftAxis = _chartView.leftAxis;
//
//    leftAxis.drawZeroLineEnabled = YES;
//    leftAxis.drawLabelsEnabled = NO;
//    leftAxis.drawAxisLineEnabled = NO;
//    leftAxis.drawGridLinesEnabled = NO;
//
//    ChartXAxis *xAxis = _chartView.xAxis;
//    xAxis.labelPosition = XAxisLabelPositionBottom;
//    xAxis.granularity = 1.0;
//    xAxis.valueFormatter = self;
    
    ChartMarkerView *markerY = [[ChartMarkerView alloc] init];
    markerY.offset = CGPointMake(-999, -8);
    markerY.chartView = _chartView;
    _chartView.marker = markerY;
    [markerY addSubview:self.markY];
    
    [self loadDatas];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CandleChartData *)loadCandleChartData:(NSArray *)array {
    self.data  = [NSMutableArray arrayWithArray:array];
    //倒序
    NSArray *tmp = [[array reverseObjectEnumerator] allObjects];
    
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
    self.date = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = tmp[i];
        CandleChartDataEntry * entity = [[CandleChartDataEntry alloc]init];
        entity.high = [dic[@"High"] doubleValue];
        entity.open = [dic[@"Open"] doubleValue];
        entity.low = [dic[@"Low"] doubleValue];
        entity.close = [dic[@"Close"] doubleValue];
        [self.date addObject:[NSString stringWithFormat:@"%@",dic[@"Data"]]];
        entity.x = i;

        [data addObject:entity];
    }
    
    CandleChartDataSet *set1 = [[CandleChartDataSet alloc] initWithValues:data label:nil];
    set1.axisDependency = AxisDependencyLeft;
    
    set1.shadowColor = UIColor.darkGrayColor;
    set1.shadowWidth = 0.5;
    
    set1.decreasingColor = UIColor.redColor;
    set1.decreasingFilled = YES;
    
    set1.increasingColor = [UIColor greenColor];
    set1.increasingFilled = NO;

    
    // 隐藏柱形图上边的数值
    set1.drawValuesEnabled = NO;
    
    set1.neutralColor = UIColor.blueColor;
    
    CandleChartData *chartdata = [[CandleChartData alloc] initWithDataSet:set1];
    
    return chartdata;
    
}

- (BarChartData *)loadBarChartData:(NSArray *)array {
    
    //倒序
    NSArray *tmp = [[array reverseObjectEnumerator] allObjects];
    
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:10];
    
    //    self.date = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = tmp[i];
        double y = 100-[dic[@"Low"] doubleValue];
        BarChartDataEntry * entity = [[BarChartDataEntry alloc]initWithX:i y:y];
    
        [data addObject:entity];
        
        if (y > 0) {
            [colors addObject:[UIColor redColor]];
        }else if(y==0){
            [colors addObject:[UIColor blueColor]];
        }else {
            [colors addObject:[UIColor greenColor]];
        }
        
    }
    
    BarChartDataSet *set = [[BarChartDataSet alloc] initWithValues:data label:nil];
    set.drawValuesEnabled = NO;//禁止柱形图 数字的显示
    set.colors = colors;
    
    BarChartData *chartdata = [[BarChartData alloc] initWithDataSet:set];
    return chartdata;
    
}

- (LineChartData *)loadData:(NSArray *)array {
    
    self.data  = [NSMutableArray arrayWithArray:array];
    //倒序
    NSArray *tmp = [[array reverseObjectEnumerator] allObjects];
    
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *data1 = [NSMutableArray arrayWithCapacity:10];

    self.date = [NSMutableArray arrayWithCapacity:10];

    
    NSMutableArray *kdata = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *ddata = [NSMutableArray arrayWithCapacity:10];
    
    double rsv = 0.0;
    double k = 50.0;
    double d = 50.0;
    double j = 0.0;
    
    for (int i = 0; i < array.count; i++) {
        
        NSDictionary *dic = tmp[i];

        [self.date addObject:[NSString stringWithFormat:@"%@",dic[@"Data"]]];

        double low = [dic[@"Low"] doubleValue];
        double high = [dic[@"High"] doubleValue];

        //        当日K值=2/3×前一日K值+1/3×当日RSV
        //        当日D值=2/3×前一日D值+1/3×当日K值
        //        J值=3*当日K值-2*当日D值
        
        if (i==0) {
            
            rsv = (50- low) / (high - low) * 100;

            k = 1/3*rsv + 2/3*k;
            d = 2/3*d - 1/3*k;
            
            [kdata addObject:[NSString stringWithFormat:@"%f",k]];
            [ddata addObject:[NSString stringWithFormat:@"%f",d]];

        }else {
            
            NSDictionary *dict = tmp[i-1];
            double close = [dict[@"Close"] doubleValue];
            rsv = (close - low) / (high - low) * 100;
            
            double k1 = [kdata[i-1] doubleValue];
            double d1 = [ddata[i-1] doubleValue];
            
            k = 1/3*rsv + 2/3*k1;
            d = 2/3*d1 - 1/3*k;

            [kdata addObject:[NSString stringWithFormat:@"%f",k]];
            [ddata addObject:[NSString stringWithFormat:@"%f",d]];

        }
        
        j = 3*k - 2*d;        
        
        ChartDataEntry * entity = [[ChartDataEntry alloc]init];
        entity.x = i;
        entity.y = k;
        [data addObject:entity];
        
        ChartDataEntry * entity1 = [[ChartDataEntry alloc]init];
        entity1.x = i;
        entity1.y = d;
        [data1 addObject:entity1];
        
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:data];
    set.colors = @[[UIColor purpleColor]];
    set.lineWidth = 1;
    set.highlightColor = [UIColor redColor];// 十字线颜色
//    set.circleRadius = 0.5;
//    set.circleColors = @[[UIColor purpleColor]];
    // 隐藏柱形图上边的数值
    set.drawValuesEnabled = NO;
    
    //折线拐点样式
    set.drawCirclesEnabled = NO;//是否绘制拐点
    set.drawFilledEnabled = NO;//是否填充颜色
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues:data1];
    set1.colors = @[[UIColor yellowColor]];
    set1.lineWidth = 1;
    set1.circleRadius = 0.5;
    set1.circleColors = @[[UIColor yellowColor]];
    // 隐藏柱形图上边的数值
    set1.drawValuesEnabled = NO;
    
    LineChartData *chartdata = [[LineChartData alloc] initWithDataSets:@[set,set1]];
    return chartdata;
    
}

- (void)loadDatas {
    
    [[AFHTTPSessionManager manager] GET:@"http://www.youbicaifu.com/index.php/home/tape/seleAdDayKline/type_id/17/code/601001" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject[@"data"][@"all_daykey"]);
        
        NSArray *arr = responseObject[@"data"][@"all_daykey"];
        
        CombinedChartData *data = [[CombinedChartData alloc] init];

        //data.lineData = [self loadData:arr];
        //data.barData = [self loadBarChartData:arr];
        data.candleData = [self loadCandleChartData:arr];
        
        _chartView.xAxis.axisMaximum = data.xMax + 0.25;
        _chartView.data = data;
        
        //[_chartView animateWithXAxisDuration:0.1];
        
        _chartView1.data = data;
        //[_chartView1 animateWithXAxisDuration:0.1];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

 
    
}

- (void)scrollWithChartView:(ChartViewBase * _Nonnull)chartView {

    ChartViewPortHandler *portHandler = chartView.viewPortHandler;
    float scaleX = portHandler.scaleX;
    float scaleY = portHandler.scaleY;
    float xValue = portHandler.contentCenter.x;
    float yValue = portHandler.contentCenter.y;
    
    [_chartView zoomWithScaleX:scaleX scaleY:scaleY x:xValue y:yValue];
    CGAffineTransform matrix = portHandler.touchMatrix;
    [portHandler setZoomWithScaleX:scaleX scaleY:scaleY x:xValue y:yValue];
    [_chartView.viewPortHandler refreshWithNewMatrix:matrix chart:chartView invalidate:YES];
    
}

#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    
    [chartView getMarkerPositionWithHighlight:highlight];
    
    _markY.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)entry.y];
    
    // 点击 表格移动 至中心
    [_chartView1 centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:0.3];
    [_chartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:0.3];

}

- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    
    NSLog(@" - %f",scaleX);
    
    [self scrollWithChartView:chartView];

}

- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY {

    [self scrollWithChartView:chartView];

}
- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    
    NSLog(@"chartValueNothingSelected");
}

#pragma mark - IAxisValueFormatter
- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    return months[(int)value % months.count];
}

@end

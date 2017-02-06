//
//  ViewController.m
//  ChartDemo
//
//  Created by Dzy on 17/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "ViewController.h"

#import <Charts/Charts-Swift.h>
#import <AFNetworking/AFNetworking.h>

@interface ViewController () <ChartViewDelegate,IChartAxisValueFormatter,IChartHighlighter>

@property (nonatomic ) NSMutableArray *date;
@property (nonatomic ) NSMutableArray *data;

@property (weak, nonatomic) IBOutlet CandleStickChartView *candleView;
//CandleStickChart
@end

@implementation ViewController

- (ChartHighlight *)getHighlightWithX:(CGFloat)x y:(CGFloat)y {

    ChartHighlight *highlight = [[ChartHighlight alloc] initWithX:x y:y dataSetIndex:x];
    highlight.drawX = x;
    highlight.drawY = y;
    highlight.dataIndex = x;
    return highlight;
    
}

- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
    
    if (axis == _candleView.xAxis) {
        return self.date[(int)value % self.date.count];
    }else {
        return @"123";
    }

}

- (void)loadData:(NSArray *)array {
    self.data  = [NSMutableArray arrayWithArray:array];
    //倒序
    NSArray *tmp = [[array reverseObjectEnumerator] allObjects];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:10];
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
        
        NSString *open = [dic[@"Open"] stringValue];
        NSString *close = [dic[@"Close"] stringValue];
        BOOL result = [open compare:close] == NSOrderedDescending;
        NSLog(@"result:%d",result);
        switch ([open compare:close]) {
            case NSOrderedAscending:
                [colors addObject:[UIColor greenColor]];
                break;
            case NSOrderedSame:
                [colors addObject:[UIColor blueColor]];
                break;
            case NSOrderedDescending:
                [colors addObject:[UIColor redColor]];
                break;
            default:
                break;
        }
        //字符串对比：NSOrderedAscending(升序),NSOrderedSame（同序）,NSOrderedDescending（降序）
        //NSOrderedDescending 判断两对象值的大小(按字母顺序进行比较，string02小于string01为真)
        
    }
    
    CandleChartDataSet *set1 = [[CandleChartDataSet alloc] initWithValues:data label:nil];
    set1.axisDependency = AxisDependencyLeft;
    set1.colors = colors;
    set1.drawHorizontalHighlightIndicatorEnabled = NO;
    set1.drawVerticalHighlightIndicatorEnabled = NO;
    set1.highlightColor = [UIColor darkGrayColor];

    // 可以自定义 颜色 
//    set1.shadowColor = UIColor.darkGrayColor;
//    set1.shadowWidth = 0.5;
//    
//    set1.decreasingColor = UIColor.redColor;
//    set1.decreasingFilled = YES;
//    
//    set1.increasingColor = [UIColor greenColor];
//    set1.increasingFilled = NO;
    
    // 隐藏柱形图上边的数值
    set1.drawValuesEnabled = NO;

    set1.neutralColor = UIColor.blueColor;
    
    CandleChartData *chartdata = [[CandleChartData alloc] initWithDataSet:set1];
    _candleView.data = chartdata;
    [_candleView animateWithXAxisDuration:0.5];

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

    [self loadDatas];
    
    _candleView.scaleYEnabled = NO;//纵向不进行缩放
    _candleView.chartDescription.enabled = NO;// 不显示描述
    _candleView.noDataText = @"loading...";
    _candleView.delegate = self;
    _candleView.borderLineWidth = 0.5;
    _candleView.drawBordersEnabled = YES;
//    _candleView.highlightPerTapEnabled = NO;
    _candleView.pinchZoomEnabled = YES;
    _candleView.doubleTapToZoomEnabled = NO;
    
    //    _candleView.highlighter = self;

    //    _candleView.leftAxis.drawLabelsEnabled = NO;
    _candleView.legend.enabled = NO;//隐藏色块
    
    ChartXAxis *xAxis = _candleView.xAxis;
    //    xAxis.axisLineWidth = 0.5;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    //    xAxis.drawGridLinesEnabled = NO;//不绘制网格线
    xAxis.labelTextColor = [UIColor brownColor];//label文字颜色
//    xAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
//    xAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
//    xAxis.gridAntialiasEnabled = YES;//开启抗锯齿
    xAxis.labelCount = 4;
    xAxis.axisMinimum = 0.0;
    xAxis.granularity = 1.0;
    xAxis.valueFormatter = self;// 侧边数据显示内容样式
    
    ChartYAxis *ayAxis = _candleView.rightAxis;
    ayAxis.labelCount = 4;
//    yAxis.enabled = NO;//不显示右侧数据列表
    ayAxis.labelPosition = YAxisLabelPositionInsideChart;
    ayAxis.drawGridLinesEnabled = NO;//隐藏线
    ayAxis.valueFormatter = self;
    //左边Y轴样式
    ChartYAxis *leftAxis = _candleView.leftAxis;//获取左边Y轴
//    leftAxis.enabled = NO;
//    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.labelCount = 4;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
    
    leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
    leftAxis.axisMinValue = 0;//设置Y轴的最小值
//    leftAxis.axisMaxValue = 105;//设置Y轴的最大值
    leftAxis.inverted = NO;//是否将Y轴进行上下翻转
//    leftAxis.axisLineWidth = 0.5;//Y轴线宽
//    leftAxis.axisLineColor = [UIColor blackColor];//Y轴颜色
    leftAxis.labelPosition = YAxisLabelPositionInsideChart;//label位置设置为内部
    leftAxis.labelTextColor = [UIColor brownColor];//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体

    //网格线样式
//    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
//    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
//    leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [_candleView addGestureRecognizer:longpress];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
//    [_candleView addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view, typically from a nib.
}

//- (void)clickTap:(UITapGestureRecognizer *)tap {
//    NSLog(@"x %f",[tap locationInView:self.view].x);
//
//}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    
//    NSLog(@"x %f",[longPress locationInView:self.view].x);
    
}

#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    CandleChartDataEntry *config = (CandleChartDataEntry *)entry;
    NSLog(@"chartValueSelected %f   %f %f",highlight.x,highlight.y,config.low);
//    NSLog(@"%@",self.data[(int)highlight.x]);
    
    for (UIGestureRecognizer *tap in chartView.gestureRecognizers) {
//        [tap locationInView:self.view];
        CGPoint point = [tap locationInView:self.view];
        if ([tap isKindOfClass:[UITapGestureRecognizer class]]) {
            if (tap.state == UIGestureRecognizerStateEnded) {
                NSLog(@"x %f   y %f",point.x,point.y);
            }
        }
    }
    
}

// 捏合手势
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    
    CandleStickChartView *view = (CandleStickChartView *) chartView;
    NSLog(@"%f",view.scaleX);

    // 设施缩放比例
//    [_candleView zoomToCenterWithScaleX:1.5 scaleY:1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CandleChartData *)setData {
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 40; i++)
    {
        double mult = (10 + 1);
        double val = (double) (arc4random_uniform(40)) + mult;
        double high = (double) (arc4random_uniform(9)) + 5.0;
        double low = (double) (arc4random_uniform(9)) + 6.0;
        double open = (double) (arc4random_uniform(6)) + 1.0;
        double close = (double) (arc4random_uniform(6)) + 1.0;
        BOOL even = i % 2 == 0;
        
        [yVals1 addObject:[[CandleChartDataEntry alloc] initWithX:i shadowH:val + high shadowL:val - low open:even ? val + open : val - open close:even ? val - close : val + close]];
    }
    
    CandleChartDataSet *set1 = [[CandleChartDataSet alloc] initWithValues:yVals1 label:nil];
    
    set1.axisDependency = AxisDependencyLeft;
    
    [set1 setColor:[UIColor colorWithWhite:80/255.f alpha:1.f]];
    
    set1.shadowColor = UIColor.darkGrayColor;
    set1.shadowWidth = 0.5;
    
    set1.decreasingColor = UIColor.redColor;
    set1.decreasingFilled = YES;
    
    set1.increasingColor = [UIColor colorWithRed:122/255.f green:242/255.f blue:84/255.f alpha:1.f];
    set1.increasingFilled = NO;
    
    // 隐藏柱形图上边的数值
    set1.drawValuesEnabled = NO;
    
    set1.neutralColor = UIColor.blueColor;
    
    CandleChartData *data = [[CandleChartData alloc] initWithDataSet:set1];
    
    return data;
    
}


@end

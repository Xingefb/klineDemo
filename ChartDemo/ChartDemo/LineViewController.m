//
//  LineViewController.m
//  ChartDemo
//
//  Created by Dzy on 19/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "LineViewController.h"

#import <Charts/Charts-Swift.h>
#import <AFNetworking/AFNetworking.h>

#import "ComputeTool.h"

@interface LineViewController () <IChartAxisValueFormatter>

@property (weak, nonatomic) IBOutlet BarChartView *barChartView;

@property (weak, nonatomic) IBOutlet LineChartView *chartView;
@property (nonatomic ) NSMutableArray *data;
@property (nonatomic ) NSMutableArray *date;

@property (nonatomic,strong) UILabel * markY;

@end

@implementation LineViewController

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    return self.date[(int)value % self.date.count];
}

- (void)loadData:(NSArray *)array {
    
    self.data  = [NSMutableArray arrayWithArray:array];
    self.date = [NSMutableArray arrayWithCapacity:10];

    NSArray *tmp = [[array reverseObjectEnumerator] allObjects];
    
    NSMutableArray *dataK = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *dataD = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *dataJ = [NSMutableArray arrayWithCapacity:10];

    NSMutableArray *dataDIF = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *dataDEA = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *dataMACD = [NSMutableArray arrayWithCapacity:10];

    NSMutableArray *dataMA5 = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *dataMA10 = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *dataMA30 = [NSMutableArray arrayWithCapacity:10];

    NSMutableArray *kTmpData = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *dTmpData = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *jTmpData = [NSMutableArray arrayWithCapacity:10];

    NSMutableArray *ma5TmpData = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *ma10TmpData = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *ma30TmpData = [NSMutableArray arrayWithCapacity:10];

    NSMutableArray *EMA12TmpData = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *EMA26TmpData = [NSMutableArray arrayWithCapacity:10];
//    NSMutableArray *DIFData = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *DEATmpData = [NSMutableArray arrayWithCapacity:10];
//    NSMutableArray *MACDData = [NSMutableArray arrayWithCapacity:10];

    //MARK: 常量
    double k = 50.0;
    double d = 50.0;
    double j = 50.0;
    
    NSString *kValue = @"";
    NSString *dValue = @"";
    NSString *jValue = @"";
    
    NSString *oneThree = [ComputeTool computeWithOpration:@"/" leftNumber:@"1" rightNumber:@"3" type:NSRoundUp];
    NSString *twoThree = [ComputeTool computeWithOpration:@"/" leftNumber:@"2" rightNumber:@"3" type:NSRoundUp];
    
    NSString *ema12Num1 = [ComputeTool computeWithOpration:@"/" leftNumber:@"11" rightNumber:@"13" type:NSRoundUp];
    NSString *ema12Num2 = [ComputeTool computeWithOpration:@"/" leftNumber:@"2" rightNumber:@"13" type:NSRoundUp];
    NSString *ema26Num1 = [ComputeTool computeWithOpration:@"/" leftNumber:@"25" rightNumber:@"27" type:NSRoundUp];
    NSString *ema26Num2 = [ComputeTool computeWithOpration:@"/" leftNumber:@"2" rightNumber:@"27" type:NSRoundUp];
    
    NSString *deaNum1 = [ComputeTool computeWithOpration:@"/" leftNumber:@"8" rightNumber:@"10" type:NSRoundUp];
    NSString *deaNum2 = [ComputeTool computeWithOpration:@"/" leftNumber:@"2" rightNumber:@"10" type:NSRoundUp];
    
    for (int i = 0; i < tmp.count; i++) {
        
        NSDictionary *dic = tmp[i];
//        NSLog(@" -  %@",dic);
        NSString * low = [NSString stringWithFormat:@"%@",dic[@"Low"]];
        NSString * high = [NSString stringWithFormat:@"%@",dic[@"High"]];
        NSString * close = [NSString stringWithFormat:@"%@",dic[@"Close"]];
        
        NSString *Cn_Ln =  [ComputeTool computeWithOpration:@"-" leftNumber:close rightNumber:low type:NSRoundUp];
        NSString *Hn_Ln =  [ComputeTool computeWithOpration:@"-" leftNumber:high rightNumber:low type:NSRoundUp];
        NSString *ClHl =  [ComputeTool computeWithOpration:@"/" leftNumber:Cn_Ln rightNumber:Hn_Ln type:NSRoundUp];
        NSString *Rsv =  [ComputeTool computeWithOpration:@"*" leftNumber:ClHl rightNumber:@"100" type:NSRoundUp];
        
        NSString *EMA12 = @"";
        NSString *EMA26 = @"";
        NSString *DIF = @"";
        NSString *DEA = @"";
        NSString *MACD = @"";
        
//        NSLog(@"rsv %@",Rsv);
        
        if (i==0) {
            
            kValue = [ComputeTool computeWithOpration:@"*" leftNumber:twoThree rightNumber:@"50" type:NSRoundUp];
            k = [kValue doubleValue];
            NSString *num = [ComputeTool computeWithOpration:@"*" leftNumber:oneThree rightNumber:@"50" type:NSRoundUp];
            dValue = [ComputeTool computeWithOpration:@"+" leftNumber:kValue rightNumber:num type:NSRoundUp];
            d = [dValue doubleValue];
// 初始值 EMA12  EMA26 = 当日收盘价
            EMA12 = close;
            EMA26 = close;
            DIF = [ComputeTool computeWithOpration:@"-" leftNumber:EMA12 rightNumber:EMA26 type:NSRoundUp];
            DEA = @"0";
            MACD= @"0";
            
        }else {
            
            NSString * oldK = kTmpData[i-1];
            NSString * oldD = dTmpData[i-1];

            NSString *oldEMA12 = EMA12TmpData[i-1];
            NSString *oldEMA26 = EMA12TmpData[i-1];
            NSString *oldDEA = DEATmpData[i-1];
            
            // MARK: EMA12
            NSString *ema12a = [ComputeTool computeWithOpration:@"*" leftNumber:ema12Num1 rightNumber:oldEMA12 type:NSRoundUp];
            NSString *ema12b = [ComputeTool computeWithOpration:@"*" leftNumber:ema12Num2 rightNumber:close type:NSRoundUp];
            EMA12 = [ComputeTool computeWithOpration:@"+" leftNumber:ema12a rightNumber:ema12b type:NSRoundUp];
            
            // MARK: EMA26
            NSString *ema26a = [ComputeTool computeWithOpration:@"*" leftNumber:ema26Num1 rightNumber:oldEMA26 type:NSRoundUp];
            NSString *ema26b = [ComputeTool computeWithOpration:@"*" leftNumber:ema26Num2 rightNumber:close type:NSRoundUp];
            EMA26 = [ComputeTool computeWithOpration:@"+" leftNumber:ema26a rightNumber:ema26b type:NSRoundUp];
            
            // MARK: DIF line
            DIF = [ComputeTool computeWithOpration:@"-" leftNumber:EMA12 rightNumber:EMA26 type:NSRoundUp];
            
            // MARK: DEA line
            NSString *dea1 = [ComputeTool computeWithOpration:@"*" leftNumber:oldDEA rightNumber:deaNum1 type:NSRoundUp];
            NSString *dea2 = [ComputeTool computeWithOpration:@"*" leftNumber:DIF rightNumber:deaNum2 type:NSRoundUp];
            DEA = [ComputeTool computeWithOpration:@"+" leftNumber:dea1 rightNumber:dea2 type:NSRoundUp];
            
            //MARK: MACD line
            NSString *macd1 = [ComputeTool computeWithOpration:@"-" leftNumber:DIF rightNumber:DEA type:NSRoundUp];
            MACD = [ComputeTool computeWithOpration:@"*" leftNumber:macd1 rightNumber:@"2" type:NSRoundUp];
            
            //MARK: K line
            NSString *kNum1 = [ComputeTool computeWithOpration:@"*" leftNumber:twoThree rightNumber:oldK type:NSRoundUp];
            NSString *kNum2 = [ComputeTool computeWithOpration:@"*" leftNumber:oneThree rightNumber:Rsv type:NSRoundUp];
            kValue = [ComputeTool computeWithOpration:@"+" leftNumber:kNum1 rightNumber:kNum2 type:NSRoundUp];
            k = [kValue doubleValue];
            
            //MARK: D line
            NSString *dNum1 = [ComputeTool computeWithOpration:@"*" leftNumber:twoThree rightNumber:oldD type:NSRoundUp];
            NSString *dNum2 = [ComputeTool computeWithOpration:@"*" leftNumber:oneThree rightNumber:kValue type:NSRoundUp];
            dValue = [ComputeTool computeWithOpration:@"+" leftNumber:dNum1 rightNumber:dNum2 type:NSRoundUp];
            d = [dValue doubleValue];
            
        }
        
        // MARK: J line
        NSString *jNum1 = [ComputeTool computeWithOpration:@"*" leftNumber:@"3" rightNumber:kValue type:NSRoundUp];
        NSString *jNum2 = [ComputeTool computeWithOpration:@"*" leftNumber:@"2" rightNumber:dValue type:NSRoundUp];
        jValue = [ComputeTool computeWithOpration:@"-" leftNumber:jNum1 rightNumber:jNum2 type:NSRoundUp];

        j = [jValue doubleValue];
        
        [kTmpData addObject:kValue];
        [dTmpData addObject:dValue];
        [jTmpData addObject:jValue];
        
        [EMA12TmpData addObject:EMA12];
        [EMA26TmpData addObject:EMA26];
        [DEATmpData addObject:DEA];
        
        [self.date addObject:[NSString stringWithFormat:@"%@",dic[@"Data"]]];
        
        // MARK: MA5
        [ma5TmpData addObject:close];
        
        dataMA5 = [self configMANumbersWith:i andTmpArray:ma5TmpData andMAData:dataMA5 andMANumber:@"5"];
        
        // MARK: MA10
        [ma10TmpData addObject:close];
        dataMA10 = [self configMANumbersWith:i andTmpArray:ma10TmpData andMAData:dataMA10 andMANumber:@"10"];
        
        // MARK: MA30
        [ma30TmpData addObject:close];
        dataMA30 = [self configMANumbersWith:i andTmpArray:ma30TmpData andMAData:dataMA30 andMANumber:@"30"];
        
        ChartDataEntry * entityk = [self configWithX:i andY:k];
        [dataK addObject:entityk];
        
        ChartDataEntry * entityd = [self configWithX:i andY:d];
        [dataD addObject:entityd];
        
        ChartDataEntry * entityj = [self configWithX:i andY:j];
        [dataJ addObject:entityj];
        
        ChartDataEntry * entityDIF = [self configWithX:i andY:[DIF doubleValue]];
        [dataDIF addObject:entityDIF];
        
        ChartDataEntry * entityDEA = [self configWithX:i andY:[DEA doubleValue]];
        [dataDEA addObject:entityDEA];
        
        ChartDataEntry * entityMACD = [self configWithX:i andY:[MACD doubleValue]];
        [dataMACD addObject:entityMACD];
        
    }
    
    LineChartDataSet *setMA5 = [self configWith:dataMA5 andColor:[UIColor redColor]];
    LineChartDataSet *setMA10 = [self configWith:dataMA10 andColor:[UIColor brownColor]];
    LineChartDataSet *setMA30 = [self configWith:dataMA30 andColor:[UIColor orangeColor]];

    LineChartDataSet *setK = [self configWith:dataK andColor:[UIColor whiteColor]];
    LineChartDataSet *setD = [self configWith:dataD andColor:[UIColor yellowColor]];
    LineChartDataSet *setJ = [self configWith:dataJ andColor:[UIColor purpleColor]];

    LineChartDataSet *setDIF = [self configWith:dataDIF andColor:[UIColor greenColor]];
    LineChartDataSet *setDEA = [self configWith:dataDEA andColor:[UIColor blueColor]];
    LineChartDataSet *setMACD = [self configWith:dataMACD andColor:[UIColor orangeColor]];
    
    LineChartData *chartdata = [[LineChartData alloc] initWithDataSets:@[setK,setD,setJ,setDIF,setDEA,setMACD,setMA5,setMA10,setMA30]];
    
    _chartView.data = chartdata;
    [_chartView animateWithXAxisDuration:0.3];
    
}

//MARK: Config MA
- (NSMutableArray *)configMANumbersWith:(int )i andTmpArray:(NSArray *)tmpArray andMAData:(NSMutableArray *)maData andMANumber:(NSString *)number{

    int ma = [number intValue] - 1;
    
    if (i >= ma) {
        NSString *total = @"0";
        for (int l = i; l >= (i-ma); l--) {
            total = [ComputeTool computeWithOpration:@"+" leftNumber:total rightNumber:tmpArray[l] type:NSRoundUp];
        }
        NSString *ma5 = [ComputeTool computeWithOpration:@"/" leftNumber:total rightNumber:number type:NSRoundUp];
        ChartDataEntry * entity = [self configWithX:i andY:[ma5 doubleValue]];
        [maData addObject:entity];
    }
    
    return maData;

}

// MARK:Config DataSet
- (LineChartDataSet *)configWith:(NSArray *)data andColor:(UIColor *)color{

    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:data];
    set.colors = @[color];
    set.lineWidth = 1;
    set.highlightColor = [UIColor darkGrayColor];
    set.drawCirclesEnabled = NO;//是否绘制拐点
    set.drawFilledEnabled = NO;//是否填充颜色
    set.drawValuesEnabled = NO;
    return set;
    
}

// MARK:Config DataEntry
- (ChartDataEntry *)configWithX:(double)x andY:(double)y {
    
    ChartDataEntry * entity = [[ChartDataEntry alloc]init];
    entity.x = x;
    entity.y = y;
    return entity;

}

- (void)loadDatas {
    
    [[AFHTTPSessionManager manager] GET:@"http://www.youbicaifu.com/index.php/home/tape/seleAdDayKline/type_id/17/code/601001" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *arr = responseObject[@"data"][@"all_daykey"];
        [self loadData:arr];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configChartView];
    [self configMarkerView];
    [self config_xAxis];
    [self config_yAxis];
    [self loadDatas];
    
    // Do any additional setup after loading the view.
}

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

- (void)config_yAxis {
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.labelCount = 4;
    leftAxis.labelPosition = YAxisLabelPositionInsideChart;
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.labelCount = 4;
    rightAxis.labelPosition = YAxisLabelPositionInsideChart;
    
}

- (void)config_xAxis {
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.labelCount = 4;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.valueFormatter = self;
    
}

- (void)configMarkerView {
    
    ChartMarkerView *markerY = [[ChartMarkerView alloc] init];
    markerY.offset = CGPointMake(-999, -12.5);
    markerY.chartView = _chartView;
    _chartView.marker = markerY;
    [markerY addSubview:self.markY];
    
}

- (void)configChartView {
    
    _chartView.noDataText = @"loading...";
    _chartView.legend.enabled = NO;
    _chartView.chartDescription.enabled = NO;
    _chartView.scaleYEnabled = NO;
    _chartView.drawGridBackgroundEnabled = YES;
    
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

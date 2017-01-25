//
//  LineViewController.h
//  ChartDemo
//
//  Created by Dzy on 19/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineViewController : UIViewController


/*
 
 在国内股市中，常利用的移动平均线组合为5日（黄色）、10日（紫色）、30日（绿色）、60日（白色）、120日（蓝色）、250日（红色）线。
 
 KDJ 计算方式
 
 9日RSV=（C－L9）÷（H9－L9）×100
 公式中，C为第9日的收盘价；L9为9日内的最低价；H9为9日内的最高价。
 K值 = 2/3×第8日K值 + 1/3×第9日RSV
 D值=2/3×第8日D值 + 1/3×第9日K值
 若无前一日K值与D值，则可以分别用50代替。
 J值=3*第9日K值-2*第9日D值   2*k1 + rsv - 2*d1 + k
 
 k: 白
 d：黄
 j：紫
 
 MACD 计算方式
 
 初始EMA（12）= 初始EMA（26）= 计算周期内第一个交易日的收盘价 ******
 
 12日EMA的计算：
 EMA（12） = 前一日EMA（12） X 11/13 + 今日收盘价 X 2/13
 26日EMA的计算：
 EMA（26） = 前一日EMA（26） X 25/27 + 今日收盘价 X 2/27
 
 差离值（DIF）的计算：
 DIF = EMA（12） - EMA（26） 。
 根据差离值计算其9日的EMA，即离差平均值，是所求的DEA值。为了不与指标原名相混淆，此值又名DEA或DEM。
 
 今日DEA = （前一日DEA X 8/10 + 今日DIF X 2/10）
 
 用（DIF-DEA）*2即为MACD柱状图。
 故MACD指标是由两线一柱组合起来形成，快速线为DIF，慢速线为DEA，柱状图为MACD。在各类投资中，有以下方法供投资者参考：
 
 */

/*
 
 
 if (i==0) {
 
 if (high == low) {
 rsv = 0;
 }else {
 rsv = (50.0- low) / (high - low) * 100.0;
 }
 
 if (rsv==0) {
 rsv = 0;
 k = 2/3*50;
 }else {
 k = 1/3*rsv + 2/3*k;
 }
 d = 2/3*d - 1/3*k;
 
 [kdata addObject:[NSString stringWithFormat:@"%.2f",k]];
 [ddata addObject:[NSString stringWithFormat:@"%.2f",d]];
 
 }else {
 
 NSDictionary *dict = tmp[i-1];
 double close = [dict[@"Close"] doubleValue];
 
 if (high == low || close == low) {
 rsv = 0;
 }else {
 rsv = (close - low) / (high - low) * 100;
 }
 
 double k1 = [kdata[i-1] doubleValue];
 double d1 = [ddata[i-1] doubleValue];
 
 if (rsv==0.0) {
 rsv = 0.0;
 k = 2/3*k;
 }else {
 k = 1/3*rsv + 2/3*k1;
 }
 
 d = 2/3*d1 - 1/3*k;
 
 [kdata addObject:[NSString stringWithFormat:@"%f",k]];
 [ddata addObject:[NSString stringWithFormat:@"%f",d]];
 
 }
 //        NSLog(@"%f    %f   %f",k,d,rsv);
 
 j = 3*k - 2*d;
 
 
 switch (i) {
 case 0:
 close
 break;
 case 1:
 close
 close - 1
 break;
 case 2:
 close
 close - 1
 close - 2
 break;
 case 3:
 close
 close - 1
 close - 2
 close - 3
 break;
 default:
 break;
 }
 
 if (i >= 4) {
 
 close
 dataMACD[i-1];
 dataMACD[i-2];
 dataMACD[i-3];
 dataMACD[i-4];
 
 }

  
 
 //        if (i>=4) {
 //            NSString *total = @"0";
 //            for (int l = i; l >= (i-4); l--) {
 //                total = [ComputeTool computeWithOpration:@"+" leftNumber:total rightNumber:ma5TmpData[l] type:NSRoundUp];
 //            }
 //            NSString *ma5 = [ComputeTool computeWithOpration:@"/" leftNumber:total rightNumber:@"5" type:NSRoundUp];
 //            ChartDataEntry * entity = [self configWithX:i andY:[ma5 doubleValue]];
 //            [dataMA5 addObject:entity];
 //        }
 
 */
@end

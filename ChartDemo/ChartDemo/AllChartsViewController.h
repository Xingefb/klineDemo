//
//  AllChartsViewController.h
//  ChartDemo
//
//  Created by Dzy on 17/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllChartsViewController : UIViewController

/*
 
 DIFF : EMA(CLOSE,SHORT) - EMA(CLOSE,LONG);
 DEA  : EMA(DIFF,M);
 MACD : 2*(DIFF-DEA);
 
 EMA（12）= 前一日EMA（12）×11/13＋今日收盘价×2/13
 EMA（26）= 前一日EMA（26）×25/27＋今日收盘价×2/27
 
 DIFF=今日EMA（12）- 今日EMA（26）
 DEA（MACD）= 前一日DEA×8/10＋今日DIF×2/10
 BAR=2×(DIFF－DEA)
 
 对理工检测： 20091218日：
 新股上市，DIFF=0, DEA=0, MACD=0， 收盘价55.01 20091219日：     收盘价53.7
 
 EMA（12）=55.01+(53.7-55.01)×2/13=54.8085
 EMA（26）=55.01+(53.7-55.01)×2/27=54.913
 
 DIFF=EMA（12）- EMA（26）= 54.8085 - 54.913 = -0.1045  （-0.104？）
 DEA=0+(-0.1045)X2/10=-0.0209
 BAR=2*((-0.1045)-(-0.0209))=-0.1672
 
 */

@end

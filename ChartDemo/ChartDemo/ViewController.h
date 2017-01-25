//
//  ViewController.h
//  ChartDemo
//
//  Created by Dzy on 17/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
/*
 
 AdjClose = 190;
 Close = 190;
 Data = "2016-06-17";
 High = 190;
 Low = 190;
 Open = 190;
 Volume = 32;
 currentgains = "10.02";
 "key_five" = "181.35";
 "key_ten" = "165.6";
 "key_twenty" = "151.67";
 repertory = 178446;
 "rise_and_decline" = "10.02";
 
 */

/*
 
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
 
 */

@end


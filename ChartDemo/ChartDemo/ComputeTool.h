//
//  ComputeTool.h
//  ChartDemo
//
//  Created by Dzy on 20/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger, ComputeType)
//{
//    aaa
//    
//};

@interface ComputeTool : NSObject

+ (NSString *)computeWithOpration:(NSString *)opration
                              leftNumber:(NSString *)leftNum
                             rightNumber:(NSString *)rightNum
                                    type:(NSRoundingMode)type;

+ (ComputeTool *)instance;

@end

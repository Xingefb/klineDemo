//
//  ComputeTool.m
//  ChartDemo
//
//  Created by Dzy on 20/01/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "ComputeTool.h"

@implementation ComputeTool

+ (ComputeTool *)instance {
    static ComputeTool *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    return self;
}

+ (NSString *)computeWithOpration:(NSString *)opration
                              leftNumber:(NSString *)leftNum
                             rightNumber:(NSString *)rightNum
                                    type:(NSRoundingMode)type
{
    
    NSRoundingMode mode = NSRoundBankers;
    if (type) {
        mode = type;
    }
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:mode
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    
    NSDecimalNumber *leftNumber = [NSDecimalNumber decimalNumberWithString:leftNum];
    NSDecimalNumber *rightNumber = [NSDecimalNumber decimalNumberWithString:rightNum];

    assert(![leftNumber isEqual:[NSDecimalNumber notANumber]]);
    assert(![rightNumber isEqual:[NSDecimalNumber notANumber]]);
    
    NSString *token;
    if ([@"+" isEqualToString:opration]) {
        token = [[leftNumber decimalNumberByAdding:rightNumber withBehavior:roundUp] stringValue];
        
    } else if ([@"-" isEqualToString:opration]) {
        token = [[leftNumber decimalNumberBySubtracting:rightNumber] stringValue];
        
    } else if ([@"*" isEqualToString:opration]) {
        
        if ([leftNum isEqualToString:@"0"] || [rightNum isEqualToString:@"0"]) {
            return @"0";
        }
        
        token = [[leftNumber decimalNumberByMultiplyingBy:rightNumber] stringValue];
        
    } else if ([@"/" isEqualToString:opration]) {
        if ([leftNum isEqualToString:@"0"] || [rightNum isEqualToString:@"0"]) {
            return @"0";
        }
        token = [[leftNumber decimalNumberByDividingBy:rightNumber] stringValue];
        
    } else if ([@"^" isEqualToString:opration]) {
        token = [[leftNumber decimalNumberByRaisingToPower:rightNumber.integerValue] stringValue];
    }
//    return [NSDecimalNumber decimalNumberWithString:token];
    return token;

}


@end

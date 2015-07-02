//
//  CurrencySkyModel.m
//  iGuidFC
//
//  Created by dampier on 15/4/16.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "CurrencySkyModel.h"

@implementation CurrencySkyModel


- (void)dealloc
{
    _code = nil;
    _decimalDigits = nil;
    _decimalSeparator = nil;
    _roundingCoefficient = nil;
    _spaceBetweenAmountAndSymbol = nil;
    _symbol = nil;
    _symbolOnLeft = nil;
    _thousandsSeparator = nil;
}

-(NSString *) getBillString:(NSNumber *) numberOfMoney
{
    // add thousand separator
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    numberFormat.usesGroupingSeparator = YES;
    numberFormat.groupingSeparator = self.thousandsSeparator;
    numberFormat.groupingSize = 3;
    NSString *numberString = [numberFormat stringFromNumber:numberOfMoney];
    
    // prepare space between amount and symbol
    NSString *spaceString = @"";
    for (int i = 0; i < self.spaceBetweenAmountAndSymbol.intValue; i++) {
        spaceString = [spaceString stringByAppendingString:@" "];
    }
    
    // connect amount and symbol
    NSString * billString;
    if (self.symbolOnLeft.intValue == 1) {
        billString = [NSString stringWithFormat:@"%@%@%@", self.symbol, spaceString, numberString];
    } else {
        billString = [NSString stringWithFormat:@"%@%@%@", numberString, spaceString, self.symbol];
    }
    return billString;
}

@end

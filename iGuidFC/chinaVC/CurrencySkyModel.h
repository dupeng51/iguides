//
//  CurrencySkyModel.h
//  iGuidFC
//
//  Created by dampier on 15/4/16.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencySkyModel : NSObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * decimalDigits;
@property (nonatomic, retain) NSString * decimalSeparator;
@property (nonatomic, retain) NSNumber * roundingCoefficient;
@property (nonatomic, retain) NSNumber * spaceBetweenAmountAndSymbol;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSNumber * symbolOnLeft;
@property (nonatomic, retain) NSString * thousandsSeparator;

-(NSString *) getBillString:(NSNumber *) numberOfMoney;

@end

//
//  CDIncome.m
//  BudgetControl
//
//  Created by Roma on 18.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import "CDIncome.h"
#import "CDBudget.h"
#import "CDIncomeCategory.h"


@implementation CDIncome

@dynamic date;
@dynamic incomeDescription;
@dynamic incomeName;
@dynamic money;
@dynamic budget;
@dynamic category;



+(NSDecimalNumber*) calculateTotalIncome:(NSArray*)array {
    NSDecimalNumber *totalValue = [NSDecimalNumber zero];
    
    for (CDIncome *income in array) {
        totalValue = [totalValue decimalNumberByAdding:income.money];
    }
    
    return totalValue;
}

@end

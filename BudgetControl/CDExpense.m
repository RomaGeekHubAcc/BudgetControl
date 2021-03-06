//
//  CDExpense.m
//  BudgetControl
//
//  Created by Roma on 18.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import "CDExpense.h"
#import "CDBudget.h"
#import "CDExpenseCategory.h"


@implementation CDExpense

@dynamic date;
@dynamic expenseDescription;
@dynamic price;
@dynamic checkAddress;
@dynamic budget;
@dynamic category;


+(NSDecimalNumber*) calculateTotalExpense:(NSArray*)array {
    NSDecimalNumber *totalValue = [NSDecimalNumber zero];
    
    for (CDExpense *expense in array) {
        totalValue = [totalValue decimalNumberByAdding:expense.price];
    }
    
    return totalValue;
}



@end

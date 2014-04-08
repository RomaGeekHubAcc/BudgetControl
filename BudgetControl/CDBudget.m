//
//  CDBudget.m
//  BudgetControl
//
//  Created by Roma on 18.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import "Utilities.h"

#import "CDBudget.h"
#import "CDExpense.h"
#import "CDIncome.h"


@implementation CDBudget

@dynamic date;
@dynamic currensy;
@dynamic expenses;
@dynamic income;

+(CDBudget*) budgetWithDate:(NSString*)date inContext:(NSManagedObjectContext*)context {
    
    CDBudget *newBudget = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[[CDBudget class] description] inManagedObjectContext:context];
    [fetchRequest setEntity:entityDescription];
    
    NSDictionary *attributes = [entityDescription attributesByName];
    NSString *attributeName = [attributes.allKeys lastObject];
    
#warning тут помилка - в predicate!!!
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ like %@", attributeName, date];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *matchingData = [context executeFetchRequest:fetchRequest error:&error];
    
    if (matchingData.count > 0) {
        newBudget = [matchingData lastObject];
    }
    else {
        newBudget = [[CDBudget alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        newBudget.date = [Utilities dateFromString:date withFormat:DATE_FORMAT_MONTH_YEAR];
    }
    return newBudget;
}


-(NSDecimalNumber*) recalculationExpenseForBudget {
    NSDecimalNumber *expensesTotal = [NSDecimalNumber zero];
    
    NSArray *expenses = [self.expenses allObjects];
    for (CDExpense *expense in expenses) {
        [expensesTotal decimalNumberByAdding:expense.price];
    }
    
    return expensesTotal;
}

-(NSDecimalNumber*) recalculationIncomesForBudget {
    NSDecimalNumber *incomesTotal = [NSDecimalNumber zero];
    
    NSArray *incomes = [self.income allObjects];
    for (CDIncome *income in incomes) {
        [incomesTotal decimalNumberByAdding:income.money];
    }
    
    return incomesTotal;
}

@end

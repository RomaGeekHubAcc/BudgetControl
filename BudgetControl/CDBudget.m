//
//  CDBudget.m
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/9/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import "CDBudget.h"
#import "CDExpense.h"
#import "CDIncome.h"


@implementation CDBudget

@dynamic currensy;
@dynamic date;
@dynamic expenses;
@dynamic income;


+(CDBudget*) budgetWithDate:(NSDate*)date inContext:(NSManagedObjectContext*)context {
    
    CDBudget *newBudget = nil;
    
    NSString *dateStr = [Utilities stringFromDate:date withFormat:DATE_FORMAT_MONTH_YEAR];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[[CDBudget class] description] inManagedObjectContext:context];
    [fetchRequest setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date like %@", dateStr];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *matchingData = [context executeFetchRequest:fetchRequest error:&error];
    
    if (matchingData.count > 0) {
        newBudget = [matchingData lastObject];
    }
    else {
        newBudget = [[CDBudget alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        newBudget.date = dateStr;
        newBudget.currensy = @"UAH";
    }
    return newBudget;
}


-(NSDecimalNumber*) recalculationExpenseForBudget {
    NSDecimalNumber *expensesTotal = [NSDecimalNumber zero];
    
    NSArray *expenses = [self.expenses allObjects];
    for (CDExpense *expense in expenses) {
        expensesTotal = [expensesTotal decimalNumberByAdding:expense.price];
    }
    
    return expensesTotal;
}

-(NSDecimalNumber*) recalculationIncomesForBudget {
    NSDecimalNumber *incomesTotal = [NSDecimalNumber zero];
    
    NSArray *incomes = [self.income allObjects];
    for (CDIncome *income in incomes) {
        incomesTotal = [incomesTotal decimalNumberByAdding:income.money];
    }
    
    return incomesTotal;
}

-(NSDecimalNumber*) totalAvailable {
    return [[self recalculationIncomesForBudget] decimalNumberBySubtracting:[self recalculationExpenseForBudget]];
}

-(BOOL) checkCanAffordThisExpense:(NSDecimalNumber*)expenseDecimalNumber {
    NSDecimalNumber *totalAvailable = [self totalAvailable];
    if ([totalAvailable doubleValue] < 0) {
        return  NO;
    }
    totalAvailable = [totalAvailable decimalNumberBySubtracting:expenseDecimalNumber];
    if ([totalAvailable doubleValue] < 0) {
        return NO;
    }
    
    return YES;
}


@end

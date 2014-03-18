//
//  CDBudget.m
//  BudgetControl
//
//  Created by Roma on 17.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import "CDBudget.h"
#import "CDExpense.h"
#import "CDIncome.h"


@implementation CDBudget

@dynamic date;
@dynamic expensesTotal;
@dynamic incomeTotal;
@dynamic expenses;
@dynamic income;

+(CDBudget*) budgetWithDate:(NSString*)date inContext:(NSManagedObjectContext*)context {
    
    CDBudget *newBudget = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[[CDBudget class] description] inManagedObjectContext:context];
    [fetchRequest setEntity:entityDescription];
    
    NSDictionary *attributes = [entityDescription attributesByName];
    NSString *attributeName = [attributes.allKeys lastObject];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ like %@", attributeName, date];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *matchingData = [context executeFetchRequest:fetchRequest error:&error];
    
    if (matchingData.count > 0) {
        newBudget = [matchingData lastObject];
    }
    else {
        newBudget = [[CDBudget alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        newBudget.date = date;
    }
    return newBudget;
}

@end

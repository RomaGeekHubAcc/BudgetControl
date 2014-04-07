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

+(CDExpense*) expenseWithDate:(NSDate*)date inManagedObjectContext:(NSManagedObjectContext*)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:[[CDExpense class] description] inManagedObjectContext:context];
    CDExpense *newExpense = [[CDExpense alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    return newExpense;
}

@end

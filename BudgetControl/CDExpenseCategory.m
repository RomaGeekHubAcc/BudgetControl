//
//  CDExpenseCategory.m
//  BudgetControl
//
//  Created by Roma on 18.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import "CDExpenseCategory.h"
#import "CDExpense.h"


@implementation CDExpenseCategory

@dynamic categoryName;
@dynamic expenses;


+(CDExpenseCategory*) expenseCatagoryWithName:(NSString*)name inContext:(NSManagedObjectContext*)context {
    CDExpenseCategory *expenseCategory = nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:[[CDExpenseCategory class] description] inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryName == %@", name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *matchingData = [context executeFetchRequest:fetchRequest error:&error];
    if (matchingData.count) {
        expenseCategory = [matchingData lastObject];
    }
    else {
        expenseCategory = [[CDExpenseCategory alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        expenseCategory.categoryName = name;
    }
    
    return expenseCategory;
}


@end

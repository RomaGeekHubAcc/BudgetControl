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

+(CDIncome*) newIncomeWithDate:(NSDate*)date inManagedObjectContext:(NSManagedObjectContext*)context {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:[[CDIncome class] description] inManagedObjectContext:context];
    
    CDIncome *newIncome = [[CDIncome alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    newIncome.date = date;
    
    return newIncome;
}

@end

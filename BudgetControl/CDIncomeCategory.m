//
//  CDIncomeCategory.m
//  BudgetControl
//
//  Created by Roma on 18.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//
#import "CDIncomeCategory.h"
#import "CDIncome.h"


@implementation CDIncomeCategory

@dynamic categoryName;
@dynamic incomes;

+(CDIncomeCategory*) categoryWithName:(NSString*)name inContext:(NSManagedObjectContext*)context {
    CDIncomeCategory *incomeCatehory = nil;
    
    NSEntityDescription *entityDescripton = [NSEntityDescription entityForName:[[CDIncomeCategory class] description] inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescripton];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryName == %@", name];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *mathingData = [context executeFetchRequest:request error:&error];
    
    if (mathingData.count) {
        incomeCatehory = [mathingData lastObject];
    }
    else {
        incomeCatehory = [[CDIncomeCategory alloc] initWithEntity:entityDescripton insertIntoManagedObjectContext:context];
        incomeCatehory.categoryName = name;
    }
    return incomeCatehory;
}

@end

//
//  CDExpenseCategory.h
//  BudgetControl
//
//  Created by Roma on 18.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDExpense;

@interface CDExpenseCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSSet *expenses;
@end

@interface CDExpenseCategory (CoreDataGeneratedAccessors)

- (void)addExpensesObject:(CDExpense *)value;
- (void)removeExpensesObject:(CDExpense *)value;
- (void)addExpenses:(NSSet *)values;
- (void)removeExpenses:(NSSet *)values;


+(CDExpenseCategory*) expenseCatagoryWithName:(NSString*)name inContext:(NSManagedObjectContext*)context;

@end

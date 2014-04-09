//
//  CDBudget.h
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/9/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDExpense, CDIncome;

@interface CDBudget : NSManagedObject

@property (nonatomic, retain) NSString * currensy;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSSet *expenses;
@property (nonatomic, retain) NSSet *income;
@end

@interface CDBudget (CoreDataGeneratedAccessors)

- (void)addExpensesObject:(CDExpense *)value;
- (void)removeExpensesObject:(CDExpense *)value;
- (void)addExpenses:(NSSet *)values;
- (void)removeExpenses:(NSSet *)values;

- (void)addIncomeObject:(CDIncome *)value;
- (void)removeIncomeObject:(CDIncome *)value;
- (void)addIncome:(NSSet *)values;
- (void)removeIncome:(NSSet *)values;



+(CDBudget*) budgetWithDate:(NSDate*)date inContext:(NSManagedObjectContext*)context;

-(NSDecimalNumber*) recalculationIncomesForBudget;
-(NSDecimalNumber*) recalculationExpenseForBudget;

@end

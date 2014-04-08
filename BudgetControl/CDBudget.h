//
//  CDBudget.h
//  BudgetControl
//
//  Created by Roma on 18.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDExpense, CDIncome;

@interface CDBudget : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * currensy;
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

+(CDBudget*) budgetWithDate:(NSString*)date inContext:(NSManagedObjectContext*)context;


-(NSDecimalNumber*) recalculationExpenseForBudget;
-(NSDecimalNumber*) recalculationIncomesForBudget;

@end

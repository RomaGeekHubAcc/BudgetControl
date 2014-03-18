//
//  CDIncomeCategory.h
//  BudgetControl
//
//  Created by Roma on 18.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDIncome;

@interface CDIncomeCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSSet *incomes;
@end

@interface CDIncomeCategory (CoreDataGeneratedAccessors)

- (void)addIncomesObject:(CDIncome *)value;
- (void)removeIncomesObject:(CDIncome *)value;
- (void)addIncomes:(NSSet *)values;
- (void)removeIncomes:(NSSet *)values;

@end

//
//  CDExpense.h
//  BudgetControl
//
//  Created by Roma on 18.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDBudget, CDExpenseCategory;

@interface CDExpense : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * expenseDescription;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSString * checkAddress;
@property (nonatomic, retain) CDBudget *budget;
@property (nonatomic, retain) CDExpenseCategory *category;

@end

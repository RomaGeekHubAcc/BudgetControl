//
//  CDIncome.h
//  BudgetControl
//
//  Created by Roma on 18.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDBudget;

@interface CDIncome : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * incomeDescription;
@property (nonatomic, retain) NSString * incomeName;
@property (nonatomic, retain) NSDecimalNumber * money;
@property (nonatomic, retain) CDBudget *budget;
@property (nonatomic, retain) NSManagedObject *category;

@end

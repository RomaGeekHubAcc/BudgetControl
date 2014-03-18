//
//  CoreDataManager.h
//  BudgetControl
//
//  Created by Roma on 09.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDBudget;

@interface CoreDataManager : NSObject

+(CoreDataManager*) sharedDataManager;

-(CDBudget*) getBudgetForMounth:(NSString*)mounth;
-(NSDecimalNumber*) recalculationExpenseForBudget:(CDBudget*)budget;
-(NSDecimalNumber*) recalculationIncomesForBudget:(CDBudget*)budget;

@end


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

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(CoreDataManager*) sharedDataManager;

-(CDBudget*) getBudgetForMounth:(NSDate*)mounth;
-(NSArray*) getExpensesCategories;
-(NSArray*) getIncomeCategories;



////////////////////////////////////////////////

-(void) insertNewIncomeWithDate:(NSDate*)date incomeName:(NSString*)iName categoryName:(NSString*)iCategoryName incomeDescription:(NSString*)description money:(NSDecimalNumber*)money;
-(void) insertNewExpenseWithDate:(NSDate*)date categoryName:(NSString*)eCategoryName expenseDescription:(NSString*)description money:(NSDecimalNumber*)money;


@end



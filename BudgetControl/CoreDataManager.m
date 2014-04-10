//
//  CoreDataManager.m
//  BudgetControl
//
//  Created by Roma on 09.03.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//



#import "CDBudget.h"
#import "CDExpense.h"
#import "CDIncome.h"
#import "CDIncomeCategory.h"
#import "CDExpenseCategory.h"

#import "CoreDataManager.h"

@interface CoreDataManager ()

@end

@implementation CoreDataManager

#pragma mark - Instance initialization

+(CoreDataManager*) sharedDataManager {
    static CoreDataManager *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[CoreDataManager alloc]init];
    });
    
    return __sharedInstance;
}


#pragma mark - Get methods

-(CDBudget*) getBudgetForMounth:(NSDate*)mounth {
    return [CDBudget budgetWithDate:mounth inContext:self.managedObjectContext];
}

-(NSArray*) getExpensesCategories {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[[CDExpenseCategory class] description] inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
     NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedCategories = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!fetchedCategories.count) {
        $l("ExpenseCategories missing !.. ");
    }
    return fetchedCategories;
}

-(NSArray*) getIncomeCategories {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[[CDIncomeCategory class] description] inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedCategories = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!fetchedCategories.count) {
        $l("IncomeCategories missing !.. ");
    }
    return fetchedCategories;
}


#pragma mark - Insert methods

-(void) insertNewBudgetForMounth:(NSDate*)mounth {
#warning -> цей метод буде потрібен, коли буде задаватись бюджет на майбутні місяці..
    NSError *error = nil;
    
    [CDBudget budgetWithDate:mounth inContext:self.managedObjectContext];
    
    if (![self.managedObjectContext save:&error]) {
        $l(@"Inserted budget for mounth error -> %@", error);
    }
}

-(void) insertNewIncomeWithDate:(NSDate*)date incomeName:(NSString*)iName categoryName:(NSString*)iCategoryName incomeDescription:(NSString*)description money:(NSDecimalNumber*)money {
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[[CDIncome class] description]
                                                         inManagedObjectContext:self.managedObjectContext];
    
    CDIncome *newIncome = [[CDIncome alloc] initWithEntity:entityDescription
                            insertIntoManagedObjectContext:self.managedObjectContext];
    
    CDBudget *budget = [CDBudget budgetWithDate:date inContext:self.managedObjectContext];
    
    newIncome.date = date;
    newIncome.incomeName = iName;
    newIncome.incomeDescription = description;
    newIncome.money = money;
    newIncome.category = [CDIncomeCategory categoryWithName:iCategoryName
                                               inContext:self.managedObjectContext];
    newIncome.budget = budget;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        $l(@"Save to DB error -> %@", error);
    }
    else {
        $l(@"New Income saved to DB succesfully");
    }
}

-(void) insertNewExpenseWithDate:(NSDate*)date categoryName:(NSString*)eCategoryName expenseDescription:(NSString*)description money:(NSDecimalNumber*)money {
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[[CDExpense class] description]
                                                         inManagedObjectContext:self.managedObjectContext];
    
    CDBudget *budget = [CDBudget budgetWithDate:date inContext:self.managedObjectContext];
    
    CDExpense *newExpense = [[CDExpense alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    newExpense.date = date;
    newExpense.expenseDescription = description;
    newExpense.price = money;
    newExpense.category = [CDExpenseCategory expenseCatagoryWithName:eCategoryName
                                                           inContext:self.managedObjectContext];
    newExpense.budget = budget;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        $l(@"Save to DB error -> %@", error);
    }
    else {
        $l(@"New Expense saved to DB succesfully");
    }
}

-(void) insertIncomeCategoryWithName:(NSString*)name {
    [CDIncomeCategory categoryWithName:name inContext:self.managedObjectContext];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        $l(@"Save to DB error -> %@", error);
    }
}

-(void) insertExpenseCategoryWithName:(NSString*)name {
    [CDExpenseCategory expenseCatagoryWithName:name inContext:self.managedObjectContext];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        $l(@"Save to DB error -> %@", error);
    }
}


#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BudgetControl" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BudgetControl.sqlite"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"BudgetControlStartDB" withExtension:@"sqlite"];
        NSError *error = nil;
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:&error];
            if (error) {
                $l("Copy default DB error!.. %@", error);
            }
        }
    }
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end


//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BudgetControl.sqlite"];
//    
//    NSError *error = nil;
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}



//-(void) hardcodeInsertsCategoriesByDefault {
//    ////////////  IncomeCategories  //////////////////
//    [CDIncomeCategory categoryWithName:@"Wages" inContext:self.managedObjectContext];
//    [CDIncomeCategory categoryWithName:@"Renting" inContext:self.managedObjectContext];
//    [CDIncomeCategory categoryWithName:@"Gifts" inContext:self.managedObjectContext];
//    
//    
//    ////////////  ExpenseCategories  //////////////////
//    [CDExpenseCategory expenseCatagoryWithName:@"General" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Clothes" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Food" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Kids Stuff" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Rent" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"House" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Insurances" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Health" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Travel" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Leisure" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Pets" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Books" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Trips" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Gifts" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Energy/Water" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Fuel" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Car" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Education" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Sport" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Music" inContext:self.managedObjectContext];
//    [CDExpenseCategory expenseCatagoryWithName:@"Friends" inContext:self.managedObjectContext];
//    
//    NSError *error = nil;
//    if (![self.managedObjectContext save:&error]) {
//        $l(@"Save to DB error -> %@", error);
//    }
//    else {
//        $l("Categories saved Successfully!..");
//    }
//}



//+(CDBudget*) budgetWithDate:(NSString*)date inContext:(NSManagedObjectContext*)context {
//    
//    CDBudget *newBudget = nil;
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[[CDBudget class] description] inManagedObjectContext:context];
//    [fetchRequest setEntity:entityDescription];
//    
//    NSDictionary *attributes = [entityDescription attributesByName];
//    NSString *attributeName = [attributes.allKeys lastObject];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ like %@", attributeName, date];
//    
//    [fetchRequest setPredicate:predicate];
//    
//    NSError *error = nil;
//    NSArray *matchingData = [context executeFetchRequest:fetchRequest error:&error];
//    
//    if (matchingData.count > 0) {
//        newBudget = [matchingData lastObject];
//    }
//    else {
//        newBudget = [[CDBudget alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
//        newBudget.date = [Utilities dateFromString:date withFormat:[NSString stringWithFormat:@"MMMM YYYY"]];
//    }
//    return newBudget;
//}





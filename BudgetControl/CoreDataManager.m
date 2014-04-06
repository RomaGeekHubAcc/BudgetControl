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

#import "CoreDataManager.h"

@interface CoreDataManager ()

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDataManager

+(CoreDataManager*) sharedDataManager {
    static CoreDataManager *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[CoreDataManager alloc]init];
    });
    
    return __sharedInstance;
}

-(NSDecimalNumber*) recalculationExpenseForBudget:(CDBudget*)budget {
    NSDecimalNumber *expensesTotal = [NSDecimalNumber zero];
    
    NSArray *expenses = [budget.expenses allObjects];
    for (CDExpense *expense in expenses) {
        [expensesTotal decimalNumberByAdding:expense.price];
    }
    
    return expensesTotal;
}

-(NSDecimalNumber*) recalculationIncomesForBudget:(CDBudget*)budget {
    NSDecimalNumber *incomesTotal = [NSDecimalNumber zero];
    
    NSArray *incomes = [budget.income allObjects];
    for (CDIncome *income in incomes) {
        [incomesTotal decimalNumberByAdding:income.money];
    }
    
    return incomesTotal;
}

-(CDBudget*) getBudgetForMounth:(NSString*)mounth {
    return [CDBudget budgetWithDate:mounth inContext:self.managedObjectContext];
}

-(void) insertNewBudgetForMounth:(NSString*)mounth {
    NSError *error = nil;
    
    CDBudget *newBudget = [CDBudget budgetWithDate:mounth inContext:self.managedObjectContext];
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Inserted budget for mounth");
    }
}

//-(void) createNewIncomeWithDate:(NSDate*)date  {
//    NSEntityDescription *entityDescr = [NSEntityDescription entityForName:[[CDIncome class] description] inManagedObjectContext:self.managedObjectContext];
//    
//    CDIncome *income = [[CDIncome alloc] initWithEntity:entityDescr insertIntoManagedObjectContext:self.managedObjectContext];
//}

-(void) insertCategoryIncome {
    
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
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

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BudgetControl" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BudgetControl.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
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

//
//  Utilities.m
//  BudgetControl
//
//  Created by Roma on 22.02.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import "CDBudget.h"
#import "CDIncome.h"
#import "CDExpense.h"
#import "CDExpenseCategory.h"
#import "CDIncomeCategory.h"

#import "Utilities.h"


@implementation Utilities


#pragma mark - User Defalts

+(void) saveUser:(NSString *)userName {
    if (!userName) {
        return;
    }
    NSString *pathToFile = [Utilities generatePathToUserDefaults];
    NSData *userData = [[NSData alloc] init];
    userData = [NSKeyedArchiver archivedDataWithRootObject:userName];
    [userData writeToFile:pathToFile atomically:YES];
}

+(NSString *) loadUserDefaults {
    NSString *pathToFile = [Utilities generatePathToUserDefaults];
    NSData *userDefaultsData = [NSData dataWithContentsOfFile:pathToFile];
    NSString *userDefaultsStr = [NSKeyedUnarchiver unarchiveObjectWithData:userDefaultsData];
    
    return userDefaultsStr;
}

+(NSString*) checkImageName:(NSString*)imageName {
    if ([imageName isEqualToString:@"Energy/Water.png"]) {
        imageName = @"Energy-Water.png";
    }
    if ([imageName isEqualToString:@"Kids Stuff.png"]) {
        imageName = @"Kids Stuff.png";
    }
    return imageName;
}


#pragma mark - Private methods

+(NSString*) generatePathToUserDefaults {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    path = [path stringByAppendingPathComponent:@"userDefaults.myfile"];
    return  path;
}

#pragma mark - DateFormatter

+(NSDateFormatter*) sharedDF {
    static NSDateFormatter *__dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __dateFormatter = [[NSDateFormatter alloc]init];
        [__dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [__dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    });
    return __dateFormatter;
}

+(NSDate*) dateFromString:(NSString*)string withFormat:(NSString*)format {
    [[Utilities sharedDF] setDateFormat:format];
    NSDate *date = [[Utilities sharedDF] dateFromString:string];
    return date;
}

+(NSString*) stringFromDate:(NSDate*)date withFormat:(NSString*)format {
    [[Utilities sharedDF] setDateFormat:format];
    NSString *dateStr = [[Utilities sharedDF] stringFromDate:date];
    return dateStr;
}



+(NSMutableArray*) sortIncomeOrExpenseArray:(NSArray*)arrayToSort {
    // сортування по алфавіту й даті
    NSSortDescriptor *sortDescrName = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
    NSSortDescriptor *sortDescrDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescrName, sortDescrDate];
    
    NSMutableArray *sortedArray = (NSMutableArray*)[arrayToSort sortedArrayUsingDescriptors:sortDescriptors];
    
    sortedArray = [Utilities sortEntitiesByCategories:sortedArray];
    
    return sortedArray;
}

+(NSMutableArray*) sortEntitiesByCategories:(NSArray*)arrayToSort {
    
    NSMutableArray *categoryTypes = [[NSMutableArray alloc] init];
    NSMutableArray *newSortedArr = [[NSMutableArray alloc] init];
    NSString *categoryName = nil;
    
    if ([[arrayToSort lastObject] isMemberOfClass:[CDExpense class]]) {
        for (CDExpense *exp in arrayToSort) {
            categoryName = exp.category.categoryName;
            if (![categoryTypes containsObject:categoryName]) {
                [categoryTypes addObject:categoryName];
            }
        }
        for (NSString *categName in categoryTypes) {
            NSMutableArray *entitiesSameCategoryArr = [[NSMutableArray alloc] init];
            for (CDExpense *exp in arrayToSort) {
                if ([exp.category.categoryName isEqualToString:categName]) {
                    [entitiesSameCategoryArr addObject:exp];
                }
            }
            [newSortedArr addObject:entitiesSameCategoryArr];
        }
    }
    else if ([[arrayToSort lastObject] isMemberOfClass:[CDIncome class]]){
        for (CDIncome *income in arrayToSort) {
            categoryName = income.category.categoryName;
            if (![categoryTypes containsObject:categoryName]) {
                [categoryTypes addObject:categoryName];
            }
        }
        for (NSString *categName in categoryTypes) {
            NSMutableArray *entitiesSameCategoryArr = [[NSMutableArray alloc] init];
            for (CDIncome *income in arrayToSort) {
                if ([income.category.categoryName isEqualToString:categName]) {
                    [entitiesSameCategoryArr addObject:income];
                }
            }
            [newSortedArr addObject:entitiesSameCategoryArr];
        }
    }
    
    return newSortedArr;
}

+(NSDecimalNumber*) calculateSumForEntities:(NSArray*)entities {
    NSDecimalNumber *totalValue = [NSDecimalNumber zero];
    if ([[entities lastObject] isKindOfClass:[NSArray class]]) {
        NSArray *array = [entities lastObject];
        if ([[array lastObject] isMemberOfClass:[CDExpense class]]) {
            for (int i = 0; i < entities.count; i++) {
                NSArray *array = [entities objectAtIndex:i];
                totalValue = [CDExpense calculateTotalExpense:array];
            }
        }
    }

    return totalValue;
}

@end

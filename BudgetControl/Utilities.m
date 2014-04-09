//
//  Utilities.m
//  BudgetControl
//
//  Created by Roma on 22.02.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//


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

@end

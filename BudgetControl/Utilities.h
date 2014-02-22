//
//  Utilities.h
//  BudgetControl
//
//  Created by Roma on 22.02.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(void) saveUser:(NSString *)userName;
+(NSString *) loadUserDefaults;

@end

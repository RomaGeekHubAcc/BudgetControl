//
//  ChartViewController.h
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/15/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

@class CDBudget;

@interface ChartViewController : UIViewController //<CPTPlotDataSource>

@property (nonatomic) CDBudget *currentBudget;
@property (nonatomic) NSArray *expenses;

@end

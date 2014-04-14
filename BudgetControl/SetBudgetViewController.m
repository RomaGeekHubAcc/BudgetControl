//
//  SetBudgetViewController.m
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/8/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//



#import "CDBudget.h"
#import "CDIncome.h"
#import "CDExpense.h"
#import "CDExpenseCategory.h"
#import "CDIncomeCategory.h"
#import "BudgetCell.h"
#import "IncomeExpenseCell.h"
#import "CategoryElementsViewController.h"

#import "SetBudgetViewController.h"



@interface SetBudgetViewController () {
    
    __weak IBOutlet UITableView *tableView;
    
    NSMutableArray *sectionsArray, *incomeArray, *expensesArray;
    __weak IBOutlet UILabel *titleDateLabel;
}

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation SetBudgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableView.delegate = self;
    tableView.dataSource = self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.currentBudget.date;
    
    incomeArray = [[NSMutableArray alloc] init];
    expensesArray = [[NSMutableArray alloc] init];
    
    [incomeArray addObjectsFromArray:[self.currentBudget.income allObjects]];
    incomeArray = [self sortIncomeOrExpenseArray:incomeArray];
    
    [expensesArray addObjectsFromArray:[self.currentBudget.expenses allObjects]];
    expensesArray = [self sortIncomeOrExpenseArray:expensesArray];
    
    sectionsArray = [NSMutableArray arrayWithObjects:incomeArray, expensesArray, nil];
    
    
    [tableView reloadData];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.title = @"Back";
}



#pragma mark - Action methods

- (IBAction)cancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
#warning -> save changes before dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 3) {
        return 1;
    }
    if ( !sectionsArray.count) {
        return 1;
    }
    if ( ![[sectionsArray objectAtIndex:section - 1] count]) {
        return 1;
    }
    return [[sectionsArray objectAtIndex:section - 1] count];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Income";
    }
    else if (section == 2) {
        return @"Expenses";
    }
    return nil;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = nil;
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0 || indexPath.section == 3) {
        cellIdentifier = @"budgetCellIdentifier";
        BudgetCell *bCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        switch (indexPath.section) {
            case 0:
                bCell.moneyLabel.text = [NSString stringWithFormat:@"%0.2f %@", [[self.currentBudget recalculationIncomesForBudget] doubleValue], self.currentBudget.currensy];
                bCell.mainLabel.text = @"Budget:";
                
                break;
            
            case 3:
                bCell.moneyLabel.text = [NSString stringWithFormat:@"%0.2f %@", [[self.currentBudget totalAvailable] doubleValue], self.currentBudget.currensy];
                bCell.mainLabel.text = @"Available:";
                break;
                
            default:
                break;
        }
        
        
        cell = bCell;
    }
    
    else {
        cellIdentifier = @"IncExpIdentifier";
        IncomeExpenseCell *incExpCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSString *imgName = nil;
        NSArray *arrayElements = [sectionsArray objectAtIndex:indexPath.section - 1];
        if ([[arrayElements lastObject] isKindOfClass:[NSArray class]]) {
            NSArray *array = [arrayElements objectAtIndex:indexPath.row];
            if ([[array lastObject] isMemberOfClass:[CDIncome class]]) {
                CDIncome *income = [array lastObject];
                incExpCell.nameLabel.text = income.category.categoryName;
                double totalVal = [[CDIncome calculateTotalIncome:array] doubleValue];
                incExpCell.moneyLabel.text = [NSString stringWithFormat:@"%0.2f %@", totalVal,self.currentBudget.currensy];
                imgName = [Utilities checkImageName:income.category.categoryName];
            }
            else if ([[array lastObject] isMemberOfClass:[CDExpense class]]) {
                CDExpense *expense = [array lastObject];
                incExpCell.nameLabel.text = expense.category.categoryName;
                double totalVal = [[CDExpense calculateTotalExpense:array] doubleValue];
                incExpCell.moneyLabel.text = [NSString stringWithFormat:@"%0.2f %@", totalVal,self.currentBudget.currensy];
                imgName = [Utilities checkImageName:expense.category.categoryName];
            }
            incExpCell.iconCategory.image = [UIImage imageNamed:imgName];
        }
        
        cell = incExpCell;
    }
    
    return cell;
}


#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryElementsViewController *categoryDetailsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryElementsViewController"];
    
    if (indexPath.section == 1) {
        categoryDetailsVc.entities = [incomeArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2) {
        categoryDetailsVc.entities = [expensesArray objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:categoryDetailsVc animated:YES];
}


#pragma mark Private methods

-(NSMutableArray*) sortIncomeOrExpenseArray:(NSArray*)arrayToSort {
    // сортування по алфавіту й даті
    NSSortDescriptor *sortDescrName = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
    NSSortDescriptor *sortDescrDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescrName, sortDescrDate];
    
    NSMutableArray *sortedArray = (NSMutableArray*)[arrayToSort sortedArrayUsingDescriptors:sortDescriptors];
    
    sortedArray = [self sortEntitiesByCategories:sortedArray];

    return sortedArray;
}

-(NSMutableArray*) sortEntitiesByCategories:(NSArray*)arrayToSort {
    
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

-( NSDecimalNumber*) calculateSumForEntities:(NSArray*)entities {
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

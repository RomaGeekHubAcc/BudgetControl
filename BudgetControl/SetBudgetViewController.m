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
    
    self.title = self.currentBudget.date;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    incomeArray = [[NSMutableArray alloc] init];
    expensesArray = [[NSMutableArray alloc] init];
    
    [incomeArray addObjectsFromArray:[self.currentBudget.income allObjects]];
    incomeArray = (NSMutableArray*)[self sortIncomeOrExpenseArray:incomeArray];
    
    [expensesArray addObjectsFromArray:[self.currentBudget.expenses allObjects]];
    expensesArray = (NSMutableArray*)[self sortIncomeOrExpenseArray:expensesArray];
    
    sectionsArray = [NSMutableArray arrayWithObjects:incomeArray, expensesArray, nil];
    
    
    [tableView reloadData];
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
        
        NSArray *arrayElements = [sectionsArray objectAtIndex:indexPath.section - 1];
        if ([[arrayElements firstObject] isMemberOfClass:[CDIncome class]]) {
            CDIncome *income = [arrayElements objectAtIndex:indexPath.row];
            incExpCell.nameLabel.text = income.category.categoryName;
            incExpCell.dateLabel.text = [Utilities stringFromDate:income.date withFormat:DATE_FORMAT_DAY_MONTH_YEAR];
            incExpCell.moneyLabel.text = [NSString stringWithFormat:@"%0.2f %@", [income.money doubleValue], self.currentBudget.currensy];
            NSString *imgName = [self checkImageName:[NSString stringWithFormat:@"%@.png", income.category.categoryName]];
            
            incExpCell.iconCategory.image = [UIImage imageNamed:imgName];
        }
        if ([[arrayElements firstObject] isMemberOfClass:[CDExpense class]]) {
            CDExpense *expense = [arrayElements objectAtIndex:indexPath.row];
            incExpCell.nameLabel.text = expense.category.categoryName;
            incExpCell.dateLabel.text = [Utilities stringFromDate:expense.date withFormat:DATE_FORMAT_DAY_MONTH_YEAR];
            incExpCell.moneyLabel.text = [NSString stringWithFormat:@"%0.2f %@", [expense.price doubleValue], self.currentBudget.currensy];
            NSString *imgName = [self checkImageName:[NSString stringWithFormat:@"%@.png", expense.category.categoryName]];
            incExpCell.iconCategory.image = [UIImage imageNamed:imgName];
        }
        cell = incExpCell;
    }
    
    return cell;
}


#pragma mark UITableViewDelegate



#pragma mark Private methods

-(NSString*) checkImageName:(NSString*)imageName {
    if ([imageName isEqualToString:@"Energy/Water.png"]) {
        imageName = @"Energy-Water.png";
    }
    if ([imageName isEqualToString:@"Kids Stuff.png"]) {
        imageName = @"Kids Stuff.png";
    }
    return imageName;
}

#warning method not work
-(NSArray*) sortIncomeOrExpenseArray:(NSArray*)arrayToSort {
    // сортування по алфавіту й даті
    NSSortDescriptor *sortDescrName = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
    NSSortDescriptor *sortDescrDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescrName, sortDescrDate];
    
    NSArray *sortedArray = [arrayToSort sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedArray;
}


@end

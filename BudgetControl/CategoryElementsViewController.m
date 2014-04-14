//
//  CategoryElementsViewController.m
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/11/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//



#import "CDBudget.h"
#import "CDIncome.h"
#import "CDIncomeCategory.h"
#import "CDExpense.h"
#import "CDExpenseCategory.h"
#import "IncomeExpenseTwoCell.h"

#import "CategoryElementsViewController.h"


@interface CategoryElementsViewController () {
    
    __weak IBOutlet UITableView *myTableView;

}

@end


@implementation CategoryElementsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    $l(@"entities Array - > %@", self.entities);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Category Details";
}


#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entities count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"identifier";
    
    IncomeExpenseTwoCell *cell = (IncomeExpenseTwoCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ([[self.entities lastObject] isMemberOfClass:[CDIncome class]]) {
        CDIncome *income = [self.entities objectAtIndex:indexPath.row];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%0.2f %@", [income.money doubleValue], income.budget.currensy];
        cell.categoryNameLabel.text = income.category.categoryName;
        cell.iconImageView.image = [UIImage imageNamed:[Utilities checkImageName:income.category.categoryName]];
        cell.dateLabel.text = [Utilities stringFromDate:income.date withFormat:DATE_FORMAT_DAY_MONTH_YEAR_TIME];
    }
    else if ([[self.entities lastObject] isMemberOfClass:[CDExpense class]]) {
        CDExpense *expense = [self.entities objectAtIndex:indexPath.row];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%0.2f %@", [expense.price doubleValue], expense.budget.currensy];
        cell.categoryNameLabel.text = expense.category.categoryName;
        cell.iconImageView.image = [UIImage imageNamed:[Utilities checkImageName:expense.category.categoryName]];
        cell.dateLabel.text = [Utilities stringFromDate:expense.date withFormat:DATE_FORMAT_DAY_MONTH_YEAR_TIME];
    }
    
    
    return cell;
}


#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end

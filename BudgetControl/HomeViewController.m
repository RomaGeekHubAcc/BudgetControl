//
//  HomeViewController.m
//  BudgetControl
//
//  Created by Roma on 22.02.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import "Utilities.h"
#import "SettingsViewController.h"
#import "CoreDataManager.h"
#import "CDBudget.h"
#import "CDExpenseCategory.h"
#import "CDIncomeCategory.h"
#import "NewExpenseViewController.h"
#import "SetBudgetViewController.h"
#import "NewIncomeViewController.h"

#import "HomeViewController.h"

@interface HomeViewController () {
    NSArray *expenseCategories, *incomeCategories;
    
}


- (IBAction)settings:(id)sender;
- (IBAction)newExpense:(id)sender;
- (IBAction)newIncome:(id)sender;

@end


@implementation HomeViewController

-(void) viewDidLoad {
    
    [super viewDidLoad];
    
#warning поки що не буде різних юзерів, бо не треба, а там видно буде
//    if (![Utilities loadUserDefaults]) {
//        [self createAlertViewNewUser];
//    }
    
    expenseCategories = [[CoreDataManager sharedDataManager] getExpenseCategories];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDate *dateNow = [NSDate date];
    NSString *dateString = [Utilities stringFromDate:dateNow withFormat:DATE_FORMAT_MONTH_YEAR];
    self.title = dateString;
    
    
    CDBudget *currentBudget = [[CoreDataManager sharedDataManager] getBudgetForMounth:dateString];
    
    NSDecimalNumber *income = [currentBudget recalculationIncomesForBudget];
    
    if ([income doubleValue] == 0) {
        [self createAlertViewSetBudget];
        
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.title = nil;
}


#pragma mark -Action methods

-(IBAction) settings:(id)sender {
    SettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

-(IBAction) newExpense:(id)sender {
    
}

-(IBAction) newIncome:(id)sender {
}


#pragma mark - Private methods

-(void) createAlertViewNewUser {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New user" message:@"Print new userName to start" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag = 1;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
    [alertView show];
}

-(void) createAlertViewSetBudget {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Budget for current mount is empty" message:@"Would you like set budget?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alertView.tag = 2;
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    [alertView show];
}


#pragma mark - UIAlertViewDelegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            NSString *userName = [[alertView textFieldAtIndex:0] text];
            [Utilities saveUser:userName];
        }
    }
    else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
#warning  реалізація задати бюджет
            
//            NSDate *dateNow = [NSDate date];
//            NSString *dateString = [Utilities stringFromDate:dateNow withFormat:[self dateFormatMounthYear]];
//            
//            CDBudget *currentBudget = [[CoreDataManager sharedDataManager] getBudgetForMounth:dateString];
            
        }
        else {
            // бюджет з автоматичними параметрами
        }
    }
}


#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"setBudgetController"]) {
        SetBudgetViewController *setBudgetVC = [segue destinationViewController];
        setBudgetVC.budgetToSet = self.budget;
    }
    else if ([segue.identifier isEqualToString:@"newIncomeController"]) {
        NewIncomeViewController *setBudgetVC = [segue destinationViewController];
        setBudgetVC.budget = self.budget;
    }
    else if ([segue.identifier isEqualToString:@"newExpenseController"]) {
        NewExpenseViewController *setBudgetVC = [segue destinationViewController];
        setBudgetVC.budget = self.budget;
    }
}


@end

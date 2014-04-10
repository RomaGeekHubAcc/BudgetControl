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
#import "SetBudgetViewController.h"
#import "NewIncomeViewController.h"

#import "HomeViewController.h"

@interface HomeViewController () {
    NSArray *expenseCategories, *incomeCategories;
    
    __weak IBOutlet UILabel *budgetCountLabel;
    __weak IBOutlet UILabel *expenseTotalCountLabel;
    __weak IBOutlet UILabel *totalCountLabel;
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
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDate *dateNow = [NSDate date];
    NSString *dateString = [Utilities stringFromDate:dateNow withFormat:DATE_FORMAT_MONTH_YEAR];
//    self.title = dateString;
    
    
    self.budget = [[CoreDataManager sharedDataManager] getBudgetForMounth:dateNow];
    [self showDataForBudget:self.budget];
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

-(void) showDataForBudget:(CDBudget*)budget {
    NSDecimalNumber *income = [budget recalculationIncomesForBudget];
    budgetCountLabel.text = [NSString stringWithFormat:@"%0.2f %@", [income doubleValue], budget.currensy];
    
    NSDecimalNumber *expenses = [budget recalculationExpenseForBudget];
    expenseTotalCountLabel.text = [NSString stringWithFormat:@"- %0.2f %@", [expenses doubleValue], budget.currensy];
    
    NSDecimalNumber *totalEnabled = [income decimalNumberBySubtracting:expenses];
    totalCountLabel.text = [NSString stringWithFormat:@"%0.2f %@", [totalEnabled doubleValue], budget.currensy];
}

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
        setBudgetVC.currentBudget = self.budget;
    }
    else if ([segue.identifier isEqualToString:@"newIncome"]) {
        NewIncomeViewController *newIncomeVC = [segue destinationViewController];
        newIncomeVC.budget = self.budget;
        newIncomeVC.flagIncomeYesExpenseNo = YES;
        
    }
    else if ([segue.identifier isEqualToString:@"newExpense"]) {
        NewIncomeViewController *newExpenseVC = [segue destinationViewController];
        newExpenseVC.budget = self.budget;
        newExpenseVC.flagIncomeYesExpenseNo = NO;
    }
}


@end

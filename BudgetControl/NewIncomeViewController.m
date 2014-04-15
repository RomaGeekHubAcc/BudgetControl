//
//  NewIncomeViewController.m
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/8/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//


#import "CoreDataManager.h"
#import "CDBudget.h"
#import "CDIncome.h"
#import "CDIncomeCategory.h"
#import "CDExpenseCategory.h"

#import "NewIncomeViewController.h"


@interface NewIncomeViewController () {

    NSArray *categories;
    
    __weak IBOutlet UIPickerView *categoryPicker;
    __weak IBOutlet UITextField *moneyTextField;
    __weak IBOutlet UITextView *descriptionTextView;
    __weak IBOutlet UIButton *categoryBtnOutlet;
    
}

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)chooseCategory:(id)sender;

@end


@implementation NewIncomeViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    categoryPicker.delegate = self;
    categoryPicker.dataSource = self;
    
    moneyTextField.delegate = self;
    descriptionTextView.delegate = self;
    
    if (self.flagIncomeYesExpenseNo) {
        categories = [[CoreDataManager sharedDataManager] getIncomeCategories];
    }
    else {
        categories = [[CoreDataManager sharedDataManager] getExpensesCategories];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    categoryPicker.hidden = YES;
}


#pragma mark - Action methods

-(IBAction) cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) chackSaveThisEntity {
    if ([moneyTextField.text doubleValue] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Wrong Parametrs!"
                                                            message:@"Сosts can not be with the sign '-' or '0'. Enter the amount of costs"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    if ([categoryBtnOutlet.titleLabel.text isEqualToString:@"Set Category"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Wrong Parametrs!"
                                                            message:@"Choose category"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    if (![self.budget checkCanAffordThisExpense:[NSDecimalNumber decimalNumberWithString:moneyTextField.text]] && !self.flagIncomeYesExpenseNo) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"This Expense is Not available in this time"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

-(IBAction) save:(id)sender {
    if (![self chackSaveThisEntity]) {
        return;
    }
    
    if (self.flagIncomeYesExpenseNo) {
        [[CoreDataManager sharedDataManager] insertNewIncomeWithDate:[NSDate date]
                                                          incomeName:@"" categoryName:categoryBtnOutlet.titleLabel.text
                                                   incomeDescription:descriptionTextView.text
                                                               money:[NSDecimalNumber decimalNumberWithString:moneyTextField.text]];
    }
    
    else {
        [[CoreDataManager sharedDataManager] insertNewExpenseWithDate:[NSDate date]
                                                         categoryName:categoryBtnOutlet.titleLabel.text
                                                   expenseDescription:descriptionTextView.text
                                                                money:[NSDecimalNumber decimalNumberWithString:moneyTextField.text]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chooseCategory:(id)sender {
    [self.view endEditing:YES];
    if (categoryPicker.hidden) {
        categoryPicker.hidden = NO;
        if ([categoryBtnOutlet.titleLabel.text isEqualToString:@"Set Category"]) {
            if ([[categories objectAtIndex:0] isMemberOfClass:[CDIncomeCategory class]]) {
                CDIncomeCategory *incomeCat = [categories objectAtIndex:0];
                [categoryBtnOutlet setTitle:incomeCat.categoryName forState:UIControlStateNormal];
            }
            else if ([[categories objectAtIndex:0] isMemberOfClass:[CDExpenseCategory class]]) {
                CDExpenseCategory *expenseCat = [categories objectAtIndex:0];
                [categoryBtnOutlet setTitle:expenseCat.categoryName forState:UIControlStateNormal];
            }
        }
    }
    else {
        categoryPicker.hidden = YES;
    }
}


#pragma mark - Removing Keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    categoryPicker.hidden = YES;
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}


#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!categoryPicker.hidden) {
        categoryPicker.hidden = YES;
    }
    
    return YES;
}


#pragma mark - UIPickerViewDataSource

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return categories.count;
}

#pragma mark - UIPickerViewDelegate

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    CDIncomeCategory *category= [categories objectAtIndex:row];
    return category.categoryName;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    CDIncomeCategory *category= [categories objectAtIndex:row];
    [categoryBtnOutlet setTitle:category.categoryName forState:UIControlStateNormal];
}


@end

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

#import "HomeViewController.h"

@interface HomeViewController ()


- (IBAction)settings:(id)sender;

@end


@implementation HomeViewController

-(void) viewDidLoad
{
    [super viewDidLoad];

    if (![Utilities loadUserDefaults]) {
        [self createAlertViewNewUser];
    }
    
    NSDate *dateNow = [NSDate date];
    NSString *dateString = [Utilities stringFromDate:dateNow withFormat:[self dateFormatMounthYear]];
    
    CDBudget *currentBudget = [[CoreDataManager sharedDataManager] getBudgetForMounth:dateString];
    NSDecimalNumber *income = currentBudget.incomeTotal;
    
    if ([income doubleValue] == 0) {
        [self createAlertViewSetBudget];
        
        
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDate *dateNow = [NSDate date];
    NSString *dateString = [Utilities stringFromDate:dateNow withFormat:[self dateFormatMounthYear]];
    self.title = dateString;
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.title = nil;
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

-(NSString*) dateFormatMounthYear {
    return [NSString stringWithFormat:@"MMMM YYYY"];
}


#pragma mark - UIAlertViewDelegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex = %d", buttonIndex);
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            NSString *userName = [[alertView textFieldAtIndex:0] text];
            [Utilities saveUser:userName];
        }
    }
    else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
#warning  реалізація задати бюджет
            
            NSDate *dateNow = [NSDate date];
            NSString *dateString = [Utilities stringFromDate:dateNow withFormat:[self dateFormatMounthYear]];
            
            CDBudget *currentBudget = [[CoreDataManager sharedDataManager] getBudgetForMounth:dateString];
            
            [[CoreDataManager sharedDataManager] recalculationBudget:currentBudget];
        }
        else {
            // бюджет з автоматичними параметрами
        }
    }
}


#pragma mark -Action methods

- (IBAction)settings:(id)sender {
    SettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}


@end

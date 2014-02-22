//
//  HomeViewController.m
//  BudgetControl
//
//  Created by Roma on 22.02.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import "Utilities.h"

#import "HomeViewController.h"

@interface HomeViewController ()

@end


@implementation HomeViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
	
    [self.navigationController setNavigationBarHidden:YES];

    if (![Utilities loadUserDefaults]) {
        [self createAlertViewNewUser];
    }
}


#pragma mark - Private methods

-(void) createAlertViewNewUser {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New user" message:@"Print new userName to start" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag = 1;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
    [alertView show];
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
}

@end

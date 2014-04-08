//
//  NewExpenseViewController.m
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/8/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import "NewExpenseViewController.h"

@interface NewExpenseViewController ()
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation NewExpenseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - Action methods

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
#warning -> save changes before dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

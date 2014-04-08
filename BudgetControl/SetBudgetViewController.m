//
//  SetBudgetViewController.m
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/8/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import "SetBudgetViewController.h"

@interface SetBudgetViewController ()

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation SetBudgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
#warning -> save changes before dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

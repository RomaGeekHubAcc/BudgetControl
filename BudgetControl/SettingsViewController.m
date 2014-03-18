//
//  SettingsViewController.m
//  BudgetControl
//
//  Created by Roma on 23.02.14.
//  Copyright (c) 2014 Roma. All rights reserved.
//



#import "SettingsViewController.h"


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end


@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Settings";
    _label.text = @"Set budget for current mounth:\n--incomes:\n  -wages;\n  -gifts;\n  - rents;\n--expenses:\n  - something\n\nSet currensy";
}



@end

//
//  NewIncomeViewController.h
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/8/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDBudget;

@interface NewIncomeViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>


@property (nonatomic) CDBudget *budget;
@property (nonatomic) BOOL flagIncomeYesExpenseNo;

@end

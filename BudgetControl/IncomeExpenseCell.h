//
//  IncomeExpenseCell.h
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/9/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeExpenseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconCategory;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

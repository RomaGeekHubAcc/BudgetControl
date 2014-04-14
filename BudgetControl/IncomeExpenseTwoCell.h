//
//  IncomeExpenseTwoCell.h
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/14/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeExpenseTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

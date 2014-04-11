//
//  NewExpenseViewController.m
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/10/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//


#import "CoreDataManager.h"
#import "CDBudget.h"
#import "CDExpense.h"
#import "CDExpenseCategory.h"
#import "IconCollectionViewCell.h"

#import "NewExpenseViewController.h"


@interface NewExpenseViewController () {
    
    __weak IBOutlet UICollectionView *myCollectionView;
    __weak IBOutlet UITextField *moneyTextField;
    
    NSMutableArray *iconsArray;
    NSUInteger selectedCategoryIndex;
    
    NSString *selectedCellStr;
}

- (IBAction)save:(id)sender;

@end


@implementation NewExpenseViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    
    moneyTextField.delegate = self;
    
//    CDBudget *currentBudget = [[CoreDataManager sharedDataManager] getBudgetForMounth:[NSDate date]];
    
    iconsArray = [[NSMutableArray alloc] init];
    NSArray *categories = [[CoreDataManager sharedDataManager] getExpensesCategories];
    for (CDExpenseCategory *category in categories) {
        NSString *imageName = category.categoryName;
        if ([imageName isEqualToString:@"Energy/Water"]) {
            imageName = @"Energy-Water";
        }
        if ([imageName isEqualToString:@"Kids Stuff"]) {
            imageName = @"Kids-Stuff";
        }
        
        UIImage *iconImg = [UIImage imageNamed:imageName];
        if ([imageName isEqualToString:@"General"]) {
            [iconsArray insertObject:iconImg atIndex:0];
        }
        else {
            [iconsArray addObject:iconImg];
        }
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [moneyTextField becomeFirstResponder];
    [myCollectionView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (moneyTextField.text.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Expense not saved!" message:@"Wish you save this Expense?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        alertView.tag = 111;
        [alertView show];
        return;
    }
    
    selectedCellStr = nil;
    moneyTextField.text = @"";
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}


#pragma mark - Action methods

-(void) didEnterBackground {
    moneyTextField.text = @"";
}

- (IBAction)save:(id)sender {
    
    if (![moneyTextField.text doubleValue]) {
        [self showAlertViewWithTitle:@"Wrong Parametr!"
                             message:@"Сosts can not be with the sign '-' or '0'. Enter the amount of costs"
                   cancelButtonTitle:@"OK"];
        return;
    }
    if (!selectedCellStr) {
        selectedCellStr = @"General";
    }
    
    CDBudget *currentBudget = [[CoreDataManager sharedDataManager] getBudgetForMounth:[NSDate date]];
    if (![currentBudget checkCanAffordThisExpense:[NSDecimalNumber decimalNumberWithString:moneyTextField.text]]) {
        [self showAlertViewWithTitle:@"Warning!"
                             message:@"This Expense is Not available"
                   cancelButtonTitle:@"Cancel"];
        return;
    }
    
    [[CoreDataManager sharedDataManager] insertNewExpenseWithDate:[NSDate date]
                                                     categoryName:[self categoryNameFromSelectedIconName:selectedCellStr]
                                               expenseDescription:@""
                                                            money:[NSDecimalNumber decimalNumberWithString:moneyTextField.text]];
    [self.view endEditing:YES];
    
    selectedCellStr = nil;
    moneyTextField.text = @"";
}



#pragma mark - Delegated methods

#pragma mark - UITextViewDelegate methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}


#pragma mark - UICollectionViewDataSource

-(NSInteger) numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return iconsArray.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"collectionViewCellIdentifir";
    IconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.iconImageView.image = [iconsArray objectAtIndex:indexPath.item];
    cell.backgroundImageView.image = [UIImage imageNamed:@"borderSelected.png"];
    cell.backgroundImageView.hidden = YES;

    
    NSString *currentCellStr  = [cell.iconImageView.image accessibilityIdentifier];
    
    if ([currentCellStr isEqualToString:selectedCellStr]) {
        cell.backgroundImageView.hidden = NO;
    }
    
    return  cell;
}


#pragma mark - UICollectionViewDelegate

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    IconCollectionViewCell *myCell = (IconCollectionViewCell*)[myCollectionView cellForItemAtIndexPath:indexPath];
    
    selectedCellStr = [myCell.iconImageView.image accessibilityIdentifier];
    
    
    [myCollectionView reloadData];
    // TODO: Select Item
}


#pragma mark - Private methods

-(NSString*) categoryNameFromSelectedIconName:(NSString*)iconName {
    if ([iconName isEqualToString:@"Energy-Water"]) {
        iconName = @"Energy/Water";
    }
    iconName = [iconName stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    
    return iconName;
}


#pragma mark - UIAlertViewDelegate

-(void) showAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelBtnTitle {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelBtnTitle otherButtonTitles:nil, nil];
    [alertView show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 111) {
        if (buttonIndex == 1) {
            [self save:nil];
        }
    }
}


#pragma mark - Removing Keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}





@end

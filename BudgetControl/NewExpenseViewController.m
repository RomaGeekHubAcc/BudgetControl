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
    
    CDBudget *currentBudget = [[CoreDataManager sharedDataManager] getBudgetForMounth:[NSDate date]];
    
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
    
    [moneyTextField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    selectedCellStr = nil;
    moneyTextField.text = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - Action methods

-(void) didEnterBackground {
    moneyTextField.text = @"";
}

- (IBAction)save:(id)sender {
    
    if (![moneyTextField.text doubleValue]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Wrong Parametr!" message:@"Сosts can not be with the sign '-' or '0'. Enter the amount of costs" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (!selectedCellStr) {
        selectedCellStr = @"General";
    }

    
    [[CoreDataManager sharedDataManager] insertNewExpenseWithDate:[NSDate date]
                                                     categoryName:selectedCellStr
                                               expenseDescription:@""
                                                            money:[NSDecimalNumber decimalNumberWithString:moneyTextField.text]];
    [self.view endEditing:YES];
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

//#pragma mark - UIAlertViewDelegate
//
//-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//}


#pragma mark - Removing Keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}





@end

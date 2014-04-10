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
}

- (IBAction)save:(id)sender;

@end


@implementation NewExpenseViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    
    CDBudget *currentBudget = [[CoreDataManager sharedDataManager] getBudgetForMounth:[NSDate date]];
    
    iconsArray = [[NSMutableArray alloc] init];
    NSArray *categories = [[CoreDataManager sharedDataManager] getExpensesCategories];
    for (CDExpenseCategory *category in categories) {
        NSString *imageName = [NSString stringWithFormat:@"%@.png", category.categoryName];
        if ([imageName isEqualToString:@"Energy/Water.png"]) {
            imageName = @"Energy-Water.png";
        }
        if ([imageName isEqualToString:@"Kids Stuff.png"]) {
            imageName = @"Children.png";
        }
        
        UIImage *iconImg = [UIImage imageNamed:imageName];
        if ([imageName isEqualToString:@"General.png"]) {
            [iconsArray insertObject:iconImg atIndex:0];
        }
        else {
            [iconsArray addObject:iconImg];
        }
    }
    
    
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return iconsArray.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"collectionViewCellIdentifir";
    IconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.iconImageView.image = [iconsArray objectAtIndex:indexPath.item];
    
    return  cell;
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    
    id cell = [myCollectionView cellForItemAtIndexPath:indexPath];
    if ([cell isMemberOfClass:[IconCollectionViewCell class]]) {
        IconCollectionViewCell *myCell = cell;
        myCell.backgroundImageView.image = [UIImage imageNamed:@"borderSelected.png"];
    }
    
    [myCollectionView reloadData];
}


#pragma mark - Removing Keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - Action methods

- (IBAction)save:(id)sender {
}
@end

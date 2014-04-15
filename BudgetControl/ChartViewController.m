//
//  ChartViewController.m
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/15/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//


#define CHART_LABEL_KEY @"chartLabelKey"
#define CHART_VALUE_KEY @"chartValueKey"


#import "CoreDataManager.h"
#import "CorePlot-CocoaTouch.h"
#import "CDBudget.h"
#import "CDIncome.h"
#import "CDExpense.h"
#import "CDExpenseCategory.h"
#import "CDIncomeCategory.h"
#import "SetBudgetViewController.h"

#import "ChartViewController.h"


@interface ChartViewController (){
//    NSArray *categoryNameArray, *prices;
    NSMutableArray *arrayForChart;
}

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;

@end


@implementation ChartViewController


-(void) viewDidLoad {
    [super viewDidLoad];
	
    UIBarButtonItem *tableBarBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"content.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(tableBtnPressed)];
    self.navigationItem.rightBarButtonItem = tableBarBtnItem;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CDBudget *budget = [[CoreDataManager sharedDataManager] getBudgetForMounth:self.currentBudget.date];
    self.currentBudget = budget;
    arrayForChart = (NSMutableArray*)[self configureArrayForChartWithBudget:budget];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initPlot];
}


#pragma mark - CPTPlotDataSource methods
-(NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot {
    return [arrayForChart count];
}

-(NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    if (CPTPieChartFieldSliceWidth == fieldEnum)
    {
        return [[arrayForChart objectAtIndex:index] objectForKey:CHART_VALUE_KEY];
    }
    return [NSDecimalNumber zero];
}

-(CPTLayer *) dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    // 1 - Define label text style
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText) {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    // 2 - Calculate portfolio total value
    //TODO: setLabelData
//    NSDecimalNumber *portfolioSum = [NSDecimalNumber zero];
//    for (NSDecimalNumber *price in prices) {
//        portfolioSum = [portfolioSum decimalNumberByAdding:price];
//    }
//    // 3 - Calculate percentage value
//    NSDecimalNumber *price = [prices objectAtIndex:index];
//    NSDecimalNumber *percent = [price decimalNumberByDividingBy:portfolioSum];
    // 4 - Set up display label
//    NSString *labelValue = [NSString stringWithFormat:@"$%0.2f USD (%0.1f %%)", [price floatValue], ([percent floatValue] * 100.0f)];
    // 5 - Create and return layer with label text
    NSDictionary *dict = [arrayForChart objectAtIndex:index];
    NSString *labelValue = [dict objectForKey:CHART_LABEL_KEY];//[NSString stringWithFormat:@"%@, %0.2f %@", [dict objectForKey:CHART_LABEL_KEY], [[dict objectForKey:CHART_VALUE_KEY] doubleValue], self.currentBudget.currensy];
    
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}

-(NSString *) legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    if (index < arrayForChart.count) {
        NSDictionary *dict = [arrayForChart objectAtIndex:index];
        
        NSDecimalNumber *totalIncome = [self.currentBudget recalculationIncomesForBudget];
        NSDecimalNumber *persents = [[dict objectForKey:CHART_VALUE_KEY] decimalNumberByDividingBy:totalIncome];
        
        NSString *legendStr = [NSString stringWithFormat:@"%@, %0.1f%%", [dict objectForKey:CHART_LABEL_KEY], [persents doubleValue] *100.0f];
        return legendStr;
    }
    return @"N/A";
}


#pragma mark - Action methods

-(void) tableBtnPressed {
//    SetBudgetViewController *setBudgetVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetBudgetViewController"];
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - Private methods

-(NSArray*) configureArrayForChartWithBudget:(CDBudget*)budget {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDecimalNumber *freeIncome = [self.currentBudget totalAvailable];
    
    NSDictionary *dict = @{CHART_LABEL_KEY : @"Free Income",
                           CHART_VALUE_KEY : freeIncome};
    [array addObject:dict];
    
    if (!self.expenses || !self.expenses.count) {
        return array;
    }
    if ([[_expenses lastObject] isKindOfClass:[NSArray class]]) {
        for (int i = 0; i <self.expenses.count; i++) {
            NSDecimalNumber *sumExpenseCateg = [CDExpense calculateTotalExpense:[self.expenses objectAtIndex:i]];
            
            CDExpense *expense = [[self.expenses objectAtIndex:i] lastObject];
            NSString *categoryName = expense.category.categoryName;
            
            NSDictionary *dict = @{CHART_LABEL_KEY : categoryName,
                                   CHART_VALUE_KEY : sumExpenseCateg};
            [array addObject:dict];
        }
    }
    
    return array;
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost {
    // 1 - Set up view frame
    CGRect parentRect = self.view.bounds;
    parentRect = CGRectMake(parentRect.origin.x,
                            parentRect.origin.y,
                            parentRect.size.width,
                            parentRect.size.height);
    
    //    CGRect newFrame = parentRect;
    // 2 - Create host view
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    // 1 - Create and initialize graph
    CGRect newFrame = self.hostView.frame;
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:newFrame];
    
    self.hostView.hostedGraph = graph;
    
    
    graph.plotAreaFrame.paddingTop          = -60.0;
    graph.plotAreaFrame.paddingRight        = 10.0;
    graph.plotAreaFrame.paddingBottom       = 80.0;
    graph.plotAreaFrame.paddingLeft         = 0.0;
    
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;
    // 3 - Configure title
    NSString *title = [NSString stringWithFormat:@"Budget for %@", self.currentBudget.date];
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
    // 4 - Set theme
    self.selectedTheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:self.selectedTheme];
}

-(void)configureChart {
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = (self.hostView.bounds.size.height *0.3) / 2;
    pieChart.identifier = graph.title;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.1] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    // 4 - Add chart to graph
    [graph addPlot:pieChart];
}

-(void)configureLegend {
    // 1 - Get graph instance
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    // 3 - Configure legend
    
    CPTMutableTextStyle * textStyle= [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    theLegend.textStyle = textStyle;
    theLegend.numberOfColumns = 2;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    // 4 - Add legend to graph
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorBottomLeft;
    graph.legendDisplacement = CGPointMake(20, 100); // це зміщення таблички
    
}


@end

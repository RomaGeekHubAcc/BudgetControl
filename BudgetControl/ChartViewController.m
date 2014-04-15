//
//  ChartViewController.m
//  BudgetControl
//
//  Created by Roman Rybachenko on 4/15/14.
//  Copyright (c) 2014 Roma. All rights reserved.
//


#import "CorePlot-CocoaTouch.h"
#import "CDBudget.h"
#import "CDIncome.h"
#import "CDExpense.h"
#import "CDExpenseCategory.h"
#import "CDIncomeCategory.h"

#import "ChartViewController.h"


@interface ChartViewController (){
    NSArray *categoryNameArray, *prices;
}

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;

@end


@implementation ChartViewController


-(void) viewDidLoad {
    [super viewDidLoad];
	
    //////////////////////////////////////////
    categoryNameArray = [NSArray arrayWithObjects:@"Food", @"Clothes", @"Books", @"Pets", @"Car", nil];
    prices = [NSArray arrayWithObjects:[NSDecimalNumber decimalNumberWithString:@"40"],
              [NSDecimalNumber decimalNumberWithString:@"50"],
              [NSDecimalNumber decimalNumberWithString:@"60"],
              [NSDecimalNumber decimalNumberWithString:@"70"],
              [NSDecimalNumber decimalNumberWithString:@"100"],
              nil];
    //////////////////////////////////////////
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initPlot];
}


#pragma mark - CPTPlotDataSource methods
-(NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot {
    return [categoryNameArray count];
}

-(NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    if (CPTPieChartFieldSliceWidth == fieldEnum)
    {
        return [prices objectAtIndex:index];
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
    NSDecimalNumber *portfolioSum = [NSDecimalNumber zero];
    for (NSDecimalNumber *price in prices) {
        portfolioSum = [portfolioSum decimalNumberByAdding:price];
    }
    // 3 - Calculate percentage value
    NSDecimalNumber *price = [prices objectAtIndex:index];
    NSDecimalNumber *percent = [price decimalNumberByDividingBy:portfolioSum];
    // 4 - Set up display label
    NSString *labelValue = @"Nothing";//[NSString stringWithFormat:@"$%0.2f USD (%0.1f %%)", [price floatValue], ([percent floatValue] * 100.0f)];
    // 5 - Create and return layer with label text
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}

-(NSString *) legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    if (index < [categoryNameArray count]) {
        return [categoryNameArray objectAtIndex:index];
    }
    return @"N/A";
}

#pragma mark - UIActionSheetDelegate methods
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
}


#pragma mark - Action methods

- (IBAction)themeTapped:(id)sender {
    
}


#pragma mark - Private methods

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
    
    
    graph.plotAreaFrame.paddingTop          = -80.0;
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
    NSString *title = @"Portfolio Prices: 14 April, 2014";
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
    graph.legendAnchor = CPTRectAnchorBottom;
    graph.legendDisplacement = CGPointMake(40, 100); // це зміщення таблички
    
}


@end

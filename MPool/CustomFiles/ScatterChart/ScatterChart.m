//
//  ScatterChart.m
//  Test
//
//  Created by Chinnababu on 7/13/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

#import "ScatterChart.h"
#import "PNChart.h"
#define ARC4RANDOM_MAX 0x100000000


@implementation ScatterChart
- (IBAction)share:(id)sender {
    [self.delegate shareView:self];
}

+(UIView *)loadInstance{
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIView *view = [[bundle loadNibNamed:NSStringFromClass([self class])  owner:self options:nil] firstObject];
    return  view;
}


- (void)loadScatterData{
    self.textField.delegate = self;
 
    self.pickerView.hidden = YES;
    self.scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /6.0 - 30, 135, 280, 200)];
    [self.scatterChart setAxisXWithMinimumValue:0 andMaxValue:70 toTicks:6];
    [self.scatterChart setAxisYWithMinimumValue:8000 andMaxValue:1000000 toTicks:5];
    
    NSArray * data01Array = [self randomSetOfObjects];
    PNScatterChartData *data01 = [PNScatterChartData new];
    data01.strokeColor = PNGreen;
    data01.fillColor = PNFreshGreen;
    data01.size = 2;
    data01.itemCount = [[data01Array objectAtIndex:0] count];
    data01.inflexionPointStyle = PNScatterChartPointStyleCircle;
    __block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:0]];
    __block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:1]];
    data01.getData = ^(NSUInteger index) {
        CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
        CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
        return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
    };
    
    [self.scatterChart setup];
    self.scatterChart.chartData = @[data01];
    [self addSubview:self.scatterChart];
    self.scatterChart.delegate = self;
}

- (void)reloadScatterChartWithValues:(NSMutableArray*)values andAverageSalary:(NSString*)salary{
    [self.scatterChart removeFromSuperview];
    [self loadScatterChartForThePickerValues:values];
    self.subTitile.text = [NSString stringWithFormat:@"--Avg. expected salary (%@ INR)",salary];
    CGPoint startPoint = CGPointMake(0,self.averageSalary);
    CGPoint endPoint = CGPointMake(self.valueArray.count,self.averageSalary);
    
    [self.scatterChart drawLineFromPoint:startPoint ToPoint:endPoint WithLineWith:2 AndWithColor:UIColor.redColor];
}

- (void)loadScatterChartForThePickerValues:(NSMutableArray*)values{
    
    self.valueArray = values;
    self.scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(0, 155, 280, 250)];
    
    NSArray *numbers = [values sortedArrayUsingSelector:@selector(compare:)];
    int min = [numbers[0] floatValue];
    int max = [[numbers lastObject] floatValue];
    if (values.count < 5){
        [self.scatterChart setAxisXWithMinimumValue:0 andMaxValue:values.count  toTicks:values.count + 1];
        [self.scatterChart setAxisYWithMinimumValue:0 andMaxValue:max toTicks:5];
        
        
    }
    else{
        [self.scatterChart setAxisXWithMinimumValue:0 andMaxValue:values.count toTicks:5];
        [self.scatterChart setAxisYWithMinimumValue:min andMaxValue:max  toTicks:5];
    }
    NSArray * data01Array = [self randomSetOfObjectsWithTheValues:values];
    PNScatterChartData *data01 = [PNScatterChartData new];
    data01.strokeColor = PNGreen;
    data01.fillColor = PNFreshGreen;
    data01.size = 2;
    data01.itemCount = [[data01Array objectAtIndex:0] count];
    data01.inflexionPointStyle = PNScatterChartPointStyleCircle;
    __block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:0]];
    __block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:1]];
    data01.getData = ^(NSUInteger index) {
        CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
        CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
        return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
    };
    
    [self.scatterChart setup];
    self.scatterChart.chartData = @[data01];
    [self addSubview:self.scatterChart];
    self.scatterChart.delegate = self;
    CGPoint startPoint = CGPointMake(0,self.averageSalary);
    
    CGPoint endPoint = CGPointMake(self.valueArray.count,self.averageSalary);
    
    [self.scatterChart drawLineFromPoint:startPoint ToPoint:endPoint WithLineWith:2 AndWithColor:UIColor.redColor];

}
- (void)loadDataForThePickerValue:(NSString*)averageSalary
                        lineIndex:(NSMutableArray*)values
                       pointIndex:(NSMutableArray*)pickerValues andSearchText:(NSString*)searchText{
    
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    UIImage *image = [UIImage imageNamed:@"downArrow.png"];
//    imageView.image = image;
//    self.textField.rightViewMode = UITextFieldViewModeAlways;
//    self.textField.rightView = imageView;
    
    self.promoteButton.layer.cornerRadius = 5;
    self.titile.text = [NSString stringWithFormat:@"Expected salary for (%@)",searchText];
    self.subTitile.text = [NSString stringWithFormat:@"--Avg. expected salary (%@ INR)",averageSalary];
  
    self.selectedIndex = 0;
    [self loadScatterChartForThePickerValues:values];
    
    [[UIPickerView appearance] setBackgroundColor:[UIColor lightGrayColor]];
    self.textField.delegate = self;
    self.pickerKeyArray = pickerValues;
    
    CGFloat height = self.pickerKeyArray.count * 30;
    if(height > self.frame.size.height - 93){
        height = self.frame.size.height - 93;
    }
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.textField.frame.origin.x, self.textField.frame.origin.y, self.textField.frame.size.width, height)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.hidden = YES;
    [self addSubview:self.pickerView];
    
    UITapGestureRecognizer  *myGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerTapped:)];
    myGR.delegate = self;
    [ self.pickerView addGestureRecognizer:myGR];
    self.scatterChart.delegate = self;
    
    NSString *exp = [self.pickerKeyArray objectAtIndex:self.selectedIndex];
    _textField.text = exp;
    [self setExperiencedText:exp];
    self.textField.text = exp;
}

-(void)pickerTapped:(id)sender{
    self.pickerView.hidden = YES;
}


- (NSArray *)randomSetOfObjects {
    NSMutableArray *array = [NSMutableArray array];
    NSString *LabelFormat = @"%1.f";
    NSMutableArray *XAr = [NSMutableArray array];
    NSMutableArray *YAr = [NSMutableArray array];
    for (int i = 0; i < 25; i++) {
        [XAr addObject:[NSString stringWithFormat:LabelFormat, (((double) arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisX_maxValue - self.scatterChart.AxisX_minValue) + self.scatterChart.AxisX_minValue)]];
        [YAr addObject:[NSString stringWithFormat:LabelFormat, (((double) arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisY_maxValue - self.scatterChart.AxisY_minValue) + self.scatterChart.AxisY_minValue)]];
    }
    [array addObject:XAr];
    [array addObject:YAr];
    return array;
}
- (NSArray *)randomSetOfObjectsWithTheValues:(NSMutableArray*)values {
    NSMutableArray *array = [NSMutableArray array];
    NSString *LabelFormat = @"%1.f";
    NSMutableArray *XAr = [NSMutableArray array];
    NSMutableArray *YAr = [NSMutableArray array];
    for (int i = 0; i < values.count; i++) {
        [XAr addObject:[NSNumber numberWithInt:i]];
        NSNumber * mapXNum = [values  objectAtIndex:i];
        int mapX = [mapXNum intValue];
        [YAr addObject:[NSNumber numberWithInt:mapX]];
    }
    [array addObject:XAr];
    [array addObject:YAr];
    return array;
}

-(void)setExperiencedText:(NSString*)text{
    self.experiencedLable.text = [NSString stringWithFormat:@"Experience Range(%@)",text];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    self.selectedIndex = row;
    return [self.pickerKeyArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *exp = [self.pickerKeyArray objectAtIndex:row];
    _textField.text = exp;
    [self setExperiencedText:exp];
    self.pickerView.hidden = YES;
    [self.delegate getDataFortheValuesForTheIndex:row];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.delegate removeScatterPopOver];
    self.pickerView.hidden = NO;
    return  NO;
}
- (void)userClickedOnLineKeyPoint:(CGPoint)point
                        lineIndex:(NSInteger)lineIndex
                       pointIndex:(NSInteger)pointIndex{
    [self.delegate scatterChart:self.scatterChart didSelectAtIndex:pointIndex andWithTheLayer:point];
}

- (void)didUnselectPieItem{
    [self.delegate removeScatterPopOver];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  self.pickerKeyArray.count;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesMoved:touches withEvent:event];
    self.pickerView.hidden = YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}
- (IBAction)promteAppAction:(id)sender {
    [self.delegate PromoteAPPScatterChart];
}

@end

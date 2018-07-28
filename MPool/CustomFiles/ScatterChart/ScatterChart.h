//
//  ScatterChart.h
//  Test
//
//  Created by Chinnababu on 7/13/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

#import <UIKit/UIKit.h>
# import "PNChart.h"

@protocol ScatterDelegate <NSObject>
@optional

-(void)getDataFortheValuesForTheIndex:(NSInteger)index;
- (void)scatterChart:(PNScatterChart*)scatterChart didSelectAtIndex:(NSUInteger)index andWithTheLayer:(CGPoint)point;
- (void)removeScatterPopOver;
- (void)shareView:(id)scatter;
- (void)PromoteAPPScatterChart;

@end

@interface ScatterChart : UIView<PNChartDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) PNScatterChart *scatterChart;
@property (weak,nonatomic) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *pickerKeyArray;
@property (nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic, strong) id<ScatterDelegate> delegate;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UILabel *experiencedLable;
@property (weak, nonatomic) IBOutlet UILabel *titile;
@property (weak, nonatomic) IBOutlet UILabel *subTitile;
- (IBAction)share:(id)sender;

+(UIView *)loadInstance;
- (void)loadScatterData;
- (void)loadDataForThePickerValue:(NSString*)averageSalary
                        lineIndex:(NSMutableArray*)values
                       pointIndex:(NSMutableArray*)pickerValues andSearchText:(NSString*)searchText;
- (void)reloadScatterChartWithValues:(NSMutableArray*)pickerVlaues andAverageSalary:(NSString*)salary;
@end

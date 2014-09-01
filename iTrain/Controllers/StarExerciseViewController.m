//
//  StarExerciseViewController.m
//  iTrain
//
//  Created by Interest on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "StarExerciseViewController.h"
#import "CBLEManager.h"

@interface StarExerciseViewController ()<AKPickerViewDelegate>


@end
NSInteger _time;
@implementation StarExerciseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _timeIndex=-1;
        _modelArray=[[NSMutableArray alloc]init];
        _time=5;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"开始训练";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI{
    self.titles=[[NSMutableArray alloc]initWithArray:@[@"5",
                                                       @"10",
                                                       @"15",
                                                       @"20",
                                                       @"25",
                                                       @"30",
                                                       ]];
 [_startBtn addTarget:self action:@selector(gotoStartView)forControlEvents:UIControlEventTouchUpInside];
    self.paramView.delegate=self;
    [self setModel];
    [self.paramView selectItem:1 animated:NO];
    [self.paramView selectItem:_timeIndex animated:NO];
}

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
- (void)gotoStartView{
        if (DEVICE_IS_IPHONE5) {
            exerciseParam= [[ExerciseParamViewController alloc] initWithNibName:@"ExerciseParamViewController4" bundle:nil];}
        else{
             exerciseParam= [[ExerciseParamViewController alloc] initWithNibName:@"ExerciseParamViewController" bundle:nil];
        }
    [_modelArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:_time]];
    exerciseParam.modelArray=_modelArray;
   [self.navigationController pushViewController:exerciseParam animated:YES];
}

/**获取蓝牙连接之后返回的设备模式相关信息，并且初始化显示**/
-(void)setModel{
    NSArray *temparray=[[CBLEManager sharedManager] getModel];
    if(temparray==nil||temparray.count==0){
        _timeIndex=0;
    }else{
        _modelArray=[[NSMutableArray alloc]initWithArray:temparray];
        NSNumber *temp=[_modelArray objectAtIndex:2];
        _timeIndex=[self.titles indexOfObject:[NSString stringWithFormat:@"%d",[temp intValue]]];
        _time=[temp intValue];
    }
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
	return [self.titles count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
	return self.titles[item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
	NSLog(@"%@", self.titles[item]);
    _time=[self.titles[item] intValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

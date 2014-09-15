//
//  StarExerciseViewController.m
//  iTrain
//
//  Created by Interest on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "StarExerciseViewController.h"
#import "CBLEManager.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
@interface StarExerciseViewController ()<AKPickerViewDelegate,MTImageMapDelegate>
@end
NSString *part;
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
    [self setModel];
    
    [self.paramView selectItem:1 animated:NO];
    [self.paramView selectItem:_timeIndex animated:NO];
    [_popView setHidden:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [_startBtn setEnabled:NO];
}
-(void)initUI{
    self.titles=[[NSMutableArray alloc]initWithArray:@[@"5",
                                                       @"10",
                                                       @"15",
                                                       @"20",
                                                       @"25",
                                                       @"30",
                                                       ]];
    
    [_startBtn addTarget:self action:@selector(twoBtnClicked:)forControlEvents:UIControlEventTouchUpInside];
    self.paramView.delegate=self;
    NSArray *arrStates = \
    [NSArray arrayWithContentsOfFile:
    [[NSBundle mainBundle]
      pathForResource:(DEVICE_IS_IPHONE5)?@"4path":@"path"
      ofType:@"plist"]];
    
    [_body
     setMapping:arrStates
     doneBlock:^(MTImageMapView *imageMapView) {
         NSLog(@"Areas are all mapped");
     }];
    
}

-(void)imageMapView:(MTImageMapView *)inImageMapView
   didSelectMapArea:(NSUInteger)inIndexSelected
{
    [_popView setHidden:NO];
    _popView.alpha = 1;
    if(inIndexSelected==0){
        [_popView setImage:[UIImage imageNamed:@"start_quan7.png"]];
        part=@"手臂";
    }else if(inIndexSelected==1){
        [_popView setImage:[UIImage imageNamed:@"start_quan6.png"]];
        part=@"手臂";
    }else if(inIndexSelected==2){
        [_popView setImage:[UIImage imageNamed:@"start_quan3.png"]];
        part=@"大腿";
    }else if(inIndexSelected==3){
        [_popView setImage:[UIImage imageNamed:@"start_quan2.png"]];
        part=@"大腿";
    }else if(inIndexSelected==4){
        [_popView setImage:[UIImage imageNamed:@"start_quan5.png"]];
        part=@"胸部";
    }else if(inIndexSelected==5){
        part=@"腹部";
        [_popView setImage:[UIImage imageNamed:@"start_quan4.png"]];
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel:)];
    [self.view addGestureRecognizer:tapGesture];
    [_startBtn setEnabled:YES];
    [_startBtn setImage:[UIImage imageNamed:@"start_kaishixunlian2.png"] forState:UIControlStateNormal];
}

-(void)tappedCancel:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.25f animations:^{
        _popView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_popView setHidden:YES];
        }
    }];
    [self.view removeGestureRecognizer:sender];
}


- (void)gotoStartView{
    if (DEVICE_IS_IPHONE5) {
        exerciseParam= [[ExerciseParamViewController alloc] initWithNibName:@"ExerciseParamViewController4" bundle:nil];}
    else{
        exerciseParam= [[ExerciseParamViewController alloc] initWithNibName:@"ExerciseParamViewController" bundle:nil];
    }
    [_modelArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:_time]];
    exerciseParam.modelArray=_modelArray;
    exerciseParam.part=part;
    [self.navigationController pushViewController:exerciseParam animated:YES];
}



- (void)twoBtnClicked:(id)sender
{
    if ([[CBLEManager sharedManager] isConnected]) {
        [self gotoStartView];
    }else{
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"您还没有连接蓝牙，是否要去蓝牙页面连接蓝牙？" leftButtonTitle:@"是" rightButtonTitle:@"否"];
        [alert show];
        alert.leftBlock = ^() {
            connectBT= [[BlueToothViewController alloc] init];
            [self.navigationController pushViewController:connectBT animated:YES];
            
        };
        alert.rightBlock = ^() {
            NSLog(@"right button clicked");
        };
        alert.dismissBlock = ^() {
            NSLog(@"Do something interesting after dismiss block");
        };
    }
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
    _time=[self.titles[item] intValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

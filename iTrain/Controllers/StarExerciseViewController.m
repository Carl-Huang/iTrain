//
//  StarExerciseViewController.m
//  iTrain
//
//  Created by Interest on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "StarExerciseViewController.h"
#import "CBLEManager.h"
#import "AppDelegate.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
@interface StarExerciseViewController ()<AKPickerViewDelegate,MTImageMapDelegate>
@end
NSString *part;
NSInteger _time;
BOOL isBack;
UITapGestureRecognizer *tapGesture ;
@implementation StarExerciseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _timeIndex=-1;
        _modelArray=[[NSMutableArray alloc]init];
        _time=10;
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = NSLocalizedString(@"startxunlian", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [self setModel];
    
    [self.paramView selectItem:1 animated:NO];
    [self.paramView selectItem:_timeIndex animated:NO];
    [_popView setHidden:YES];
    if ([[CBLEManager sharedManager] isConnected]) {
          [_StartTip setTextColor:[UIColor blackColor]];
    }else{
        [_StartTip setTextColor:[UIColor lightGrayColor]];
    }
    
    if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).part!=nil){
        [_startBtn setEnabled:YES];
      
        [_startBtn setImage:[UIImage imageNamed:@"start_kaishixunlian2.png"] forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [_startBtn setEnabled:NO];
    isBack=false;
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
    [_StartTip setText:NSLocalizedString(@"startxunlian", nil)];
    
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
    [_topTrain setText:NSLocalizedString(@"TrainPart", nil)];
    [_bottomTrain setText:NSLocalizedString(@"TrainTime", nil)];
    [_LeftBtn setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [_LeftBtn setImage:[UIImage imageNamed:@"leftp.png"] forState:UIControlStateHighlighted];
    [_LeftBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_LeftBtn setBackgroundImage:[UIImage imageNamed:@"切换按钮背景.png"] forState:UIControlStateHighlighted];
    
    [_RightBtn setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [_RightBtn setImage:[UIImage imageNamed:@"rightp.png"] forState:UIControlStateHighlighted];
    [_RightBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_RightBtn setBackgroundImage:[UIImage imageNamed:@"切换按钮背景.png"] forState:UIControlStateHighlighted];
    [_LeftBtn addTarget:self action:@selector(BtnPress) forControlEvents:UIControlEventTouchUpInside];
    [_RightBtn addTarget:self action:@selector(BtnPress) forControlEvents:UIControlEventTouchUpInside];
}

-(void)BtnPress{
    [_popView setHidden:YES];
    _popView.alpha = 0;
    if(tapGesture!=nil){
        [self.view removeGestureRecognizer:tapGesture];
        tapGesture=nil;
    }
    if(isBack){
        [_body setImage:[UIImage imageNamed:@"start_ren.png"]];
    }else{
        [_body setImage:[UIImage imageNamed:@"back_normal.png"]];
    }
    isBack=!isBack;
}



-(void)imageMapView:(MTImageMapView *)inImageMapView
   didSelectMapArea:(NSUInteger)inIndexSelected
{
    [_popView setHidden:NO];
    _popView.alpha = 1;
    if(isBack){
        if(inIndexSelected==0){
            [_body setImage:[UIImage imageNamed:@"back_arml.png"]];
            [_popView setImage:[UIImage imageNamed:@"back_arml_p.png"]];
            part=@"0";
        }else if(inIndexSelected==1){
            [_body setImage:[UIImage imageNamed:@"back_armr.png"]];
            [_popView setImage:[UIImage imageNamed:@"back_armr_p.png"]];
            part=@"0";
        }else if(inIndexSelected==2){
            [_body setImage:[UIImage imageNamed:@"back_thighl.png"]];
            [_popView setImage:[UIImage imageNamed:@"back_thighl_p.png"]];
            part=@"5";
        }else if(inIndexSelected==3){
            [_body setImage:[UIImage imageNamed:@"back_thighr.png"]];
            [_popView setImage:[UIImage imageNamed:@"back_thighr_p.png"]];
            part=@"5";
        }else if(inIndexSelected==4){
            [_body setImage:[UIImage imageNamed:@"back_back"]];
            [_popView setImage:[UIImage imageNamed:@"back_back_p.png"]];
            part=@"3";
        }else if(inIndexSelected==5){
            [_body setImage:[UIImage imageNamed:@"back_buttocks.png"]];
            part=@"4";
            [_popView setImage:[UIImage imageNamed:@"back_buttocks_p.png"]];
        }
    }else{
        if(inIndexSelected==0){
            [_body setImage:[UIImage imageNamed:@"start_zuoshou.png"]];
            [_popView setImage:[UIImage imageNamed:@"start_quan7.png"]];
            part=@"0";
        }else if(inIndexSelected==1){
            [_body setImage:[UIImage imageNamed:@"start_youshou.png"]];
            [_popView setImage:[UIImage imageNamed:@"start_quan6.png"]];
            part=@"0";
        }else if(inIndexSelected==2){
            [_body setImage:[UIImage imageNamed:@"start_zuotui.png"]];
            [_popView setImage:[UIImage imageNamed:@"start_quan3.png"]];
            part=@"5";
        }else if(inIndexSelected==3){
            [_body setImage:[UIImage imageNamed:@"start_youtui.png"]];
            [_popView setImage:[UIImage imageNamed:@"start_quan2.png"]];
            part=@"5";
        }else if(inIndexSelected==4){
            [_body setImage:[UIImage imageNamed:@"start_xiong.png"]];
            [_popView setImage:[UIImage imageNamed:@"start_quan5.png"]];
            part=@"1";
        }else if(inIndexSelected==5){
            [_body setImage:[UIImage imageNamed:@"belly.png"]];
            part=@"2";
            [_popView setImage:[UIImage imageNamed:@"start_quan4.png"]];
        }
    }
    tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [self.view addGestureRecognizer:tapGesture];
    [_startBtn setEnabled:YES];
    [_StartTip setTextColor:[UIColor blackColor]];
    [_startBtn setImage:[UIImage imageNamed:@"start_kaishixunlian2.png"] forState:UIControlStateNormal];
}

-(void)tappedCancel{
    [UIView animateWithDuration:0.25f animations:^{
        _popView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_popView setHidden:YES];
        }
    }];
    if(tapGesture!=nil){
         [self.view removeGestureRecognizer:tapGesture];
        tapGesture=nil;
    }
   
}


- (void)gotoStartView{
    exerciseParam= ((AppDelegate *)[[UIApplication sharedApplication] delegate]).evc;
    if(exerciseParam==nil){
        if (DEVICE_IS_IPHONE5) {
            exerciseParam= [[ExerciseParamViewController alloc] initWithNibName:@"ExerciseParamViewController4" bundle:nil];}
        else{
            exerciseParam= [[ExerciseParamViewController alloc] initWithNibName:@"ExerciseParamViewController" bundle:nil];
        }
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).evc=exerciseParam;
    }
    
    if([CBLEManager sharedManager].Stu1==2){
        [_modelArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:_time]];
        exerciseParam.modelArray=_modelArray;
        exerciseParam.part=part;
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).modelArray=_modelArray;
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).part=part;
    }else{
        exerciseParam.modelArray=((AppDelegate *)[[UIApplication sharedApplication] delegate]).modelArray;
        exerciseParam.part=((AppDelegate *)[[UIApplication sharedApplication] delegate]).part;
    }
    [self.navigationController pushViewController:exerciseParam animated:YES];
}



- (void)twoBtnClicked:(id)sender
{
    if ([[CBLEManager sharedManager] isConnected]) {
        [self gotoStartView];
    }else{
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:NSLocalizedString(@"ConnectTip", nil) leftButtonTitle:NSLocalizedString(@"YES", nil) rightButtonTitle:NSLocalizedString(@"NO", nil)];
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
        //NSNumber *temp=[_modelArray objectAtIndex:2];
        _timeIndex=1;
        _time=10;
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

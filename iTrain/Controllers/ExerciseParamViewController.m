//
//  ExerciseParamViewController.m
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ExerciseParamViewController.h"
#import "CBLEManager.h"
#import "Record.h"
#import "AppDelegate.h"
#import "DXAlertView.h"
#import "CBLEPeriphral.h"
#import "ExerciseRecordDetailViewController.h"

@interface ExerciseParamViewController ()<AKPickerViewDelegate>

//@property (nonatomic, strong) AKPickerView *pickerView;
//@property (nonatomic, strong) AKPickerView *pickerView2;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *titles2;
@end


NSInteger speedIndex;
NSInteger stongIndex;
NSInteger speed;
NSInteger stong;
AppDelegate *myAppDelegate;
NSDate *start;
BOOL isStart;
BOOL isPuse;
BOOL isHide;
NSArray *parts;
@implementation ExerciseParamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        for(int i=0;i<91;i++){
            [temp addObject:[NSString stringWithFormat:@"%d",i]];
        }
        self.titles=[[NSArray alloc]initWithArray:temp];
        self.titles2=@[@"01",@"02",@"03",@"04",@"05"];
        speedIndex=-1;
        stongIndex=-1;
        speed=1;
        stong=0;
        parts=@[NSLocalizedString(@"Arm", nil),NSLocalizedString(@"Chest", nil),NSLocalizedString(@"Belly", nil),NSLocalizedString(@"Back", nil),NSLocalizedString(@"Buttocks", nil),NSLocalizedString(@"Thigh", nil)];
        isHide=NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title =NSLocalizedString(@"xunlian", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:@selector(back)];
    myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    start=[NSDate date];
    User *user=myAppDelegate.user;
    
//    if(user!=nil){
//        speedIndex=[[user speedIndex] integerValue];
//        stongIndex=[[user strongIndex] integerValue];
//        speed=[self.titles2[speedIndex] integerValue];
//        stong=[self.titles[stongIndex] integerValue];
//    }else{
//        speed=[(NSNumber*)[_modelArray objectAtIndex:3] integerValue];
//        stong=[(NSNumber*)[_modelArray objectAtIndex:4] integerValue];
//        speedIndex=[self.titles2 indexOfObject:speed<10?[@"0" stringByAppendingString:[NSString stringWithFormat:@"%d",speed]]:[NSString stringWithFormat:@"%d",speed]];
//        stongIndex=[self.titles indexOfObject:[NSString stringWithFormat:@"%d",stong]];
//    }
//    
//    
//    [self.pickerView selectItem:1 animated:NO];
//    [self.pickerView selectItem:stongIndex animated:NO];
//    [self.pickerView2 selectItem:1 animated:NO];
//    [self.pickerView2 selectItem:speedIndex animated:NO];
//    
//    
//    [[CBLEManager sharedManager] setDisconnectHandler:^(CBPeripheral * peripheral){
//        DXAlertView *alertView=[[DXAlertView alloc]initWithTitle:NSLocalizedString(@"ConnectError", nil) contentText:NSLocalizedString(@"ConnectErrorTip", nil) leftButtonTitle:nil rightButtonTitle:@"OK"];
//        alertView.rightBlock=^(){
//            [self back];
//        };
//        [alertView show];
//    }];
//    isStart=false;
//    [[CBLEManager sharedManager] setSendDataHandler:^(NSString *st,CBPeripheral *per){
//        
//        if([[[st substringFromIndex:4] substringToIndex:2] isEqualToString:@"01"]){
//            [self start];
//            isStart=true;
//            isPuse=false;
//            
//        }
//    }];
//    [self changeModel];
}

-(void)back{
    [[CBLEManager sharedManager]setSendDataHandler:nil];
    [[CBLEManager sharedManager] setDisconnectHandler:nil];
    Record *record=[self saveRecord];
    ExerciseRecordDetailViewController *_detail=[[ExerciseRecordDetailViewController alloc]init];
    _detail.record=record;
    [self.navigationController pushViewController:_detail animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerView.delegate = self;
    
    self.pickerView2.delegate = self;
    
	[self.pickerView reloadData];
    [self.pickerView2 reloadData];
    [_btn addTarget:self action:@selector(selectedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_btn2 addTarget:self action:@selector(selectedBtn2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(stopBtnPressed)];
    
    longPress.minimumPressDuration = 0.8; //定义按的时间
    
    [_btn2 addGestureRecognizer:longPress];
    [_setTv setText:NSLocalizedString(@"TrainSetting", nil)];
    [_speedTv setText:NSLocalizedString(@"Speed", nil)];
    [_stongTv setText:NSLocalizedString(@"Stong", nil)];
    [_StartTip setText:NSLocalizedString(@"Start", nil)];
    [_StopTip setText:NSLocalizedString(@"Puase", nil)];
    [_exercisePartLabel setText:NSLocalizedString(@"Body_Part", nil)];
    [_exerciseTimeLabel setText:NSLocalizedString(@"TrainTime", nil)];
    [_hideViewBtn setTitle :NSLocalizedString(@"Hide", nil) forState:UIControlStateNormal];
    [_hideViewBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    
    [_exerciseDetail setText:NSLocalizedString(@"Detail", nil)];
    
}

/**发送按钮响应事件**/
-(void)selectedBtnPressed:(id)sender{
    [self changeModel];
}

-(void)changeModel{
    if([[CBLEManager sharedManager] isConnected]){
        /**速度是0x01对应第一个，所以提交修改的时候要+1**/
        [_modelArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:speed]];
        [_modelArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:stong]];
        if(isStart){
            [[CBLEManager sharedManager] setSendDataHandler:^(NSString *st,CBPeripheral *per){
                [[CBLEManager sharedManager] setModelArray:_modelArray];
                DXAlertView *alertView=[[DXAlertView alloc]initWithTitle:NSLocalizedString(@"SendSu", nil) contentText:nil leftButtonTitle:nil rightButtonTitle:@"OK"];
                [alertView show];
                User *user=myAppDelegate.user;
                speedIndex=[self.titles2 indexOfObject:speed<10?[@"0" stringByAppendingString:[NSString stringWithFormat:@"%d",speed]]:[NSString stringWithFormat:@"%d",speed]];
                stongIndex=[self.titles indexOfObject:[NSString stringWithFormat:@"%d",stong]];
                [user setSpeedIndex:[NSNumber numberWithInteger:speedIndex]];
                [user setStrongIndex:[NSNumber numberWithInteger:stongIndex]];
                NSError *error=nil;
                [myAppDelegate.managedObjectContext save:&error];
            }];
        }
        [[CBLEManager sharedManager] createData:_modelArray];
    }
}

-(void)stopBtnPressed{
    NSArray *array=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x07], nil];
    [[CBLEManager sharedManager]setDisconnectHandler:nil];
    [[CBLEManager sharedManager] setSendDataHandler:^(NSString *st,CBPeripheral *per){
        DXAlertView *alertView=[[DXAlertView alloc]initWithTitle:NSLocalizedString(@"StopSu", nil) contentText:nil leftButtonTitle:nil rightButtonTitle:@"OK"];
        alertView.dismissBlock=^(){
            [self back];
        };
        [alertView show];
    }];
    [[CBLEManager sharedManager] createData:array];
}
/**停止按钮响应事件**/
-(void)selectedBtn2Pressed:(id)sender{
    if(isPuse){
        [_StopTip setText:NSLocalizedString(@"Puase", nil)];
        [self start];
        return;
    }
    [_StopTip setText:NSLocalizedString(@"Resume", nil)];
    
    NSArray *array=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x05], nil];
    [[CBLEManager sharedManager] setSendDataHandler:^(NSString *st,CBPeripheral *per){
        DXAlertView *alertView=[[DXAlertView alloc]initWithTitle:NSLocalizedString(@"PauseSu", nil)  contentText:nil leftButtonTitle:nil rightButtonTitle:@"OK"];
        [alertView show];
        isPuse=true;
    }];
    [[CBLEManager sharedManager] createData:array];
    
}

-(void)start{
    NSArray *array=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x06], nil];
    [[CBLEManager sharedManager] setSendDataHandler:^(NSString *st,CBPeripheral *per){
        isPuse=false;
        DXAlertView *alertView=[[DXAlertView alloc]initWithTitle:NSLocalizedString(@"StartSu", nil) contentText:nil leftButtonTitle:nil rightButtonTitle:@"OK"];
        [alertView show];
    }];
    [[CBLEManager sharedManager] createData:array];
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    if(pickerView==self.pickerView){
        return [self.titles count];
    }
	return [self.titles2 count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    if(pickerView==self.pickerView){
        return self.titles[item];
    }
    return self.titles2[item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
	if(pickerView==self.pickerView){
        stong=[self.titles[item] integerValue];
        
        return;
    }
    speed=[self.titles2[item] integerValue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(Record *)saveRecord{
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year = [dateComponent year];
    Record *record=[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:myAppDelegate.managedObjectContext];
    [record setYear:[NSString stringWithFormat:@"%d",year]];
    [record setPart:_part];
    
    [record setWeekday:[NSString stringWithFormat:@"%d",[dateComponent weekday]]];
    [record setStarttime:start];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *  senddate=[NSDate date];
    //结束时间
    NSDate *endDate = start;
    //当前时间

    
    //得到相差秒数
    NSTimeInterval time=[senddate timeIntervalSince1970]-[endDate timeIntervalSince1970];
    int hour=(int)(time/3600);
    int minute = hour*60+(int)(time-hour*3600)/60;
    [record setTime:[NSNumber numberWithInt:minute]];
    [record setDate:start];
    if(myAppDelegate.user){
         [record setUser:[[[myAppDelegate.user objectID] URIRepresentation]absoluteString]];
    }else{
        [record setUser:@"defualt"];
    }
    NSError *error=nil;
    Boolean isSU=[myAppDelegate.managedObjectContext save:&error];
    if(isSU){
        NSLog(@"保存成功");
    }
    return record;
}
-(void)hideView{
    if (isHide) {
        _detailView.hidden=NO;
        isHide=NO;
        
    }else{
        _detailView.hidden=YES;
        isHide=YES;
        
    }
    
}
@end

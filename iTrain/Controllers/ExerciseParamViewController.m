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
@property (nonatomic,strong) UIView *oneView;
@property (nonatomic,strong) UIView *twoView;
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
NSTimer *timer;
NSTimeInterval terval;
NSDate *lastDate;
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
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    start=[NSDate date];
    User *user=myAppDelegate.user;
    
    if(user!=nil){
        speedIndex=[[user speedIndex] integerValue];
        stongIndex=[[user strongIndex] integerValue];
        speed=[self.titles2[speedIndex] integerValue];
        stong=[self.titles[stongIndex] integerValue];
    }else{
        speed=[(NSNumber*)[_modelArray objectAtIndex:3] integerValue];
        stong=[(NSNumber*)[_modelArray objectAtIndex:4] integerValue];
        speedIndex=[self.titles2 indexOfObject:speed<10?[@"0" stringByAppendingString:[NSString stringWithFormat:@"%d",speed]]:[NSString stringWithFormat:@"%d",speed]];
        stongIndex=[self.titles indexOfObject:[NSString stringWithFormat:@"%d",stong]];
    }
    
    
    [self.pickerView selectItem:1 animated:NO];
    [self.pickerView selectItem:stongIndex animated:NO];
    [self.pickerView2 selectItem:1 animated:NO];
    [self.pickerView2 selectItem:speedIndex animated:NO];
    isStart=true;
    
    if([CBLEManager sharedManager].Stu1==2){
        isStart=false;
        [[CBLEManager sharedManager] setDisconnectHandler:^(CBPeripheral * peripheral){
            if((peripheral==[CBLEManager sharedManager].peripheral1&&[CBLEManager sharedManager].peripheral2==nil)||(peripheral==[CBLEManager sharedManager].peripheral2&&[CBLEManager sharedManager].peripheral1==nil)){
                DXAlertView *alertView=[[DXAlertView alloc]initWithTitle:NSLocalizedString(@"ConnectError", nil) contentText:NSLocalizedString(@"ConnectErrorTip", nil) leftButtonTitle:nil rightButtonTitle:@"OK"];
                alertView.rightBlock=^(){
                    [self back];
                };
                [alertView show];
            }
            if(peripheral==[[CBLEManager sharedManager] peripheral1]){
                _deviceName1.hidden=YES;
                _device1.hidden=YES;
            }else{
                _deviceName2.hidden=YES;
                _device2.hidden=YES;
            }
        }];
        [[CBLEManager sharedManager] setSendDataHandler:^(NSString *st,CBPeripheral *per){
            
            if([[[st substringFromIndex:4] substringToIndex:2] isEqualToString:@"01"]){
                [self start];
                isStart=true;
                isPuse=false;
                [CBLEManager sharedManager].Stu1=1;
            }
        }];
        [self changeModel];
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).startDate=[NSDate date];
        lastDate=((AppDelegate *)[[UIApplication sharedApplication] delegate]).startDate;
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).lastDate=lastDate;
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).terval=0;
        timer= [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(Change) userInfo:nil repeats:YES];
        _prView.progress=0;
        terval=0;
    }else{
        terval=((AppDelegate *)[[UIApplication sharedApplication] delegate]).terval;
        lastDate=((AppDelegate *)[[UIApplication sharedApplication] delegate]).lastDate;
        _prView.progress=terval/([((NSNumber *)[_modelArray objectAtIndex:2]) floatValue]*60);
    }
    
    if(!timer){
        timer= [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(Change) userInfo:nil repeats:YES];
    }
    
    
    NSNumber *number=[_modelArray objectAtIndex:2];
    [_exerciseTime setText:[NSString stringWithFormat:@"%d%@",[number intValue],NSLocalizedString(@"Min", nil)]];
    [_exercisePart setText:(NSString *)[parts objectAtIndex:[_part integerValue]]];
    if(![CBLEManager sharedManager].peripheral2){
        [_deviceName1 setText:[CBLEManager sharedManager].peripheral1.name];
        _deviceName2.hidden=YES;
        _device2.hidden=YES;
    }else{
        [_deviceName1 setText:[CBLEManager sharedManager].peripheral1.name];
        [_deviceName2 setText:[CBLEManager sharedManager].peripheral2.name];
        _deviceName2.hidden=NO;
        _device2.hidden=NO;
    }
    [[CBLEManager sharedManager]setEndHandler:^(CBPeripheral *per){
        [timer invalidate];
        [[CBLEManager sharedManager]setEndHandler:nil];
        DXAlertView *alertView=[[DXAlertView alloc]initWithTitle:NSLocalizedString(@"StopSu", nil) contentText:nil leftButtonTitle:nil rightButtonTitle:@"OK"];
        alertView.dismissBlock=^(){
            [self back];
        };
        [alertView show];
    }];
    [self CreatePowerHandler];
}

-(float)parseInt:(NSString *)strs{
    
    float t=0;
    for(int i=0;i<strs.length;i++){
        NSString *str=[[strs substringFromIndex:i] substringToIndex:1];
        int d=0;
        if([str isEqualToString:@"a"]){
            d=10;
        }else if([str isEqualToString:@"b"]){
            d=11;
        }else if([str isEqualToString:@"c"]){
            d=12;
        }else if([str isEqualToString:@"d"]){
            d=13;
        }else if([str isEqualToString:@"e"]){
            d=14;
        }else if([str isEqualToString:@"f"]){
            d=15;
        }else{
            d=[str integerValue];
        }
        t=t+d*pow(16, (strs.length-i-1));
    }
    return t;
}
-(void)CreatePowerHandler{
    [[CBLEManager sharedManager]setPowerHandler:^(NSString *st,CBPeripheral *per){
        
        float progress=[self parseInt:[[st substringFromIndex:8] substringToIndex:2] ]/100;
        if(progress<0.2){
            [[CBLEManager sharedManager]setPowerHandler:nil];
            DXAlertView *alertView=[[DXAlertView alloc]initWithTitle:NSLocalizedString(@"PowerTitle", nil) contentText:[NSString stringWithFormat:NSLocalizedString(@"Power", nil),per.name] leftButtonTitle:nil rightButtonTitle:@"OK"];
            [alertView show];
            alertView.dismissBlock=^(){
                [self CreatePowerHandler];
            };
        }
        if(per==[CBLEManager sharedManager].peripheral1){
            
            self.oneView.frame = CGRectMake(0, 0, self.device1.frame.size.width * progress, self.device1.frame.size.height);
        }else{
            self.twoView.frame = CGRectMake(0, 0, self.device2.frame.size.width * progress, self.device2.frame.size.height);
        }
    }];
}
-(void)back{
    [[CBLEManager sharedManager] setEndHandler:nil];
    [[CBLEManager sharedManager] setPowerHandler:nil];
    Record *record=[self saveRecord];
    ExerciseRecordDetailViewController *_detail=[[ExerciseRecordDetailViewController alloc]init];
    _detail.record=record;
    [CBLEManager sharedManager].Stu1=2;
    [timer invalidate];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).evc=nil;
    [self.navigationController pushViewController:_detail animated:YES];
}

-(void)Change{
    NSDate *tDate=[NSDate date];
    NSDate *ttDate=lastDate;
    terval=terval+[tDate timeIntervalSinceDate:ttDate];
    float t=terval;
    float tt=[((NSNumber *)[_modelArray objectAtIndex:2]) floatValue]*60;
    float value=t/tt;
    if(value>1){
        value=1;
    }
    _prView.progress=value;
    if(value==1){
    DXAlertView *alertView=[[DXAlertView alloc]initWithTitle:NSLocalizedString(@"StopSu", nil) contentText:nil leftButtonTitle:nil rightButtonTitle:@"OK"];
        alertView.dismissBlock=^(){
                [self back];
            };
            [alertView show];
    
        }
    lastDate=[NSDate date];
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
    [_btn setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [_StopTip setText:NSLocalizedString(@"Puase", nil)];
    [_exercisePartLabel setText:NSLocalizedString(@"Body_Part", nil)];
    [_exerciseTimeLabel setText:NSLocalizedString(@"TrainTime", nil)];
    [_hideViewBtn setTitle :NSLocalizedString(@"Hide", nil) forState:UIControlStateNormal];
    [_hideViewBtn addTarget:self action:@selector(SthideView) forControlEvents:UIControlEventTouchUpInside];
    
    [_exerciseDetail setText:NSLocalizedString(@"Detail", nil)];
    [_prView initView:_prView.frame];
    _prView.noColor = [UIColor whiteColor];
    _prView.prsColor =[UIColor yellowColor];
    
    [_prView setBackgroundColor:[UIColor clearColor]];
    self.oneView = [[UIView alloc] init];
    self.oneView.clipsToBounds = YES;
    [_device1 addSubview:self.oneView];
    self.twoView = [[UIView alloc] init];
    self.twoView.clipsToBounds = YES;
    [_device2 addSubview:self.twoView];
    self.oneView.frame = CGRectMake(0, 0, self.device1.frame.size.width * 0.9, self.device1.frame.size.height);
    self.twoView.frame = CGRectMake(0, 0, self.device2.frame.size.width * 0.9, self.device2.frame.size.height);
    [self.oneView setBackgroundColor:[UIColor grayColor]];
    [self.twoView setBackgroundColor:[UIColor grayColor]];
}

/**发送按钮响应事件**/
-(void)selectedBtnPressed:(id)sender{
    [self changeModel];
}

-(void)changeModel{
    if([[CBLEManager sharedManager] isConnected]){
        /**速度是0x01对应第一个，所以提交修改的时候要+1**/
        [_modelArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithInteger:speed]];
        [_modelArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInteger:stong]];
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
        [timer setFireDate:[NSDate date]];
        lastDate=[NSDate date];
        terval=((AppDelegate *)[[UIApplication sharedApplication] delegate]).terval;
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).lastDate=lastDate;
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).terval=terval;
        return;
    }
    
    [_StopTip setText:NSLocalizedString(@"Resume", nil)];
    
    NSArray *array=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x05], nil];
    [[CBLEManager sharedManager] setSendDataHandler:^(NSString *st,CBPeripheral *per){
        [timer setFireDate:[NSDate distantFuture]];
        DXAlertView *alertView=[[DXAlertView alloc]initWithTitle:NSLocalizedString(@"PauseSu", nil)  contentText:nil leftButtonTitle:nil rightButtonTitle:@"OK"];
        [alertView show];
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).terval=terval;
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
-(void)SthideView{
    if (isHide) {
        _detailView.hidden=NO;
        isHide=NO;
        [_hideViewBtn setTitle :NSLocalizedString(@"Hide", nil) forState:UIControlStateNormal];
    }else{
        _detailView.hidden=YES;
        isHide=YES;
        [_hideViewBtn setTitle :NSLocalizedString(@"View", nil) forState:UIControlStateNormal];
    }
    
}
@end

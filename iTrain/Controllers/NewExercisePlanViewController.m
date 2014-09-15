//
//  NewExercisePlanViewController.m
//  iTrain
//
//  Created by Interest on 14-9-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "NewExercisePlanViewController.h"

#import "AppDelegate.h"
#define ANIMATE_DURATION                        0.25f
@interface NewExercisePlanViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
   NSArray *fontAry;
}
@end
UIColor *bg;
NSDate* _date;
BOOL isTime;
NSString * startText;//开始时间
NSString * timeLong;//时长
UITapGestureRecognizer *tapGesture ;
NSString *part;
AppDelegate *myAppDelegate;
@implementation NewExercisePlanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isTime=true;
        part=@"";
        fontAry=[[NSArray alloc] initWithObjects:@"手臂",@"胸部",@"腹部",@"背部",@"臀部",@"大腿",nil];
        myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"训练计划";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [self setRightCustomBarItems:_save];
    if(_oPlan!=nil){
        part=[_oPlan part];
        timeLong=[[NSString stringWithFormat:@"%d",[[_oPlan time] integerValue]] stringByAppendingString:@" min"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *destDateString = [dateFormatter stringFromDate:[_oPlan startTime]];
        startText=destDateString;
        _date=[_oPlan startTime];
    }
    [_tabelView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    part=@"";
    timeLong=@"";
    startText=@"";
    _date=nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化tableView的数据
    // 设置tableView的数据源
    _tabelView.dataSource = self;
    // 设置tableView的委托
    self.tabelView.delegate = self;
    // 设置tableView的背景图
    bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor=bg;
    self.tabelView.backgroundColor=bg;
    //    设置分割线
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self setExtraCellLineHidden:self.tabelView];
    [_save addTarget:self action:@selector(savePlan) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(cancelbuttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_subBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _partPick.delegate=self;
    _partPick.dataSource=self;
}

-(void)savePlan{
    Plan *sPlan;
    if(_oPlan==nil){
       sPlan=[NSEntityDescription insertNewObjectForEntityForName:@"Plan" inManagedObjectContext:myAppDelegate.managedObjectContext];
    }else{
        sPlan=_oPlan;
    }
    [sPlan setStartTime:_date];
    [sPlan setTime:[NSNumber numberWithInteger:[[timeLong substringToIndex:(timeLong.length-3)] integerValue]]];
    [sPlan setPart:part];
    NSLog(@"%@",[sPlan eventId]);
    if([sPlan eventId]!=nil){
        NSError *err=nil;
        [myAppDelegate.eventDB removeEvent:[myAppDelegate.eventDB eventWithIdentifier:[sPlan eventId]] span:EKSpanFutureEvents commit:YES error:&err];
    }
    if(self.isEvent){
        [self saveEvent:sPlan];
    }
    NSError *error = nil;
    BOOL isSave =   [myAppDelegate.managedObjectContext save:&error];
    if (!isSave) {
        NSLog(@"error:%@,%@",error,[error userInfo]);
    }
    else{
        NSLog(@"保存成功");
        [self showAlertViewWithMessage:@"保存成功！"];
    }
}
- (void)showAlertViewWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
        alertView = nil;
    });
}

//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *CustomCellIdentifier = @"Cell";
    static NSString *cellIdenifer = @"UserInfoViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenifer];
    if (!cell) {
        //导航风格
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdenifer ];
        cell.showsReorderControl = YES;
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    NSInteger row=[indexPath row];
 
    NSString *st;
    if(row==0){
        st=@"训练部位";
        cell.detailTextLabel.text=part;
    }else if(row==1){
        st=@"开始训练时间";
         cell.detailTextLabel.text=startText;
        
    }else{
        st=@"训练总时长";
        cell.detailTextLabel.text=timeLong;

    }
    cell.textLabel.text= st;
    cell.selectionStyle = UITableViewCellStyleValue1;
    [cell.contentView addSubview:cell.textLabel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

////隐藏TabelView下面多余分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//响应用户单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [self.view addGestureRecognizer:tapGesture];
    [_popView setHidden:NO];
    [_popView setAlpha:1];
    [_pickView setHidden:NO];
    [_subBtn setHidden:NO];
    [_cancelBtn setHidden:NO];
    [_partPick setHidden:YES];
    if (indexPath.row==0) {
        [_pickView setHidden:YES];
        [_subBtn setHidden:YES];
        [_cancelBtn setHidden:YES];
        [_partPick setHidden:NO];
    }else if(indexPath.row==1){
        _pickView.datePickerMode=UIDatePickerModeTime;
        isTime=true;
    }else if(indexPath.row==2){
        _pickView.datePickerMode=UIDatePickerModeCountDownTimer;
        isTime=false;
    }
    
}

- (void)tappedCancel
{
    //[_tabelView performSelector:@selector(<#selector#>)]
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        _popView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_popView setHidden:YES];
        }
    }];
    [self.view removeGestureRecognizer:tapGesture];
}


- (void)buttonPressed:(id)sender {
    if (isTime) {
        _date= [_pickView date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *destDateString = [dateFormatter stringFromDate:_date];
        startText=destDateString;
        [_tabelView reloadData];
        }else{
            //设置定时器
       
            NSDate *selected = [_pickView date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"mm"];
            
            NSString *mmDateString = [dateFormatter stringFromDate:selected];
            [dateFormatter setDateFormat:@"HH"];
              NSString *hhString = [dateFormatter stringFromDate:selected];
            int hh=[hhString intValue]*60;
            int mm=[mmDateString intValue]==0?1:[mmDateString intValue];
            timeLong=[[NSString stringWithFormat:@"%d",  (hh+mm) ] stringByAppendingString:@" min"];
            [_tabelView reloadData];
        }
    [_popView setHidden:YES];
    [self tappedCancel];
  
}
-(void)cancelbuttonPressed{
    [_popView setHidden:YES];
    [self tappedCancel];
}


/* return cor of pickerview*/

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    
    return 1;
    
}

/*return row number*/

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    
    return [fontAry count];
    
}


/*return component row str*/

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
    
    return [fontAry objectAtIndex:row];
    
}


/*choose com is component,row's function*/

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    NSString *fontname=[fontAry objectAtIndex:row];
    part=fontname;
    [_tabelView reloadData];
}

-(void)saveEvent:(Plan *)tplan{
    [myAppDelegate.eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted,NSError *error) {
        EKEvent *myEvent  = [EKEvent eventWithEventStore:myAppDelegate.eventDB];
        myEvent.title = [@"开始执行训练计划,训练部位:" stringByAppendingString:[tplan part]];
        NSDate *startDate=[tplan startTime];
        myEvent.startDate =startDate;
        
        myEvent.endDate   = startDate;
        EKRecurrenceRule *rule=[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:nil];
        [myEvent addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
        [myEvent addRecurrenceRule:rule];
        [myEvent setCalendar:[myAppDelegate.eventDB defaultCalendarForNewEvents]];
        NSError *err;
        [tplan setEventId:myEvent.eventIdentifier];
        [myAppDelegate.eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err];
        
    }];
}

@end

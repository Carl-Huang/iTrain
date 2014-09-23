//
//  ExercisePlanViewController.m
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ExercisePlanViewController.h"
#import "Plan.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
//训练计划

@interface ExercisePlanViewController()

@end
AppDelegate *myAppDelegate;
UIColor *bg;
NSMutableArray *dataarray;
NSInteger oindex;
NSInteger tindex;
NSArray *StartTimeArray;
NSArray *Partrray;
NSArray *TimeArray;
NSArray *parts;
@implementation ExercisePlanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataarray=[[NSMutableArray alloc]init];
        oindex=-1;
        parts=@[NSLocalizedString(@"Arm", nil),NSLocalizedString(@"Chest", nil),NSLocalizedString(@"Belly", nil),NSLocalizedString(@"Back", nil),NSLocalizedString(@"Buttocks", nil),NSLocalizedString(@"Thigh", nil)];
        StartTimeArray=[[NSArray alloc]initWithObjects:@"06:30",@"06:45",@"07:00",@"07:15",@"18:30",@"18:55",@"19:20",@"19:45", nil];
        Partrray=[[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"5",@"0",@"1",@"2",@"5", nil];
        TimeArray=[[NSArray alloc]initWithObjects:@"10",@"10",@"10",@"10",@"20",@"20",@"20",@"20", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = NSLocalizedString(@"TrainPlan", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [self setRightCustomBarItems:_notifyView];
    [_SwitchView setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"Clock"] boolValue]];
     [_SwitchView addTarget:self action:@selector(selectClicked) forControlEvents:UIControlEventValueChanged];
    [self initData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [_SwitchView removeTarget:self action:@selector(selectClicked) forControlEvents:UIControlEventValueChanged];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)initUI{
    // 设置tableView的数据源
    self.tabelView.dataSource = self;
    // 设置tableView的委托
    self.tabelView.delegate = self;
    // 设置tableView的背景图
    bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor=bg;
    self.tabelView.backgroundColor=bg;
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_SwitchView setOn:NO];

    
    [self setExtraCellLineHidden: self.tabelView];
    //    [self.view addSubview: self.tabelView];
   
    [_createPlan addTarget:self action:@selector(gotoCreatePlan) forControlEvents:UIControlEventTouchUpInside];
    [_editPlan addTarget:self action:@selector(editClearPlan) forControlEvents:UIControlEventTouchUpInside];
    [_clockLabel setText:NSLocalizedString(@"Alert", nil)];
    [_CreateTv setText:NSLocalizedString(@"NewPlan", nil)];
    [_ReNewTv setText:NSLocalizedString(@"ReNewPlan", nil)];
}

//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *CustomCellIdentifier = @"Cell";
    scell = [tableView dequeueReusableCellWithIdentifier:@"ExercisePlanCell"];
    if(!scell) {
        scell = [[[NSBundle mainBundle] loadNibNamed:@"ExercisePlanCell" owner:self options:nil]lastObject];
    }
    int row=[indexPath row];
    if (row%2) {
        scell.contentView.backgroundColor=[UIColor clearColor];
    }else{
        scell.contentView.backgroundColor=[UIColor whiteColor];
    }
    
    Plan *plan=[dataarray objectAtIndex:row];
    //    禁止选中效果
    scell.num.text=[NSString stringWithFormat:@"%d",(row+1)];
    scell.num.layer.borderColor  = [UIColor darkGrayColor].CGColor;
    scell.num.layer.cornerRadius = 10.0f;
    NSLog(@"%@",[plan part]);
    scell.name.text=[parts objectAtIndex:[[plan part] integerValue]];
    [scell.modifyOrDel setTitle:[NSString stringWithFormat:@"%@/%@",NSLocalizedString(@"edit", nil),NSLocalizedString(@"del", nil)] forState:UIControlStateNormal];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *destDateString = [dateFormatter stringFromDate:[plan startTime]];
    scell.time.text=destDateString;
    scell.timeLong.text=[[NSString stringWithFormat:@"%d",[[plan time] integerValue]] stringByAppendingString:@"min"];
    [scell.modifyOrDel addTarget:self action:@selector(twoBtnClicked:)forControlEvents:UIControlEventTouchUpInside];
    [scell.modifyOrDel setTag:indexPath.row];
    if (indexPath.row%2) {
        scell.backgroundColor=[UIColor clearColor];
    }
    return scell;
}
- (void)twoBtnClicked:(id)sender
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:NSLocalizedString(@"editType", nil) leftButtonTitle:NSLocalizedString(@"del", nil) rightButtonTitle:NSLocalizedString(@"edit", nil)];
    [alert show];
    alert.leftBlock = ^() {
        [self ClearPlan:[[NSArray alloc]initWithObjects:[dataarray objectAtIndex:[sender tag]], nil] withUI:YES];
    };
    alert.rightBlock = ^() {
        oindex=[sender tag];
        [self gotoCreatePlan];
    };
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
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
//#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

- (void)selectClicked{
    if ([_SwitchView isOn]) {
        [self saveEvent:dataarray];
    }else{
        [self ClearPlan:dataarray withUI:NO];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:[_SwitchView isOn]] forKey:@"Clock"];
}

//响应用户单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tindex==indexPath.row){
        tindex=-1;
        [tableView reloadData];
    }else{
        tindex=indexPath.row;
    }
}

-(void)initData{
    myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Plan"inManagedObjectContext:myAppDelegate.managedObjectContext];
    //设置请求实体
    [request setEntity:entity];
    //指定对结果的排序方式
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime"ascending:YES];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else{
        if(mutableFetchResult.count==0){
            [self defaultPlan];
        }else{
            dataarray=mutableFetchResult;
            for(int i=0;i<dataarray.count;i++){
                Plan *pplan=[dataarray objectAtIndex:i];
                NSLog(@"%@,%@",[pplan eventId],[pplan part]);
            }
        }
        [_tabelView reloadData];
    }
}

-(void)defaultPlan{
    NSError *error=nil;
    for(int i=0;i<TimeArray.count;i++){
        Plan *newPlan=[NSEntityDescription insertNewObjectForEntityForName:@"Plan" inManagedObjectContext:myAppDelegate.managedObjectContext];
        [newPlan setTime:[NSNumber numberWithInteger:[[TimeArray objectAtIndex:i] integerValue]]];
        [newPlan setPart:[Partrray objectAtIndex:i]];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy:MM:dd"];
        NSString *day=[formatter stringFromDate:[NSDate date]];
        [formatter setDateFormat:@"HH:mm"];
        day=[day stringByAppendingFormat:@" %@",[StartTimeArray objectAtIndex:i]];
        [formatter setDateFormat:@"yyyy:MM:dd HH:mm"];
        [newPlan setStartTime: [formatter dateFromString:day]];
       
        [dataarray addObject:newPlan];
    }
    if([_SwitchView isOn]){
       [self saveEvent:dataarray];
    }
    [myAppDelegate.managedObjectContext save:&error];
}

-(void)gotoCreatePlan{
    createPlanController=[[NewExercisePlanViewController alloc]init];
    if(oindex!=-1){
        createPlanController.oPlan=[dataarray objectAtIndex:oindex];
        oindex=-1;
    }else{
        createPlanController.oPlan=nil;
    }
    createPlanController.isEvent=[_SwitchView isOn];
    [self.navigationController pushViewController:createPlanController animated:YES];
    
}

-(void)editClearPlan{
    [self ClearPlan:dataarray withUI:YES];
    [self defaultPlan];
    [_tabelView reloadData];
}

-(void)ClearPlan:(NSArray *)tarray withUI:(BOOL)isDelteUi{
    [SVProgressHUD show];
    NSError *err=nil;
    for(Plan *plan in tarray){
        EKEvent *ev=[myAppDelegate.eventDB eventWithIdentifier:[plan eventId]];
        if(ev!=nil){
            //[myAppDelegate.eventDB delete:ev];
            [myAppDelegate.eventDB removeEvent:ev span:EKSpanFutureEvents commit:NO error:&err];
        }
        if(isDelteUi){
            [myAppDelegate.managedObjectContext deleteObject:plan];
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         NSError *err=nil;
        [myAppDelegate.eventDB commit:&err];
    });
  
    [myAppDelegate.managedObjectContext save:&err];
    if(isDelteUi){
        [dataarray removeObjectsInArray:tarray];
        [_tabelView reloadData];
    }
    [SVProgressHUD dismiss];
    
}

-(void)saveEvent:(NSArray *)tarray{
    [SVProgressHUD show];
    [myAppDelegate.eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted,NSError *error) {
        for(Plan *tplan in tarray){
            if([myAppDelegate.eventDB eventWithIdentifier:[tplan eventId]]==nil){
                EKEvent *myEvent  = [EKEvent eventWithEventStore:myAppDelegate.eventDB];
                
                myEvent.title = [NSLocalizedString(@"TrainPlanContent", nil) stringByAppendingString:[parts objectAtIndex:[[tplan part] integerValue]]];
                NSDate *startDate=[tplan startTime];
                myEvent.startDate =startDate;
                
                myEvent.endDate   = startDate;
                EKRecurrenceRule *rule=[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:nil];
                [myEvent addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
                [myEvent addRecurrenceRule:rule];
                [myEvent setCalendar:[myAppDelegate.eventDB defaultCalendarForNewEvents]];
                NSError *err;
                [myAppDelegate.eventDB saveEvent:myEvent span:EKSpanThisEvent commit:YES error:&err];
                
                BOOL isSu=[myAppDelegate.managedObjectContext save:&err];
                if(isSu){
                    [tplan setEventId:myEvent.eventIdentifier];
                    NSLog(@"保存成功");
                }else{
                    NSLog(@"error:%@,%@",err,[err userInfo]);
                }
               
            }
            if([tarray indexOfObject:tplan]==(tarray.count-1)){
                [SVProgressHUD dismiss];
            }
        }
    }];
}



@end

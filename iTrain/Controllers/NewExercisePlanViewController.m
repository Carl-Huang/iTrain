//
//  NewExercisePlanViewController.m
//  iTrain
//
//  Created by Interest on 14-9-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "NewExercisePlanViewController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#define ANIMATE_DURATION                        0.25f
@interface NewExercisePlanViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>{
    NSArray *fontAry;
}
@end
UIColor *bg;
NSDate* _date;
BOOL isTime;
NSString * startText;//开始时间
NSString * timeLong;//时长
UITapGestureRecognizer *tapGesture ;
NSInteger partIndex;
AppDelegate *myAppDelegate;
@implementation NewExercisePlanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isTime=true;
        fontAry=@[NSLocalizedString(@"Arm", nil),NSLocalizedString(@"Chest", nil),NSLocalizedString(@"Belly", nil),NSLocalizedString(@"Back", nil),NSLocalizedString(@"Buttocks", nil),NSLocalizedString(@"Thigh", nil)];
        myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = NSLocalizedString(@"TrainPlan", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [self setRightCustomBarItems:_save];
    if(_oPlan!=nil){
        partIndex=[[_oPlan part] integerValue];
        timeLong=[[NSString stringWithFormat:@"%d",[[_oPlan time] integerValue]] stringByAppendingString:@" min"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *destDateString = [dateFormatter stringFromDate:[_oPlan startTime]];
        startText=destDateString;
        _date=[_oPlan startTime];
        
    }
    [_tabelView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    timeLong=@"";
    startText=@"";
    partIndex=0;
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
    [_save setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [_subBtn setTitle:NSLocalizedString(@"Enter", nil) forState:UIControlStateNormal];
    [_cancelBtn setTitle:NSLocalizedString(@"cancle", nil) forState:UIControlStateNormal];
    _partPick.delegate=self;
    _partPick.dataSource=self;
    _tabelView.scrollEnabled = NO;
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
    [sPlan setPart:[NSString stringWithFormat: @"%d",partIndex]];
    if([sPlan eventId]!=nil){
        UIApplication *app = [UIApplication sharedApplication];
        //获取本地推送数组
        NSArray *localArr = [app scheduledLocalNotifications];
        //声明本地通知对象
        UILocalNotification *localNoti;
        if (localArr) {
            for (UILocalNotification *noti in localArr) {
                NSDictionary *dict = noti.userInfo;
                if (dict) {
                    NSString *inKey = [dict objectForKey:@"key"];
                    if ([inKey isEqualToString:[sPlan eventId]]) {
                        localNoti = noti;
                        break;
                    }
                }
            }
            //判断是否找到已经存在的相同key的推送
            if (localNoti) {
                [app cancelLocalNotification:localNoti];
            }
        }
    }
    NSError *error = nil;
    BOOL isSave =   [myAppDelegate.managedObjectContext save:&error];
    if (!isSave) {
        NSLog(@"error:%@,%@",error,[error userInfo]);
    }
    else{
        NSLog(@"保存成功");
        [self showAlertViewWithMessage];
    }
    if(self.isEvent){
        [self saveEvent:sPlan];
    }
   
}
- (void)showAlertViewWithMessage
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:NSLocalizedString(@"SaveSu", nil) leftButtonTitle:nil rightButtonTitle:@"OK"];
    [alert show];
    alert.dismissBlock=^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
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
        st=NSLocalizedString(@"TrainPart", nil);
        cell.detailTextLabel.text=[fontAry objectAtIndex:partIndex];
        ;
    }else if(row==1){
        st=NSLocalizedString(@"StartTrainTime", nil);
        cell.detailTextLabel.text=startText;
        
    }else{
        st=NSLocalizedString(@"TotalTrainTime", nil);
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
    if(indexPath.row==2){
        CGRect frame=tableView.frame;
        [tableView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, cell.frame.size.height*3)];
    }
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
    self.view.exclusiveTouch=NO;
    tapGesture.delegate=self;
    [self.view addGestureRecognizer:tapGesture];
    [_popView setHidden:NO];
    [_popView setAlpha:1];
    [_pickView setHidden:NO];
    [_subBtn setHidden:NO];
    [_cancelBtn setHidden:NO];
    [_partPick setHidden:YES];
    if (indexPath.row==0) {
        [_pickView setHidden:YES];
        [_subBtn setHidden:NO];
        [_cancelBtn setHidden:NO];
        [_partPick setHidden:NO];
    }else if(indexPath.row==1){
        _pickView.datePickerMode=UIDatePickerModeTime;
        isTime=true;
    }else if(indexPath.row==2){
        _pickView.datePickerMode=UIDatePickerModeCountDownTimer;
        isTime=false;
    }
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(_popView.hidden){
        return false;
    }
    if((_tabelView.frame.origin.y+_tabelView.frame.size.height)>[touch locationInView:self.view].y){
        return _popView.hidden;
    }else{
        return true;
    }
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        _popView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_popView setHidden:YES];
        }
    }];
    [self.view removeGestureRecognizer:tapGesture];
    [_tabelView reloadData];
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
        isTime=YES;
    }
    [_popView setHidden:YES];
    [self cancelbuttonPressed ];
    
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
    partIndex=row;
    [_tabelView reloadData];
}

-(void)saveEvent:(Plan *)tplan{
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    UIApplication *app = [UIApplication sharedApplication];
    if (noti) {
        
        //设置推送时间
        noti.alertAction=[NSLocalizedString(@"TrainPlanContent", nil) stringByAppendingString:[fontAry objectAtIndex:[[tplan part] integerValue]]];
        noti.fireDate =[tplan startTime];
        //设置时区
        
        noti.timeZone = [NSTimeZone defaultTimeZone];
        
        //设置重复间隔
        noti.repeatInterval =NSDayCalendarUnit;
        
        //推送声音
        
        noti.soundName =UILocalNotificationDefaultSoundName;
        
        //内容
        
        noti.alertBody =[NSLocalizedString(@"TrainPlanContent", nil) stringByAppendingString:[fontAry objectAtIndex:[[tplan part] integerValue]]];
        
        //显示在icon上的红色圈中的数子
        
        noti.applicationIconBadgeNumber =1;
        
        //设置userinfo 方便在之后需要撤销的时候使用
        NSLog(@"%@",[tplan eventId]);
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:[tplan eventId] forKey:@"key"];
        
        noti.userInfo = infoDic;
        
        //添加推送到uiapplication
        
        
        [app scheduleLocalNotification:noti];
        [tplan setEventId:[[[tplan objectID]URIRepresentation]absoluteString]];
    }
}

@end

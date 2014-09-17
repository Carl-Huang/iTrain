//
//  MainViewController.m
//  iTrain
//
//  Created by Carl on 14-8-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MainViewController.h"
#import "ExerciseMainViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
     
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];

    
    _exercise.userInteractionEnabled = YES;
    UITapGestureRecognizer *gotoExerciseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSecondView:)];
    [_exercise addGestureRecognizer:gotoExerciseTap];
    
    _setting.userInteractionEnabled=YES;
    UITapGestureRecognizer *gotoSettingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSettingView:)];
    [_setting addGestureRecognizer:gotoSettingTap];
    
    _userinfo.userInteractionEnabled=YES;
    UITapGestureRecognizer *gotoUserinfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserinfoView:)];
    [_userinfo addGestureRecognizer:gotoUserinfoTap];
    [self initData];
    [_TrainTv setText:NSLocalizedString(@"xunlian", nil)];
    [_UserTv setText:NSLocalizedString(@"UserInfo", nil)];
    [_SettingTv setText:NSLocalizedString(@"Setting", nil)];
}

-(void)initData{
    AppDelegate *myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    //创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"inManagedObjectContext:myAppDelegate.managedObjectContext];
    //设置请求实体
    [request setEntity:entity];
    //指定对结果的排序方式
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    for(User *user in mutableFetchResult){
        if([[user isChoose] boolValue]){
            [myAppDelegate setUser:user];
            return;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.title = @"首页";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    
}

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

- (void)gotoSecondView:(id)sender {
    
    if (DEVICE_IS_IPHONE5) {
      _ecerciseView= [[ExerciseMainViewController alloc]initWithNibName:@"ExerciseMainViewController4" bundle:nil];
    }else {
       _ecerciseView= [[ExerciseMainViewController alloc]initWithNibName:@"ExerciseMainViewController" bundle:nil];
    }
   
    [self.navigationController pushViewController:_ecerciseView animated:YES];
}

- (void)gotoSettingView:(id)sender {
    _settingView= [[SettingViewController alloc] init];
    [self.navigationController pushViewController:_settingView animated:YES];
}

- (void)gotoUserinfoView:(id)sender {
    if(userView==nil){
        userView= [[UserViewController alloc] init];

    }
    [self.navigationController pushViewController:userView animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end

//
//  MainViewController.m
//  iTrain
//
//  Created by Carl on 14-8-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MainViewController.h"
#import "ExerciseMainViewController.h"


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
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //图片的点击事件
    
    
    _exercise.userInteractionEnabled = YES;
    UITapGestureRecognizer *gotoExerciseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSecondView:)];
    [_exercise addGestureRecognizer:gotoExerciseTap];
    
    _setting.userInteractionEnabled=YES;
    UITapGestureRecognizer *gotoSettingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSettingView:)];
    [_setting addGestureRecognizer:gotoSettingTap];
    
    _userinfo.userInteractionEnabled=YES;
    UITapGestureRecognizer *gotoUserinfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserinfoView:)];
    [_userinfo addGestureRecognizer:gotoUserinfoTap];


}


- (void)gotoSecondView:(id)sender {
   _ecerciseView= [[ExerciseMainViewController alloc] init];
    [self.navigationController pushViewController:_ecerciseView animated:YES];
}
//- (void)gotoSettingView:(id)sender {
//    _settingView= [[SettingViewController alloc] init];
//    [self.navigationController pushViewController:_settingView animated:YES];
//}
- (void)gotoSettingView:(id)sender {
    _baike= [[BaiKeViewController alloc] init];
    [self.navigationController pushViewController:_baike animated:YES];
}
- (void)gotoUserinfoView:(id)sender {
    _userinfoView= [[UserInfoViewController alloc] init];
    [self.navigationController pushViewController:_userinfoView animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end

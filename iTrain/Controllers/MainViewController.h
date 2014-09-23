//
//  MainViewController.h
//  iTrain
//
//  Created by Carl on 14-8-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import <UIKit/UIKit.h>
#import "ExerciseMainViewController.h"
#import "UserInfoViewController.h"
#import "SettingViewController.h"
#import "BaiKeViewController.h"
#import "AboutViewController.h"
#import "UserViewController.h"

@interface MainViewController : CommonViewController
{
//@interface MainViewController : UIViewController
//{

//    UIImageView* exercise;
//    UIImageView* userInfo;
//    UIImageView* setting;
    
    ExerciseMainViewController *_ecerciseView;
    UserInfoViewController * _userinfoView;
    SettingViewController * _settingView;
    BaiKeViewController * _baike;
    AboutViewController * _about;
    UserViewController *userView;
}
@property (weak, nonatomic) IBOutlet UILabel *UserTv;
@property (weak, nonatomic) IBOutlet UILabel *TrainTv;
@property (weak, nonatomic) IBOutlet UILabel *SettingTv;
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) IBOutlet UIImageView *exercise;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *userinfo;

@property (weak, nonatomic) IBOutlet UIImageView *setting;

 

@end

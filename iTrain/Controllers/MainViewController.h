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
}
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) IBOutlet UIImageView *exercise;

@property (weak, nonatomic) IBOutlet UIImageView *userinfo;

@property (weak, nonatomic) IBOutlet UIImageView *setting;

 

@end

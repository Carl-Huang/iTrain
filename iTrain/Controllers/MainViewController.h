//
//  MainViewController.h
//  iTrain
//
//  Created by Carl on 14-8-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import <UIKit/UIKit.h>

@interface MainViewController : CommonViewController
{
    UIImageView* exercise;
    UIImageView* userInfo;
    UIImageView* setting;
}

@property (weak, nonatomic) IBOutlet UIImageView *exercise;

@property (weak, nonatomic) IBOutlet UIImageView *userinfo;

@property (weak, nonatomic) IBOutlet UIImageView *setting;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *on;
@property (weak, nonatomic) IBOutlet UIImageView *button;

-(IBAction)exerciseSelector:(id)sender;
-(IBAction)userInfoSelector:(id)sender;
-(IBAction)settingSelector:(id)sender;
@end

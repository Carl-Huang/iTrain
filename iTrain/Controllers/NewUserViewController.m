//
//  NewUserViewController.m
//  iTrain
//
//  Created by Interest on 14-8-28.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "NewUserViewController.h"

@interface NewUserViewController ()

@end

@implementation NewUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.title = @"新建用户";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];

}
-(void)initUI{
//设置圆角
    _userInfoView.layer.cornerRadius = 8;
    _userInfoView.layer.masksToBounds = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

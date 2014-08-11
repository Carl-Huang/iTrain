//
//  BaiKeViewController.m
//  iTrain
//
//  Created by Interest on 14-8-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaiKeViewController.h"

@interface BaiKeViewController ()

@end

@implementation BaiKeViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //图片的点击事件
    
    
    _zhengimage.userInteractionEnabled = YES;
    UITapGestureRecognizer *gotoExerciseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSecondView:)];
    [_zhengimage addGestureRecognizer:gotoExerciseTap];
    
    
    
}


- (void)gotoSecondView:(id)sender {
//    _ecerciseView= [[ExerciseMainViewController alloc] init];
//    [self.navigationController pushViewController:_ecerciseView animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ExerciseMainViewController.m
//  iTrain
//
//  Created by Interest on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ExerciseMainViewController.h"

@interface ExerciseMainViewController ()


@end

@implementation ExerciseMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _startView.userInteractionEnabled=YES;
    UITapGestureRecognizer *gotoStartView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoStartView:)];
    [_startView addGestureRecognizer:gotoStartView];
    
    _recordView.userInteractionEnabled=YES;
    UITapGestureRecognizer *gotoRecordView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoRecordView:)];
    [_recordView addGestureRecognizer:gotoRecordView];
    
    _planView.userInteractionEnabled=YES;
    UITapGestureRecognizer *gotoPlanView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPlanView:)];
    [_planView addGestureRecognizer:gotoPlanView];
    [_StartTv setText:NSLocalizedString(@"startxunlian", nil)];
    [_RecordTv setText:NSLocalizedString(@"TrainRecord", nil)];
    [_PlanTv setText:NSLocalizedString(@"TrainPlan", nil)];
}
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
- (void)gotoStartView:(id)sender {
    
    if (DEVICE_IS_IPHONE5) {
        start= [[StarExerciseViewController alloc] initWithNibName:@"StarExerciseViewController4" bundle:nil];
    }else {
        start= [[StarExerciseViewController alloc] initWithNibName:@"StarExerciseViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:start animated:YES];
}
- (void)gotoRecordView:(id)sender {
    record= [[ExerciseRecordViewController alloc] init];
    [self.navigationController pushViewController:record animated:YES];
}
- (void)gotoPlanView:(id)sender {
    plan= [[ExercisePlanViewController alloc] init];
    [self.navigationController pushViewController:plan animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title =NSLocalizedString(@"xunlian", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

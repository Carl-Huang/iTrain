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
}
- (void)gotoStartView:(id)sender {
    start= [[StarExerciseViewController alloc] init];
    [self.navigationController pushViewController:start animated:YES];
}
- (void)gotoRecordView:(id)sender {
    record= [[ExerciseRecordViewController alloc] init];
    [self.navigationController pushViewController:record animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title =@"训练";
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

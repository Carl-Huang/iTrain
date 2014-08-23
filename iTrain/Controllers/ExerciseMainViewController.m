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
    
    
}


- (void)gotoStartView:(id)sender {
    start= [[StarExerciseViewController alloc] init];
    [self.navigationController pushViewController:start animated:YES];
}

    

//    [self.navController setNavigationBarHidden:YES animated:NO];
 
    // Do any additional setup after loading the view from its nib.



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"train_bg"]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

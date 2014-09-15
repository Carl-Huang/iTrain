//
//  SuggestViewController.m
//  iTrain
//
//  Created by Interest on 14-8-18.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SuggestViewController.h"
#import "HttpService.h"
#import "DXAlertView.h"
#import "SVProgressHUD.h"
@interface SuggestViewController ()

@end

@implementation SuggestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"意见与反馈";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [_save addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchDown];
    [self setRightCustomBarItems:_save];
  
    
}

-(void)send{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:[_tv text] forKey:@"msg"];
[SVProgressHUD show];
 [[HttpService sharedInstance] feeback:dic completionBlock:^(id object) {
     NSDictionary *dic=(NSDictionary *)object;
     if([[dic valueForKey:@"statusCode"] integerValue]==200){
         [SVProgressHUD dismiss];
         DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"您的反馈我们已经收到" leftButtonTitle:nil rightButtonTitle:@"OK"];
         [alert show];
         alert.rightBlock = ^() {
            
             [self.navigationController popViewControllerAnimated:YES];
         };
         alert.dismissBlock=^(){
             [self.navigationController popViewControllerAnimated:YES];
         };
         
     }
 } failureBlock:^(NSError *error, NSString *reponseString) {
     [SVProgressHUD showErrorWithStatus:@"提交失败"];
 }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

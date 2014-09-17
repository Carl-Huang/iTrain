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
#import "DaiDodgeKeyboard.h"
@interface SuggestViewController ()<KeyboardDelegate>

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
    self.title =NSLocalizedString(@"FeedbackSend", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [_save addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchDown];
    [self setRightCustomBarItems:_save];
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view inputViewDelegate:self];
    [_save setTitle:NSLocalizedString(@"Sub", nil) forState:UIControlStateNormal];
}

-(void)send{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:[_tv text] forKey:@"msg"];
    [SVProgressHUD show];
    [DaiDodgeKeyboard textFieldDone];
    [[HttpService sharedInstance] feeback:dic completionBlock:^(id object) {
        NSDictionary *dic=(NSDictionary *)object;
        
        if([[dic valueForKey:@"statusCode"] integerValue]==200){
            [SVProgressHUD dismissWithSuccess:NSLocalizedString(@"SubSu", nil) afterDelay:1];
           [self.navigationController popViewControllerAnimated:YES];
           
            
        }
    } failureBlock:^(NSError *error, NSString *reponseString) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SubError", nil)];
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

#pragma mark -
-(NSArray *)inputArray{
    return [[NSArray alloc]initWithObjects:_tv, nil];
}

-(Boolean)prev:(UIView *)view{
   return false;
}

-(Boolean)next:(UIView *)view{
    return false;
}

@end

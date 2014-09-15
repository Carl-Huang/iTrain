//
//  CommonViewController.m
//  YueXing100
//
//  Created by Carl on 13-12-11.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "HWSDK_Constants.h"
#import "AppMacros.h"
#import "DXAlertView.h"
@interface CommonViewController ()

@end

@implementation CommonViewController
#pragma mark - Lify Cycle
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
#ifdef iOS7_SDK
    if([OSHelper iOS7])
    {
        if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
            [self setExtendedLayoutIncludesOpaqueBars:NO];
            [self prefersStatusBarHidden];
            [self preferredStatusBarStyle];
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
#endif
    self.wantsFullScreenLayout = NO;
    
    [self initUI];

}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleBlackTranslucent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Instance Methods

- (void)initUI
{
    
}

- (void)showAlertViewWithMessage:(NSString *)message
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"保存成功" leftButtonTitle:nil rightButtonTitle:@"OK"];
    [alert show];
    alert.dismissBlock=^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
}

@end

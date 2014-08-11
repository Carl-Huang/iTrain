//
//  NavigationBar.m
//  iTrain
//
//  Created by Interest on 14-8-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initNavigationBar{
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    
    [bar setBackgroundImage:[UIImage imageNamed:@"zhuche_bar2.png"] forBarMetrics:UIBarMetricsDefault];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [left setFrame:CGRectMake(0, 2, 28, 28)];
    
    [left setImage:[UIImage imageNamed:@"zhuche_back.png"] forState:UIControlStateNormal];
    
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    [item setLeftBarButtonItem:leftButton];
    
    [bar pushNavigationItem:item animated:NO];
    
    [self.view addSubview:bar];
    
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end

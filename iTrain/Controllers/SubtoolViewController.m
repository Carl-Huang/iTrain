//
//  SubtoolViewController.m
//  iTrain
//
//  Created by Interest on 14-9-22.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SubtoolViewController.h"

@interface SubtoolViewController ()

@end

@implementation SubtoolViewController

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
    self.title = NSLocalizedString(@"Subtool", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
 
    
}

@end

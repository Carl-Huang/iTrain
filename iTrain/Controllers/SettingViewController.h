//
//  SettingViewController.h
//  iTrain
//
//  Created by Interest on 14-8-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaiKeViewController.h"
#import "AboutViewController.h"
#import "BlueToothViewController.h"
#import "ParamSetViewController.h"

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BaiKeViewController *_baike;
    AboutViewController *_about;
    BlueToothViewController *_blueTooth;
    ParamSetViewController *_paramSet;
}
@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, retain) NSArray *imageList;

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (nonatomic, retain) UITableView *myTableView;

@end

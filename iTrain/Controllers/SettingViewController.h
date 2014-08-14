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

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BaiKeViewController *_baike;
     AboutViewController *_about;
}
@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, retain) NSArray *imageList;

@property (nonatomic, retain) UITableView *myTableView;

@end

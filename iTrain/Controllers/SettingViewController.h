//
//  SettingViewController.h
//  iTrain
//
//  Created by Interest on 14-8-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaiKeViewController.h"

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BaiKeViewController *_baike;
}
@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, retain) NSArray *imageList;

@property (nonatomic, retain) UITableView *myTableView;

@end

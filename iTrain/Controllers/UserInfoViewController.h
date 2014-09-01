//
//  UserInfoViewController.h
//  iTrain
//
//  Created by Interest on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, retain) NSArray *imageList;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

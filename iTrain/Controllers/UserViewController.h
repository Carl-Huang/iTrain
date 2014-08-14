//
//  UserViewController.h
//  iTrain
//
//  Created by Interest on 14-8-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//
//用户列表
#import <UIKit/UIKit.h>
#include "UserCollectionViewCell.h"
@interface UserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UserCollectionViewCell *cell;
}

@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, retain) NSArray *imageList;
@property (weak, nonatomic) IBOutlet UITableView *userTabelView;

@end

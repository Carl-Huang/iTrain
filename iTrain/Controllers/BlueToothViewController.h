//
//  BlueToothViewController.h
//  iTrain
//
//  Created by Interest on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueToothCell.h"
@interface BlueToothViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *deviceTv;
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

//
//  SysNotiViewController.h
//  iTrain
//
//  Created by Interest on 14-8-18.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SysNotiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *child_array;
    NSMutableArray *father_array;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tv;
@end

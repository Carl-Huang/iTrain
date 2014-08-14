//
//  HelpViewController.h
//  iTrain
//
//  Created by Interest on 14-8-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    NSMutableArray *ar;
    BOOL cell0_ison;
    BOOL cell1_ison;
    BOOL cell2_ison;
    BOOL cell3_ison;
    BOOL cell4_ison;
    BOOL cell5_ison;
  
}
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

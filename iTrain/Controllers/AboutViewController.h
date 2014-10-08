//
//  AboutViewController.h
//  iTrain
//
//  Created by Interest on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpViewController.h"
#import "SysNotiViewController.h"
#import "SuggestViewController.h"
#import "BlueToothViewController.h"
#import "SMVViewController.h"

@interface AboutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    HelpViewController *help;
    SysNotiViewController *sys;
    SuggestViewController *sugg;
    SMVViewController * subtool;

    
}
@property (weak, nonatomic) IBOutlet UILabel *Copyright;
@property (weak, nonatomic) IBOutlet UILabel *TitleTv;
@property (nonatomic, retain) NSArray *dataList;

@property (weak, nonatomic) IBOutlet UITableView *seTabelView;


@end

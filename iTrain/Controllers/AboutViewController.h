//
//  AboutViewController.h
//  iTrain
//
//  Created by Interest on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpViewController.h"

@interface AboutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    HelpViewController *help;
    
}
@property (nonatomic, retain) NSArray *dataList;

@property (weak, nonatomic) IBOutlet UITableView *seTabelView;


@end

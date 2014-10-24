//
//  HelpViewController.h
//  iTrain
//
//  Created by Interest on 14-8-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "SuggestViewController.h"


@interface HelpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    SuggestViewController *suggView;
    NSMutableArray *child_array;
    NSMutableArray *father_array;

}
@property (weak, nonatomic) IBOutlet UILabel *TitleTv;
@property (weak, nonatomic) IBOutlet UILabel *SendTv;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *suggestView;
@property (weak, nonatomic) IBOutlet UIButton *suggestBtn;

+ (BOOL)getPreferredLanguage;


@end

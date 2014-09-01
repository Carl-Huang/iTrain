//
//  ExercisePlanViewController.h
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExercisePlanCell.h"
#import "CustomSwitch.h"

@interface ExercisePlanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    ExercisePlanCell *scell;
}
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (weak, nonatomic) IBOutlet UIButton *createPlan;//新加计划
@property (weak, nonatomic) IBOutlet UIButton *editPlan;//编辑计划
@property (weak, nonatomic) IBOutlet UIButton *notifySetting;//闹钟
@property (weak, nonatomic) IBOutlet UILabel* clockLabel;//闹钟
@property (weak, nonatomic) IBOutlet UIButton*clockBtn;//闹钟
@property (weak, nonatomic) IBOutlet UIView*notifyView;//闹钟
@end

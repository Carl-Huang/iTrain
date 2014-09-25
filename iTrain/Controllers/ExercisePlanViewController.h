//
//  ExercisePlanViewController.h
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExercisePlanCell.h"
#import "CommonViewController.h"
#import "DXAlertView.h"

#import "NewExercisePlanViewController.h"
@interface ExercisePlanViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>{
    
    ExercisePlanCell * scell;
    NewExercisePlanViewController *createPlanController;
}
@property (weak, nonatomic) IBOutlet UILabel *ReNewTv;
@property (weak, nonatomic) IBOutlet UILabel *CreateTv;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (weak, nonatomic) IBOutlet UIButton *createPlan;//新加计划
@property (weak, nonatomic) IBOutlet UIButton *editPlan;//删除计划（重新计划）

@property (weak, nonatomic) IBOutlet UILabel* clockLabel;//闹钟
@property (weak, nonatomic) IBOutlet UIButton *SwitchView;

@property (weak, nonatomic) IBOutlet UIView*notifyView;//闹钟
@end



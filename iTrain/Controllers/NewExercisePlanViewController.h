//
//  NewExercisePlanViewController.h
//  iTrain
//
//  Created by Interest on 14-9-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXAlertView.h"
#import "Plan.h"

@interface NewExercisePlanViewController : UIViewController <UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickView;
@property (weak, nonatomic) IBOutlet UIView *popView;


@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property(nonatomic,strong)Plan *oPlan;
@property(nonatomic)BOOL isEvent;
@property (weak, nonatomic) IBOutlet UIPickerView *partPick;

@end

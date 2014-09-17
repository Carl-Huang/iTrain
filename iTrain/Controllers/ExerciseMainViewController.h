//
//  ExerciseMainViewController.h
//  iTrain
//
//  Created by Interest on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarExerciseViewController.h"
#import "ExerciseRecordViewController.h"
#import "ExercisePlanViewController.h"
@interface ExerciseMainViewController : UIViewController
{
    StarExerciseViewController * start;
    ExerciseRecordViewController * record;
    ExercisePlanViewController * plan;
}
@property (weak, nonatomic) UIView *tabelView;
@property (weak, nonatomic) IBOutlet UIImageView *startView;
@property (weak, nonatomic) IBOutlet UIImageView *recordView;
@property (weak, nonatomic) IBOutlet UIImageView *planView;
@property (weak, nonatomic) IBOutlet UILabel *StartTv;
@property (weak, nonatomic) IBOutlet UILabel *RecordTv;
@property (weak, nonatomic) IBOutlet UILabel *PlanTv;

@end

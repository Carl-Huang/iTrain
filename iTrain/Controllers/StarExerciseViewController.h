//
//  StarExerciseViewController.h
//  iTrain
//
//  Created by Interest on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"
#import "ExerciseParamViewController.h"
#import "DXAlertView.h"
#import "BlueToothViewController.h"
#import "MTImageMapView.h"
#import "Record.h"

@interface StarExerciseViewController : UIViewController{
    ExerciseParamViewController *exerciseParam;
     BlueToothViewController *connectBT;
}
@property (weak, nonatomic) IBOutlet MTImageMapView *popView;
@property (weak, nonatomic) IBOutlet MTImageMapView *body;
@property (weak, nonatomic) IBOutlet AKPickerView *paramView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, assign) NSInteger timeIndex;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) Record *record;
@end

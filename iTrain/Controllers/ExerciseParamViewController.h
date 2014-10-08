//
//  ExerciseParamViewController.h
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"
#import "ZDProgressView.h"

@interface ExerciseParamViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *StopTip;
@property (weak, nonatomic) IBOutlet UILabel *setTv;
@property (weak, nonatomic) IBOutlet UILabel *speedTv;
@property (weak, nonatomic) IBOutlet UILabel *stongTv;
@property (weak, nonatomic) IBOutlet AKPickerView *pickerView;
@property (weak, nonatomic) IBOutlet AKPickerView *pickerView2;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic,strong)NSString *part;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *exercisePartLabel;
@property (weak, nonatomic) IBOutlet UILabel *exercisePart;
@property (weak, nonatomic) IBOutlet UILabel *exerciseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseTime;
@property (weak, nonatomic) IBOutlet UILabel *deviceName1;
@property (weak, nonatomic) IBOutlet UILabel *deviceName2;

@property (weak, nonatomic) IBOutlet UILabel *exerciseDetail;
@property (weak, nonatomic) IBOutlet UIImageView * device1;
@property (weak, nonatomic) IBOutlet UIImageView * device2;
@property (weak, nonatomic) IBOutlet UIButton * hideViewBtn;
@property (weak, nonatomic) IBOutlet ZDProgressView *prView;

@end

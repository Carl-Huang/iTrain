//
//  ExerciseParamViewController.h
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"


@interface ExerciseParamViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *StopTip;
@property (weak, nonatomic) IBOutlet UILabel *StartTip;
@property (weak, nonatomic) IBOutlet UILabel *setTv;
@property (weak, nonatomic) IBOutlet UILabel *speedTv;
@property (weak, nonatomic) IBOutlet UILabel *stongTv;
@property (weak, nonatomic) IBOutlet AKPickerView *pickerView;
@property (weak, nonatomic) IBOutlet AKPickerView *pickerView2;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic,strong)NSString *part;
@end

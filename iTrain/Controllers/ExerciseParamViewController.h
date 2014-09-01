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
@property (weak, nonatomic) IBOutlet AKPickerView *pickerView;
@property (weak, nonatomic) IBOutlet AKPickerView *pickerView2;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (nonatomic, strong) NSMutableArray *modelArray;
@end

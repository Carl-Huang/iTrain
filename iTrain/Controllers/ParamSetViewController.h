//
//  ParamSetViewController.h
//  iTrain
//
//  Created by Interest on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "AKPickerView.h"
#import "CBLEManager.h"
#import "User.h"
@interface ParamSetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet AKPickerView *pickerView;
@property (weak, nonatomic) IBOutlet AKPickerView *pickerView2;
@property (weak, nonatomic) IBOutlet UILabel *Pw;
@property (weak, nonatomic) IBOutlet UILabel *HzTv;
@property (weak, nonatomic) IBOutlet UILabel *SettingTv;
@property (weak, nonatomic) IBOutlet UILabel *saveTip;

@end

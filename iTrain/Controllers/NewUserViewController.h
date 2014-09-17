//
//  NewUserViewController.h
//  iTrain
//
//  Created by Interest on 14-8-28.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "DaiDodgeKeyboard.h"
#import "CommonViewController.h"

@interface NewUserViewController : CommonViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,KeyboardDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UILabel *sexText;
@property (weak, nonatomic) IBOutlet UITextField *ageText;
@property (weak, nonatomic) IBOutlet UITextField *hightText;
@property (weak, nonatomic) IBOutlet UITextField *weightText;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UILabel *NameTip;
@property (weak, nonatomic) IBOutlet UILabel *SexTip;
@property (weak, nonatomic) IBOutlet UILabel *AgeTip;
@property (weak, nonatomic) IBOutlet UILabel *HeightTip;
@property (weak, nonatomic) IBOutlet UILabel *WeightTip;
@property (weak, nonatomic) IBOutlet UILabel *PhotoTip;



@property (weak, nonatomic) IBOutlet UIButton *save;
- (IBAction)backgroundTap:(id)sender;




@end

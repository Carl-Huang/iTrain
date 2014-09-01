//
//  NewUserViewController.h
//  iTrain
//
//  Created by Interest on 14-8-28.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewUserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *sexText;
@property (weak, nonatomic) IBOutlet UITextField *ageText;
@property (weak, nonatomic) IBOutlet UITextField *hightText;
@property (weak, nonatomic) IBOutlet UITextField *weightText;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@end

//
//  UserInfoViewController.h
//  iTrain
//
//  Created by Interest on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaiDodgeKeyboard.h"
#import "User.h"
@interface UserInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,KeyboardDelegate>
@property (nonatomic, retain) NSMutableArray *dataList;
@property (nonatomic, retain) NSArray *imageList;

@property (weak, nonatomic) IBOutlet UILabel *Tip;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic)  UIImageView*headImg;
@property (weak ,nonatomic)    UITextField *edit;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *gongzhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *yingzhiBtn;


@property(nonatomic,strong)User *user;


@end

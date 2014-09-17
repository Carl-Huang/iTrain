//
//  UserViewController.h
//  iTrain
//
//  Created by Interest on 14-8-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//
//用户列表
#import <UIKit/UIKit.h>
#import "UserCollectionViewCell.h"
#import "UserInfoViewController.h"


@interface UserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UserCollectionViewCell *scell;
    UserInfoViewController *userinfoController;
}



@property (weak, nonatomic) IBOutlet UIButton *NewTip;
@property (weak, nonatomic) IBOutlet UITableView *contetTabelView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableViewCell *contentCell;
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UILabel *contentUserName;
@property (weak, nonatomic) IBOutlet UILabel *contentUserAge;
@property (weak, nonatomic) IBOutlet UILabel *contentUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentUserLine;
@property (weak, nonatomic) IBOutlet UIView *popContentView;


@property (nonatomic, retain) NSArray *imageList;
@property (nonatomic, retain) NSArray *contentNameList;
@property (nonatomic, retain) NSArray *contentImageList;
@property (weak, nonatomic) IBOutlet UITableView *userTabelView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) NSMutableArray *dataArray;
- (void)popoverBtnClicked:(id)sender forEvent:(UIEvent *)event;

@end

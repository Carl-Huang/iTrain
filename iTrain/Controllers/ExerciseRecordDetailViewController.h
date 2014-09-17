//
//  ExerciseRecordDetailViewController.h
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import "Record.h"

@interface ExerciseRecordDetailViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *wxTv;
@property (weak, nonatomic) IBOutlet UILabel *shareTitle;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIImageView *popWx;
@property (weak, nonatomic) IBOutlet UIImageView *popFb;
@property (weak, nonatomic) IBOutlet UIButton *popCancel;

@property (nonatomic, strong) Record *record;
@end

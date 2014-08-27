//
//  ExerciseRecordDetailViewController.h
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseRecordDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@property (nonatomic, retain) NSArray *dateList;
@property (nonatomic, retain) NSArray *timeList;
@property (nonatomic, retain) NSArray *nameList;
@property (nonatomic, retain) NSArray *imageList;

@end

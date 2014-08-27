//
//  ExerciseRecordViewController.h
//  iTrain
//
//  Created by Interest on 14-8-23.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseRecordCell.h"
#import "ExerciseRecordDetailViewController.h"
@interface ExerciseRecordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    ExerciseRecordCell *scell;
    ExerciseRecordDetailViewController * _detail;
    
}
@property (nonatomic, retain) NSArray *dateList;
@property (nonatomic, retain) NSArray *timeList;
@property (nonatomic, retain) NSArray *nameList;
@property (nonatomic, retain) NSArray *imageList;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end

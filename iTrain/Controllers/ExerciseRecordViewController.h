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

@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UILabel *DelTip;

@end

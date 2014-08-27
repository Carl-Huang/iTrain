//
//  ExercisePlanViewController.h
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExercisePlanCell.h"

@interface ExercisePlanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    ExercisePlanCell *scell;
}
@property (weak, nonatomic) IBOutlet UITableView *tabelView;


@end

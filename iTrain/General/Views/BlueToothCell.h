//
//  BlueToothCell.h
//  iTrain
//
//  Created by Interest on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueToothCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectLabel;
@property (weak, nonatomic) IBOutlet UIView *ContentView;
@property (weak, nonatomic) IBOutlet UILabel *deviceVer;

@property (weak, nonatomic) IBOutlet UILabel *appVer;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@end

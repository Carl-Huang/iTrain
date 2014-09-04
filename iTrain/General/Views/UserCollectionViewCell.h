//
//  UserCollectionViewCell.h
//  iTrain
//
//  Created by Interest on 14-8-2.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface UserCollectionViewCell : UITableViewCell

{
    UILabel             *_userLabel;
    UILabel             *_userName;
    UILabel             *_userAge;
    
    UIImageView         *_userImage;
    UIImageView         *_selectImage;
}

@property (nonatomic, strong) IBOutlet  UILabel             *userLabel;
@property (nonatomic, strong) IBOutlet  UILabel             *userName;
@property (nonatomic, strong) IBOutlet  UILabel             *userAge;

@property (nonatomic, strong) IBOutlet  UIImageView         *userImage;
@property (nonatomic, strong) IBOutlet  UIButton         *select;
@property (nonatomic, strong) IBOutlet  UIImageView         *selectImg;
@property (nonatomic, strong) IBOutlet  UIView         *sview;
@property (nonatomic, strong) IBOutlet  UIImageView         *divline;
@end

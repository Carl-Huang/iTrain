//
//  UserCollectionViewCell.m
//  iTrain
//
//  Created by Interest on 14-8-2.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UserCollectionViewCell.h"


@implementation UserCollectionViewCell

@synthesize userName = _userName;
@synthesize userAge = _userAge;

@synthesize userImage = _userImage;
@synthesize selectImage =_selectImage;

//使用手动的方法来定义cell里面的控件内容
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//      
//    }
//    return self;
//}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   
    if (self) {
//        全部显示图片，但是可能有空白
        self.userImage.contentMode = UIViewContentModeScaleAspectFit;
        self.selectImage.contentMode = UIViewContentModeScaleAspectFit;
       
    }
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

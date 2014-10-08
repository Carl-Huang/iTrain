//
//  BaiKeViewController.h
//  iTrain
//
//  Created by Interest on 14-8-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "klpView.h"
@interface BaiKeViewController : UIViewController<UIScrollViewDelegate>{
	NSArray *imgArr;

	int index;
}


@property (weak, nonatomic) IBOutlet UILabel *BaiKeTitle;

@property (weak, nonatomic) IBOutlet UILabel *page;

@property (weak, nonatomic) IBOutlet UIView *tittleView;
@end

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
	klpView *klp;
	int index;
}


@end

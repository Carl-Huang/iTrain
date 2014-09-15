//
//  DemoTableViewCell.h
//  RTLabelProject
//
//  Created by honcheng on 5/1/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@protocol LoadingDelegate ;

@interface SyTableViewCell : UITableViewCell<UIWebViewDelegate>{
	UIWebView *rtLabel;
    id<LoadingDelegate> delagate;
}
@property (nonatomic,strong) UIWebView *rtLabel;
-(void)settDelagate:(id<LoadingDelegate>) tdelagate;
@end
@protocol LoadingDelegate <NSObject>

-(void)WebViewHeight:(CGFloat )height;

@end
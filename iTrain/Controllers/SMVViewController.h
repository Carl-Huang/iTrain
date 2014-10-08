//
//  SMVViewController.h
//  iTrain
//
//  Created by Interest on 14-10-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface SMVViewController : CommonViewController<UIScrollViewDelegate>{
    NSArray *imgArr;
    
	int index;
}
@property (weak, nonatomic) IBOutlet UIScrollView *sView;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *detailTitttle;
@property (weak, nonatomic) IBOutlet UILabel *detailTittle2;

@end

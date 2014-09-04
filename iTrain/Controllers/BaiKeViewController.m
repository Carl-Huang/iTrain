//
//  BaiKeViewController.m
//  iTrain
//
//  Created by Interest on 14-8-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaiKeViewController.h"

@interface BaiKeViewController ()



@property (nonatomic,retain)IBOutlet UIScrollView *imgScroll;
@property (nonatomic,retain)NSMutableArray *klpImgArr;
@end

    CGFloat hight;
@implementation BaiKeViewController

@synthesize klpImgArr;
@synthesize imgScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
   }
-(void)initUI{
    index = 0;
    //_tittleView.backgroundColor=[UIColor redColor];
    //[_tittleView setBackgroundColor:[UIColor redColor]];
	imgArr= [NSArray arrayWithObjects:@"setting_renti.png",@"setting_renti22.png",nil];
	klpImgArr = [[NSMutableArray alloc] initWithCapacity:2];
    CGSize size = self.imgScroll.frame.size;
    hight=size.height-60;
	for (int i=0; i < [imgArr count]; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(size.width * i, 0, size.width,  hight)];
//        iv.contentMode=UIViewContentModeScaleAspectFit;

        [iv setImage:[UIImage imageNamed:[imgArr objectAtIndex:i]]];
        [self.imgScroll addSubview:iv];
        iv = nil;
      
    }
	self.imgScroll.pagingEnabled = YES;
    self.imgScroll.showsHorizontalScrollIndicator = NO;
    self.imgScroll.showsVerticalScrollIndicator=NO;
    self.imgScroll.delegate=self;
    [self.imgScroll setContentSize:CGSizeMake(size.width * 2,hight-10)];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"百科";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
}



#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	if (scrollView == self.imgScroll) {
		CGFloat pageWidth = scrollView.frame.size.width;
		int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if (page==0) {
            _page.text=@"1/2";
        }else{
            _page.text=@"2/2";
        }
    }
}
@end

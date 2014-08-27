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

- (void)viewDidLoad
{
    [super viewDidLoad];
    index = 0;
//	self.navigationItem.title = @"liping";
	imgArr= [NSArray arrayWithObjects:@"setting_renti.png",@"setting_renti2.png",nil];
	klpImgArr = [[NSMutableArray alloc] initWithCapacity:2];
    CGSize size = self.imgScroll.frame.size;
	for (int i=0; i < [imgArr count]; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(size.width * i, 0, size.width, size.height)];
        [iv setImage:[UIImage imageNamed:[imgArr objectAtIndex:i]]];
        [self.imgScroll addSubview:iv];
        iv = nil;
    }
	[self.imgScroll setContentSize:CGSizeMake(size.width * 2, size.height)];
	
	self.imgScroll.pagingEnabled = YES;
    self.imgScroll.showsHorizontalScrollIndicator = NO;
	
	
	
	
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:2];
    
    [self.imgScroll addGestureRecognizer:singleTap];
    
   
}


#pragma mark-- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{\
	//NSLog(@"scrollViewDidScroll");
	if (scrollView == self.imgScroll) {
		CGFloat pageWidth = scrollView.frame.size.width;
		int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		index = page;
	}else {
		
	}
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //	NSLog(@"scrollViewWillBeginDragging");
	if (scrollView == self.imgScroll) {
		
	}else {
		
	}
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	//NSLog(@"scrollViewDidEndDecelerating");
	if (scrollView == self.imgScroll) {
		klp.frame = ((UIImageView*)[self.klpImgArr objectAtIndex:index]).frame;
		[klp setAlpha:0];
		[UIView animateWithDuration:0.2f animations:^(void){
			[klp setAlpha:.85f];
		}];
//		[self.klpScrollView2 setContentOffset:CGPointMake(klp.frame.origin.x, 0) animated:YES];
	}else {
		
	}
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"百科";
    
    //图片的点击事件
    
    
//    _zhengimage.userInteractionEnabled = YES;
//    UITapGestureRecognizer *gotoExerciseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSecondView:)];
//    [_zhengimage addGestureRecognizer:gotoExerciseTap];
    
    
    
}


#pragma mark 手势
- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer{
	CGFloat pageWith = 320;
    
    CGPoint loc = [gestureRecognizer locationInView:self.imgScroll];
    NSInteger touchIndex = floor(loc.x / pageWith) ;
    if (touchIndex > 1) {
        return;
    }
    NSLog(@"touch index %d",touchIndex);
}
//- (void)gotoSecondView:(id)sender {
//    _ecerciseView= [[ExerciseMainViewController alloc] init];
//    [self.navigationController pushViewController:_ecerciseView animated:YES];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

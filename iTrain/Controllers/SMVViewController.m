//
//  SMVViewController.m
//  iTrain
//
//  Created by Interest on 14-10-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SMVViewController.h"

@interface SMVViewController ()
@property (nonatomic,retain)NSMutableArray *klpImgArr;

@end
NSArray *tittleArray;
NSArray *contentArray;
@implementation SMVViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        tittleArray=@[NSLocalizedString(@"SMiTrainOperation1", nil),NSLocalizedString(@"SMiTrainOperation2", nil),NSLocalizedString(@"SMiTrainOperation3", nil)];
        contentArray =@[NSLocalizedString(@"SMiTrainOperation1Detail", nil),NSLocalizedString(@"SMiTrainOperation2Detail", nil),NSLocalizedString(@"SMiTrainOperation3Detail", nil)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = NSLocalizedString(@"Subtool", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
}
-(void)initUI{
    [_detail setText:NSLocalizedString(@"SMMuscleTrainerOperation1", nil)];
     [_detailTitttle setText:NSLocalizedString(@"SMMuscleTrainerOperation", nil)];
     [_detailTittle2 setText:NSLocalizedString(@"SMiTrainOperation", nil)];
    // CGSize size=_detailView.frame.size;
    self.sView.pagingEnabled = YES;
    self.sView.showsHorizontalScrollIndicator = NO;
    self.sView.showsVerticalScrollIndicator=NO;
    self.sView.delegate=self;
    [self.sView setContentSize:CGSizeMake(320,280*3+380)];

	imgArr= [NSArray arrayWithObjects:@"SMImage2.png",@"SMImage3.png",@"SMImage4.png",nil];
	_klpImgArr = [[NSMutableArray alloc] initWithCapacity:2];
    
  	for (int i=0; i < [imgArr count]; i++) {
        UIView *iview ;//=[[UIView alloc]init];
        NSArray *snibViews=[[NSBundle mainBundle] loadNibNamed:@"ScoolView" owner:self options:nil]; //通过这个方法,取得我们的视图
        iview=[snibViews objectAtIndex:0];
        iview.frame=CGRectMake(0,iview.frame.size.height*i+370, iview.frame.size.width, iview.frame.size.height);
        UIImageView *imageView=[[iview subviews ]objectAtIndex:0 ];
         UILabel *tittle=[[iview subviews ]objectAtIndex:2 ];
         UILabel *content=[[iview subviews ]objectAtIndex:3 ];
        [imageView setImage:[UIImage imageNamed:[imgArr objectAtIndex:i]]];
        [tittle setText:[tittleArray objectAtIndex:i]];
        [content setText:[contentArray objectAtIndex:i]];
        [self.sView addSubview:iview];
        
    }
}
@end



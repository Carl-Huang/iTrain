//
//  ParamSetViewController.m
//  iTrain
//
//  Created by Interest on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ParamSetViewController.h"
#import  "AKPickerView.h"

@interface ParamSetViewController () <AKPickerViewDelegate>
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) AKPickerView *pickerView2;
@property (nonatomic, strong) NSArray *titles;
@end



@implementation ParamSetViewController

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
    self.pickerView = [[AKPickerView alloc] init];
    self.pickerView.frame=CGRectMake(0, 120, 320, 45);
    self.pickerView.delegate = self;
	[self.view addSubview:self.pickerView];
    
	self.titles = @[@"100",
					@"200",
					@"300",
					@"400",
					@"500",
					@"600",
					@"700",
					@"800",
					@"900",
					@"1000"];
    
    self.pickerView2 = [[AKPickerView alloc] init];

    self.pickerView2.frame=CGRectMake(0, 250, 320, 45);
    self.pickerView2.delegate = self;
	[self.view addSubview:self.pickerView2];
    
	[self.pickerView reloadData];
    [self.pickerView2 reloadData];

    //设置按钮按下状态图片
    [_save setImage:[UIImage imageNamed:@"baocun.png"] forState:UIControlStateNormal];
     [_save setImage:[UIImage imageNamed:@"baocun_1.png"] forState:UIControlStateHighlighted];
    
                                                                  
                                                                  
//                                                                  
//    [_save setImage:[UIImage imageNamed:@"baocun"] forState:UIControlStateNormal];
//    
//    [_save addTarget:self action:@selector(selectedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
   }
-(void)selectedBtnPressed:(id)sender{
    
//    [_save setImage:[UIImage imageNamed:@"baocun_1"] forState:UIControlStateNormal];
    
}


- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
	return [self.titles count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
	return self.titles[item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
	NSLog(@"%@", self.titles[item]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

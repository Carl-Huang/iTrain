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
    self.pickerView = [[AKPickerView alloc] initWithFrame:self.view.bounds];
//    self.pickerView.frame=CGRectMake(0, 100, 320, 80);
	self.pickerView.backgroundColor=  [UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_param_bg"]];
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
    
	[self.pickerView reloadData];
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

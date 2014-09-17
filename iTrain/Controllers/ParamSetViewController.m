//
//  ParamSetViewController.m
//  iTrain
//
//  Created by Interest on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ParamSetViewController.h"
#import "AppDelegate.h"

@interface ParamSetViewController () <AKPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *titles2;
@end

NSInteger usIndex;
NSInteger hzIndex;
NSMutableArray *modelArray;
@implementation ParamSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        usIndex=-1;
        hzIndex=-1;
        modelArray=[[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title =NSLocalizedString(@"AdSetting", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerView.delegate = self;
    //	[self.view addSubview:self.pickerView];
    self.titles=[[NSMutableArray alloc]initWithArray:
                 @[@"100",@"200",@"300",@"400",@"500",@"600",@"700"]];
    self.titles2=[[NSMutableArray alloc]initWithArray:
                  @[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80"]];
    self.pickerView2.delegate = self;
	[self.pickerView reloadData];
    [self.pickerView2 reloadData];
    /**
     *先定位到第一个，让数据显示，再定位到要显示的项
     **/
    [self.pickerView selectItem:1 animated:NO];
    [self.pickerView2 selectItem:1 animated:NO];
    [self setModel];
    [self.pickerView selectItem:usIndex animated:NO];
    [self.pickerView2 selectItem:hzIndex animated:NO];
    //设置按钮按下状态图片
    [_save setImage:[UIImage imageNamed:@"baocun.png"] forState:UIControlStateNormal];
    [_save setImage:[UIImage imageNamed:@"baocun_1.png"] forState:UIControlStateHighlighted];
    [_save addTarget:self action:@selector(saveUser) forControlEvents:UIControlEventTouchUpInside];
    [_HzTv setText:NSLocalizedString(@"Hz", nil)];
    [_Pw setText:NSLocalizedString(@"Pulse-Width", nil)];
    [_SettingTv setText:NSLocalizedString(@"Adparameters", nil)];
    [_saveTip setText:NSLocalizedString(@"Save", nil)];
}

/**设置参数**/
- (void)saveUser{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user=app.user;
    [user setUzIndex:[NSNumber numberWithInt:usIndex]];
    [user setHzIndex:[NSNumber numberWithInt:hzIndex]];
    NSError *error=nil;
    [app.managedObjectContext save:&error];
}


/**获取蓝牙连接之后返回的设备模式相关信息，并且初始化显示**/
-(void)setModel{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user=app.user;
    if(user==nil){
        usIndex=0;
        hzIndex=0;
    }else{
        hzIndex=[[user hzIndex] integerValue];
        usIndex=[[user uzIndex] integerValue];
        
    }
}


- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    if(pickerView ==self.pickerView2){
        return [self.titles2 count];
    }
	return [self.titles count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    if(pickerView ==self.pickerView2){
        return self.titles2[item];
    }
	return self.titles[item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    if(pickerView ==self.pickerView2){
        hzIndex=item;
        return;
    }
    usIndex=item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

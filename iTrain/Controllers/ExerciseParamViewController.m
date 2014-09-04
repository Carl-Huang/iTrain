//
//  ExerciseParamViewController.m
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ExerciseParamViewController.h"
#import "CBLEManager.h"
@interface ExerciseParamViewController ()<AKPickerViewDelegate>

//@property (nonatomic, strong) AKPickerView *pickerView;
//@property (nonatomic, strong) AKPickerView *pickerView2;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *titles2;
@end


NSInteger speedIndex;
NSInteger stongIndex;
NSInteger speed;
NSInteger stong;
@implementation ExerciseParamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        for(int i=0;i<91;i++){
            [temp addObject:[NSString stringWithFormat:@"%d",i]];
        }
        self.titles=[[NSArray alloc]initWithArray:temp];
    self.titles2=@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15"];
        speedIndex=-1;
        stongIndex=-1;
        speed=1;
        stong=0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"训练";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerView.delegate = self;
//	[self.view addSubview:self.pickerView];

    self.pickerView2.delegate = self;
//	[self.view addSubview:self.pickerView2];
    
	[self.pickerView reloadData];
    [self.pickerView2 reloadData];
    speed=[(NSNumber*)[_modelArray objectAtIndex:3] integerValue];
    stong=[(NSNumber*)[_modelArray objectAtIndex:4] integerValue];
    speedIndex=[self.titles2 indexOfObject:[NSString stringWithFormat:@"%d",speed]];
    stongIndex=[self.titles indexOfObject:[NSString stringWithFormat:@"%d",stong]];
    [self.pickerView selectItem:1 animated:NO];
    [self.pickerView selectItem:stongIndex animated:NO];
    [self.pickerView2 selectItem:1 animated:NO];
    [self.pickerView2 selectItem:speedIndex animated:NO];
    //设置按钮按下状态图片
//    [_save setImage:[UIImage imageNamed:@"baocun.png"] forState:UIControlStateNormal];
//    [_save setImage:[UIImage imageNamed:@"baocun_1.png"] forState:UIControlStateHighlighted];
    
    
    
    //
    //    [_save setImage:[UIImage imageNamed:@"baocun"] forState:UIControlStateNormal];
    //
    //    [_save addTarget:self action:@selector(selectedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_btn addTarget:self action:@selector(selectedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_btn2 addTarget:self action:@selector(selectedBtn2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [[CBLEManager sharedManager] setSendDataHandler:^(NSString *st){
        if([st isEqualToString:@"01"]){
            [self start];
            [[CBLEManager sharedManager] setSendDataHandler:Nil];
        }
    }];
//    [self changeModel];
   }

/**暂停按钮响应事件**/
-(void)selectedBtnPressed:(id)sender{
    
    NSArray *array=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x05], nil];
    [[CBLEManager sharedManager] createData:array];
    
}

-(void)changeModel{
    if([[CBLEManager sharedManager] isConnected]){
        /**速度是0x01对应第一个，所以提交修改的时候要+1**/
        [_modelArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:speed]];
        [_modelArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:stong]];
        [[CBLEManager sharedManager] createData:_modelArray];
    }
}
/**停止按钮响应事件**/
-(void)selectedBtn2Pressed:(id)sender{
    //[self changeModel];
//return;
    NSArray *array=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x07], nil];
    [[CBLEManager sharedManager] createData:array];
    
}

-(void)start{
    NSArray *array=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x06], nil];
    [[CBLEManager sharedManager] createData:array];
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    if(pickerView==self.pickerView){
        return [self.titles count];
    }
	return [self.titles2 count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    if(pickerView==self.pickerView){
	   return self.titles[item];
    }
    return self.titles2[item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    
	if(pickerView==self.pickerView){
        stong=[self.titles[item] integerValue];
        [self changeModel];
        return;
    }
    speed=[self.titles2[item] integerValue];
    [self changeModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

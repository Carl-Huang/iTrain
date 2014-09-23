//
//  SettingViewController.m
//  iTrain
//
//  Created by Interest on 14-8-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SettingViewController.h"
#import "ParamSetViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    // 初始化tableView的数据
    NSArray *list = [NSArray arrayWithObjects:NSLocalizedString(@"BLEConnect", nil),NSLocalizedString(@"Setting", nil),NSLocalizedString(@"Baike", nil),NSLocalizedString(@"AboutApp", nil) ,nil];
    NSArray *imagelist = [NSArray arrayWithObjects:@"setting_lanya",@"setting_shezhi",@"setting_baike",@"setting_app", nil];
    self.dataList = list;
    self.imageList=imagelist;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain] ;
    // 设置tableView的数据源
    tableView.dataSource = self;
    // 设置tableView的委托
    tableView.delegate = self;
    // 设置tableView的背景图
    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    
    self.myTableView = tableView;
     _myTableView.scrollEnabled = NO;
    [self setExtraCellLineHidden:_myTableView];
    [self.view addSubview:_myTableView];
    
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdenifer = @"SettingViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenifer];
    if (!cell) {
        
        //导航风格
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:cellIdenifer ];
        
        cell.showsReorderControl = YES;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    NSInteger row=[indexPath row];
    
    cell.textLabel.text= [NSString stringWithFormat:@"%@", [_dataList objectAtIndex:row]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [_dataList objectAtIndex:row]];
    [cell.contentView addSubview:cell.textLabel];
    
    cell.imageView.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:[_imageList objectAtIndex:row]] ;
    return cell;
}
//隐藏TabelView下面多余分割线

- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title =NSLocalizedString(@"Setting", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
}

//响应用户单击事件

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        _blueTooth= [[BlueToothViewController alloc] init];
        [self.navigationController pushViewController:_blueTooth
                                             animated:YES];
    }else if(indexPath.row==1){
       _paramSet = [[ParamSetViewController alloc] init];
        [self.navigationController pushViewController:_paramSet
                                             animated:YES];

    }else if(indexPath.row==2){
        //        跳转到百科页面
        if (DEVICE_IS_IPHONE5) {
           _baike= [[BaiKeViewController alloc] initWithNibName:@"BaiKeViewController4" bundle:nil];
        }else {
           _baike= [[BaiKeViewController alloc]initWithNibName:@"BaiKeViewController" bundle:nil];
        }
        [self.navigationController pushViewController:_baike animated:YES];
    }else if(indexPath.row==3){
        _about= [[AboutViewController alloc] init];
        [self.navigationController pushViewController:_about animated:YES];
    }
}





@end

//
//  UserInfoViewController.m
//  iTrain
//
//  Created by Interest on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UserInfoViewController.h"



@implementation UserInfoViewController

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
    NSArray *list = [NSArray arrayWithObjects:@"头像",@"姓名",@"性别",@"年龄",@"身高",@"体重",@"单位", nil];
    NSArray *imagelist = [NSArray arrayWithObjects:@"user_icon",@"user_icon1",@"user_icon2",@"user_icon3",@"user_icon4",@"user_icon5",@"user_icon6", nil];
    self.dataList = list;
    self.imageList=imagelist;
   
    // 设置tableView的数据源
    _myTableView.dataSource = self;
    // 设置tableView的委托
    _myTableView.delegate = self;
    // 设置tableView的背景图
    _myTableView.scrollEnabled=NO;

    [self setExtraCellLineHidden:_myTableView];
//    [self.view addSubview:_myTableView];
  
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdenifer = @"UserInfoViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenifer];
    if (!cell) {
        //导航风格
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdenifer ];
      
        cell.showsReorderControl = YES;
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    NSInteger row=[indexPath row];

    //xy wh
    UITextField *edit=[[UITextField alloc]initWithFrame:CGRectMake(240,12,70,40)];
    [cell addSubview:edit];
    if (row==0) {
        [edit setHidden:YES];
    }else{
          [edit setHidden:NO];
    }
    
    cell.textLabel.text= [NSString stringWithFormat:@"%@", [_dataList objectAtIndex:row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [_dataList objectAtIndex:row]];
    [cell.contentView addSubview:cell.textLabel];
    
    cell.imageView.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:[_imageList objectAtIndex:row]] ;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==0) {
        return 70;
    }
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
   
    return cell.frame.size.height;
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
    self.title = @"个人信息";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end

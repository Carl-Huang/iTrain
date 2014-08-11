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
    NSArray *list = [NSArray arrayWithObjects:@"武汉",@"上海",@"北京",@"深圳",@"广州",@"重庆", nil];
    NSArray *imagelist = [NSArray arrayWithObjects:@"user_icon1",@"user_icon2",@"user_icon3",@"user_icon4",@"user_icon5",@"user_icon6", nil];
    self.dataList = list;
    self.imageList=imagelist;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped] ;
    // 设置tableView的数据源
    tableView.dataSource = self;
    // 设置tableView的委托
    tableView.delegate = self;
    // 设置tableView的背景图
    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    self.myTableView = tableView;
    [self.view addSubview:_myTableView];
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdenifer = @"UserInfoViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenifer];
    if (!cell) {
        
        //导航风格
        cell.accessoryType = UITableViewStyleGrouped;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdenifer ];
      
        cell.showsReorderControl = YES;
    }
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






- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
    
        [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
        
        [self.navigationController.navigationBar setTranslucent:NO];
        
//    }
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

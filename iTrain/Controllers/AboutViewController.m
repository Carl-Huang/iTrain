//
//  AboutViewController.m
//  iTrain
//
//  Created by Interest on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    NSArray *list = [NSArray arrayWithObjects:@"给我评分",@"功能介绍",@"系统通知",@"帮助与反馈", nil];

    self.dataList = list;
    // 设置tableView的数据源
    self.seTabelView.dataSource = self;
    // 设置tableView的委托
    self.seTabelView.delegate = self;
//    设置不允许滑动
    _seTabelView.scrollEnabled = NO;
  

}


//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdenifer = @"AboutViewController";
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
    return cell;
}
//隐藏TabelView下面多余分割线

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//



//响应用户单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==0) {
        
    }else if(indexPath.row==1){
    }else if(indexPath.row==2){
        //        跳转到百科页面
//        _baike= [[BaiKeViewController alloc] init];
//        [self.navigationController pushViewController:_baike animated:YES];
    }else if(indexPath.row==3){
        
    }
    
}




@end

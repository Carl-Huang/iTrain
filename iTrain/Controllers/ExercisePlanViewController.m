//
//  ExercisePlanViewController.m
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ExercisePlanViewController.h"
//训练计划
@interface ExercisePlanViewController ()

@end
UIColor *bg;
@implementation ExercisePlanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化tableView的数据
    NSArray *list = [NSArray arrayWithObjects:@"蓝牙连接",@"高级设置",@"百科",@"关于APP功能选择", nil];
    //    NSArray *imagelist = [NSArray arrayWithObjects:@"setting_lanya",@"setting_shezhi",@"setting_baike",@"setting_app", nil];
    //self.dataList = list;
    //    self.imageList=imagelist;
    
    // 设置tableView的数据源
    self.tabelView.dataSource = self;
    // 设置tableView的委托
    self.tabelView.delegate = self;
    // 设置tableView的背景图
    bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor=bg;
    self.tabelView.backgroundColor=bg;
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //    self.userTabelView = tableView;
    //    禁止滑动
    //    _userTabelView.scrollEnabled = NO;
    
    [self setExtraCellLineHidden: self.tabelView];
    [self.view addSubview: self.tabelView];
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *CustomCellIdentifier = @"Cell";
    scell = [tableView dequeueReusableCellWithIdentifier:@"ExercisePlanCell"];
    if(!scell) {
        scell = [[[NSBundle mainBundle] loadNibNamed:@"ExercisePlanCell" owner:self options:nil]lastObject];
    }
    int row=[indexPath row];
    if (row%2) {
        scell.contentView.backgroundColor=[UIColor clearColor];
    }else{
        scell.contentView.backgroundColor=[UIColor whiteColor];
    }

    //    禁止选中效果
    scell.num.text=@"1";
    scell.num.layer.borderColor  = [UIColor darkGrayColor].CGColor;
    scell.num.layer.cornerRadius = 12.0f;
    scell.name.text=@"手臂";
    scell.time.text=@"13:30";
    scell.timeLong.text=@"30min";
    
//    scell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return scell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

////隐藏TabelView下面多余分割线

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
    //    self.navigationItem.title = @"设置";
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
        //        _about= [[AboutViewController alloc] init];
        //        [self.navigationController pushViewController:_about animated:YES];
        
    }
    
}


@end

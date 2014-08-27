//
//  ExerciseRecordViewController.m
//  iTrain
//
//  Created by Interest on 14-8-23.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ExerciseRecordViewController.h"

@interface ExerciseRecordViewController ()

@end
UIColor *bg;
@implementation ExerciseRecordViewController

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
    NSArray *list = [NSArray arrayWithObjects:@"6月10日",@"6月10日",@"6月10日",@"6月10日", nil];
    NSArray *imagelist = [NSArray arrayWithObjects:@"2013",@"2013",@"2013",@"2014", nil];
    NSArray *time = [NSArray arrayWithObjects:@"35min",@"35min",@"35min",@"35min", nil];
    
    NSArray *name = [NSArray arrayWithObjects:@"腿部",@"腿部",@"腿部",@"腿部", nil];
    self.dateList = list;
    self.imageList=imagelist;
    self.timeList=time;
  self.nameList=name;
    
    // 设置tableView的数据源
    _tabelView.dataSource = self;
    // 设置tableView的委托
    self.tabelView.delegate = self;
    // 设置tableView的背景图
    bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor=bg;
    self.tabelView.backgroundColor=bg;
//    设置分割线
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //    self.userTabelView = tableView;
    //    禁止滑动
    //    _userTabelView.scrollEnabled = NO;
    
    [self setExtraCellLineHidden:self.tabelView];
    //    [self.view addSubview:self.tabelView];
    
    //设置按钮按下状态图片
    [_delBtn setImage:[UIImage imageNamed:@"record_shanchujilu_01.png"] forState:UIControlStateNormal];
    [_delBtn setImage:[UIImage imageNamed:@"record_shanchujilu.png"] forState:UIControlStateHighlighted];
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *CustomCellIdentifier = @"Cell";
    
    scell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseRecordCell"];
    if(!scell) {
        scell = [[[NSBundle mainBundle] loadNibNamed:@"ExerciseRecordCell" owner:self options:nil]lastObject];
    }
    int row=[indexPath row];
    scell.year.text = [_imageList objectAtIndex:row];
    scell.name.text =[_nameList objectAtIndex:row];
    scell.time.text=[_timeList objectAtIndex:row];
    scell.date.text=[_dateList objectAtIndex:row];
    scell.accessoryType=UITableViewCellSeparatorStyleSingleLine;
    //    cell.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ul_ti"]];
    //    cell.divline.backgroundColor=bg;
    //    //    禁止选中效果
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

//响应用户单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==0) {
        _detail=[[ExerciseRecordDetailViewController alloc]init];
        [self.navigationController pushViewController:_detail animated:YES];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
     self.title =@"训练";
    
}
@end

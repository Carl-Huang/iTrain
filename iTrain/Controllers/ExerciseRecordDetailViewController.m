//
//  ExerciseRecordDetailViewController.m
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ExerciseRecordDetailViewController.h"
@interface ExerciseRecordDetailViewController ()

@end
UIColor *bg;
@implementation ExerciseRecordDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
  
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *CustomCellIdentifier = @"Cell";
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
    
    cell.textLabel.text= [NSString stringWithFormat:@"%@", [self.dateList objectAtIndex:row]];
    cell.selectionStyle = UITableViewCellStyleValue1;//  SelectionStyleNone;
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [_dataList objectAtIndex:row]];
    [cell.contentView addSubview:cell.textLabel];
    cell.detailTextLabel.text=@"sdasd";
    cell.imageView.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:[_imageList objectAtIndex:row]] ;
    
    
    return cell;
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
    
    
//    if (indexPath.row==0) {
//        _detail=[[ExerciseRecordDetailViewController alloc]init];
//        [self.navigationController pushViewController:_detail animated:YES];
//    }else if(indexPath.row==1){
//    }else if(indexPath.row==2){
//        //        跳转到百科页面
//        //        _baike= [[BaiKeViewController alloc] init];
//        //        [self.navigationController pushViewController:_baike animated:YES];
//    }else if(indexPath.row==3){
//        //        _about= [[AboutViewController alloc] init];
//        //        [self.navigationController pushViewController:_about animated:YES];
//        
//    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"详细记录";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [self setRightCustomBarItem:@"detail_fenxiang.png" action:@selector(showShare)];
}
-(void)showShare{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容

    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

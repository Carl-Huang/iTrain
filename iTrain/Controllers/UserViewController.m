//
//  UserViewController.m
//  iTrain
//
//  Created by Interest on 14-8-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController (){
    UserViewController* sview;
}
@property (nonatomic, readonly) UIButton *m_btnNaviRight;


@end
UIColor *bg;
@implementation UserViewController

@synthesize m_btnNaviRight = _btnNaviRight;
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
    NSArray *list = [NSArray arrayWithObjects:@"蓝牙连接",@"高级设置",@"百科",@"关于APP功能选择", nil];
//    NSArray *imagelist = [NSArray arrayWithObjects:@"setting_lanya",@"setting_shezhi",@"setting_baike",@"setting_app", nil];
    self.dataList = list;
//    self.imageList=imagelist;

    // 设置tableView的数据源
    _userTabelView.dataSource = self;
    // 设置tableView的委托
    _userTabelView.delegate = self;
    // 设置tableView的背景图
    bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor=bg;
    _userTabelView.backgroundColor=bg;
    _userTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.userTabelView = tableView;
//    禁止滑动
//    _userTabelView.scrollEnabled = NO;
    
    [self setExtraCellLineHidden:_userTabelView];
//    [self.view addSubview:_userTabelView];
    
    //设置按钮按下状态图片
    [_addBtn setImage:[UIImage imageNamed:@"ul_xinjian.png"] forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"ul_xinjian2.png"] forState:UIControlStateHighlighted];
    sview=self;

    
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CustomCellIdentifier = @"Cell";
    
    UserCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCollectionViewCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserCollectionViewCell" owner:self options:nil]lastObject];
    }
    cell.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ul_ti"]];
    cell.divline.backgroundColor=bg;
//    禁止选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    //设置按钮按下状态图片
//    [scell.select setImage:[UIImage imageNamed:@"ul_gou.png"] forState:UIControlStateNormal];
//    [scell.select setImage:[UIImage imageNamed:@"ul_gou2.png"] forState:UIControlStateHighlighted];
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //    self.navigationItem.title = @"设置";

    
    // 创建一个自定义的按钮，并添加到导航条右侧。
//    _btnNaviRight = [CustomNaviBarView createNormalNaviBarBtnByTitle:@"Next" target:self action:@selector(btnNext:)];
//    [self setLeftCustomBarItem:@"ul_kuang.png" action:@selector(gotoSecondView:)];
    
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [self setRightCustomBarItem:@"ul_kuang.png" action:@selector(gotoSecondView:)];
    //self

}

- (void)gotoSecondView:(id)sender  {

    NSLog(@"点击我了");
}
- (IBAction)popoverBtnClicked:(id)sender forEvent:(UIEvent *)event {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    NSSet *set = event.allTouches;
    UITouch *touch = [set anyObject];
    CGPoint point1 = [touch locationInView:window];
    //    CGPoint point = sender.center;
//    [KWPopoverView showPopoverAtPoint:point1 inView:self.view withContentView:_contentView];
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

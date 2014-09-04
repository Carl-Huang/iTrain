//
//  UserViewController.m
//  iTrain
//
//  Created by Interest on 14-8-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UserViewController.h"
#import "KWPopoverView.h"
#import "NewUserViewController.h"
#import "UserInfoViewController.h"

@interface UserViewController (){
    UserViewController* sview;
    NewUserViewController *newUser;
    UserInfoViewController *UserInfo;
}
@property (nonatomic, readonly) UIButton *m_btnNaviRight;
//@property (nonatomic, readonly)UIImageView *mimageview;

@end
UIColor *bg;
@implementation UserViewController
NSString   *currentName;
NSString   *currentImg;
NSString   *currentAge;
NSString   *currentUser;
NSInteger _index;
@synthesize m_btnNaviRight = _btnNaviRight;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _index=-1;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI{
    _contentView.hidden = YES;
    // 初始化tableView的数据
    NSArray *list = [NSArray arrayWithObjects:@"蓝牙连接",@"高级设置",@"百科",@"关于APP功能选择", nil];
    NSArray *namelist = [NSArray arrayWithObjects:@"详情",@"删除", nil];
    NSArray *imagelist = [NSArray arrayWithObjects:@"user_xiangqing@2x.png",@"user_shanchu@2x.png", nil];
    self.dataList = list;
    self.contentImageList=imagelist;
    self.contentNameList=namelist;
    // 设置tableView的数据源
    _userTabelView.dataSource = self;
    // 设置tableView的委托
    _userTabelView.delegate = self;
    // 设置tableView的背景图
    // 设置tableView的数据源
    _contetTabelView.dataSource = self;
    // 设置tableView的委托
    _contetTabelView.delegate = self;
    // 设置tableView的背景图
    
    bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor=bg;
    _userTabelView.backgroundColor=bg;
    _userTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contetTabelView.backgroundColor=bg;
    _contetTabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine
    ;
    //    禁止滑动
    _contetTabelView.scrollEnabled = NO;
    _contetTabelView.tableHeaderView=_contentCell;
    [self setExtraCellLineHidden:_userTabelView];
    
    //设置按钮按下状态图片
    [_addBtn setImage:[UIImage imageNamed:@"ul_xinjian.png"] forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"ul_xinjian2.png"] forState:UIControlStateHighlighted];
    sview=self;
    [_addBtn addTarget:self action:@selector(addPage)forControlEvents:UIControlEventTouchUpInside];
    
    
}

//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_userTabelView) {
        return 3;
    }else{
        return _contentImageList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView ==_userTabelView){
        UserCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCollectionViewCell"];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserCollectionViewCell" owner:self options:nil]lastObject];
        }
        if(_index!=-1&&_index==indexPath.row){
            
            [cell.select setImage:[UIImage imageNamed:@"ul_gou2.png"] forState:UIControlStateHighlighted];
        }else{
            [cell.select setImage:[UIImage imageNamed:@"ul_gou.png"] forState:UIControlStateNormal];
        }
        cell.divline.backgroundColor=bg;
        //    禁止选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.select setTag:indexPath.row];
        [cell.select addTarget:self action:@selector(selectClicked:forEvent:)forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor=[UIColor clearColor];
        cell.sview.layer.masksToBounds = YES;
        cell.sview.layer.cornerRadius = 6.0;
        cell.sview.layer.borderWidth = 0.1;
        cell.sview.layer.borderColor = [[UIColor grayColor] CGColor];
        return cell;
    }else{
        static NSString *cellIdenifer = @"SettingViewController";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenifer];
        if (!cell) {
            //导航风格
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdenifer ];
            
            cell.showsReorderControl = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger row=[indexPath row];
        bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        
        UIView *cellView ;//=[[UIView alloc]init];
        NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:@"UserSettingCell" owner:self options:nil]; //通过这个方法,取得我们的视图
        cellView=[nibViews objectAtIndex:0];
        cellView.userInteractionEnabled = YES;
        
        UILabel *textLabel=[[cellView subviews] objectAtIndex:0];
        textLabel.text=[NSString stringWithFormat:@"%@", [_contentNameList objectAtIndex:row]];
        UIImageView *iconImage=[[cellView subviews] objectAtIndex:1];
        iconImage.image=[UIImage imageNamed:[_contentImageList objectAtIndex:row]];
        //
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            _contentUserLine.hidden=NO;
        }else {
            _contentUserLine.hidden=YES;
        }
        [cell setTag:row];
        
        [cell addSubview:cellView];
        cell.backgroundColor=bg;
        return cell;
    }
    
    
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
    self.title = @"用户列表";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [self setRightCustomBarItem:@"ul_kuang.png" action:@selector(popoverBtnClicked:forEvent:)];
}
//跳转到新建用户页面
-(void)addPage{
    newUser= [[NewUserViewController alloc] init];
    [self.navigationController pushViewController:newUser animated:YES];
    
}

- (void)selectClicked:(id)sender forEvent:(UIEvent *)event{
    UIButton *btn=sender;
    if(_index==btn.tag){
        _index=-1;
    }else{
        _index=btn.tag;
    }
    [_userTabelView reloadData];
    
}
- (void)popoverBtnClicked:(id)sender forEvent:(UIEvent *)event {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    //    _contentView =[[UIView alloc]init];
    NSSet *set = event.allTouches;
    UITouch *touch = [set anyObject];
    //未显示之前停留的位置
    
    CGPoint point1 = [touch locationInView:window];
    [KWPopoverView showPopoverAtPoint:point1 inView:_contentView withContentView:_contentView];
}
//响应用户单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_contetTabelView) {
        if (indexPath.row==0) {
//            详情
        userinfoController= [[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:userinfoController animated:YES];

//            删除
        }else if(indexPath.row==1){
            //        _about= [[AboutViewController alloc] init];
            //        [self.navigationController pushViewController:_about animated:YES];
        }
        [KWPopoverView Dismiss];
    }else {
        
        NSLog(@"qqq1");
    }
    
    
}


@end

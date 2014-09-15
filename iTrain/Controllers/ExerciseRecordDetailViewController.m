
//
//  ExerciseRecordDetailViewController.m
//  iTrain
//
//  Created by Interest on 14-8-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ExerciseRecordDetailViewController.h"
#import "KWPopoverView.h"
#import "ExerciseParamViewController.h"
#include <QuartzCore/QuartzCore.h>
#define ANIMATE_DURATION                        0.25f
@interface ExerciseRecordDetailViewController ()

@end
UIColor *bg;
BOOL isFirst;
@implementation ExerciseRecordDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isFirst=true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI{
    // 初始化tableView的数据
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
    
    [self setExtraCellLineHidden:self.tabelView];
    _popView.hidden=YES;
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    //    UITextField *edit=[[UITextField alloc]initWithFrame:CGRectMake(240,12,70,40)];
    //    [cell addSubview:edit];
    //    if (row==0) {
    //        [edit setHidden:YES];
    //    }else{
    //        [edit setHidden:NO];
    //    }
    NSString *st;
    NSString *st1;
    if(row==0){
        st=@"训练部位";
        st1=[_record part];
    }else if(row==1){
        st=@"开始训练时间";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *destDateString = [dateFormatter stringFromDate:[_record starttime]];
        st1=destDateString;
    }else{
        st=@"训练总时长";
        st1=[[NSString stringWithFormat:@"%d",[[_record time] integerValue]] stringByAppendingString:@"min"];
    }
    cell.textLabel.text= st;
    cell.selectionStyle = UITableViewCellStyleValue1;//  SelectionStyleNone;
    [cell.contentView addSubview:cell.textLabel];
    cell.detailTextLabel.text=st1;
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //蓝色
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
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
    self.title = @"详细记录";
    [self setLeftCustomBarItem:@"ul_back.png" action:@selector(back)];
    [self setRightCustomBarItem:@"detail_fenxiang.png" action:@selector(popoverBtnClicked:forEvent:)];
    [KWPopoverView ReShow];
    [self initData];
    [_tabelView reloadData];
}

-(void)initData{
    [_yearLabel setText:[_record year]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    NSString *destDateString = [dateFormatter stringFromDate:[_record date]];
    
    [_dateLabel setText:destDateString];
    [dateFormatter setDateFormat:@"HH:mm"];
    destDateString=[dateFormatter stringFromDate:[_record starttime]];
    [_timeLabel setText:destDateString];
    NSString *st;
    if ([[_record weekday] isEqual:@"1"]) {
        st=@"周日";
    }else  if ([[_record weekday] isEqual:@"2"]){
        st=@"周一";
    }else  if ([[_record weekday] isEqual:@"3"]){
        st=@"周二";
    }else  if ([[_record weekday] isEqual:@"4"]){
        st=@"周三";
    }else  if ([[_record weekday] isEqual:@"5"]){
        st=@"周四";
    }else  if ([[_record weekday] isEqual:@"6"]){
        st=@"周五";
    }else  if ([[_record weekday] isEqual:@"7"]){
        st=@"周六";
    }
    NSLog(@"%@,%@",[_record weekday],st);
    [_weekLabel setText:st];
}

- (void)popoverBtnClicked:(id)sender forEvent:(UIEvent *)event {
    if(isFirst){
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self.view addGestureRecognizer:tapGesture];
        [_popView setFrame:CGRectMake(0, [ UIScreen mainScreen ].bounds.size.height-_popView.frame.size.height, _popView.frame.size.width, _popView.frame.size.height)];
        [_popCancel addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchDown];
        /**分享相应
         **/
        UITapGestureRecognizer *wxtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wxTapped)];
        UITapGestureRecognizer *fbtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fbTapped)];
        [_popWx addGestureRecognizer:wxtapGesture];
        [_popFb addGestureRecognizer:fbtapGesture];
        [_popFb setUserInteractionEnabled:YES];
        [_popWx setUserInteractionEnabled:YES];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:_popView];
    }
    [_popView setHidden:NO];
    [_popView setAlpha:1];
}

-(void)wxTapped{
    [self tappedCancel];
    NSString *content=[NSString stringWithFormat:@"我今天做了%@部位的训练%d分钟",[_record part],[[_record time] integerValue]];
    [self showShare:content ShareType:ShareTypeWeixiSession ImagePath:nil];
}

-(void)fbTapped{
    [self tappedCancel];
    NSString *content=[NSString stringWithFormat:@"我今天做了%@部位的训练%d分钟",[_record part],[[_record time] integerValue]];
    [self showShare:content ShareType:ShareTypeFacebook ImagePath:nil];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        _popView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_popView setHidden:YES];
        }
    }];
}

-(void)back{
    [_popView setHidden:YES];
    [_popView removeFromSuperview];
    NSArray *array=self.navigationController.viewControllers;
    if([[array objectAtIndex:(array.count-2)] isKindOfClass:[ExerciseParamViewController class]]){
        UIViewController *vc=( UIViewController *)[array objectAtIndex:(array.count-3)];
        [self.navigationController popToViewController:vc animated:YES];
    }else{
       [self.navigationController popViewControllerAnimated:YES];
    }
    
}
/**
 *分享调用的函数
 *content为分享的内容
 *type为分享的类型
 *path为分享他的图片地址
 **/
-(void)showShare:(NSString *)content ShareType:(NSInteger)type ImagePath:(NSString *)path{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [screenWindow.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   NSData *imageViewData = UIImageJPEGRepresentation(image, 1);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"share1.jpg"];
    // 将图片写入文件
    [imageViewData writeToFile:fullPath atomically:NO];
    
    
    //构造分享内容
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:fullPath]
                                                title:@"XFT—iTrain"
                                                  url:@"http://www.xft.cn/cn/home/index.php"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:content
                                           title:@"XFT—iTrain"
                                             url:@"http://www.xft.cn/cn/home/index.php"
                                      thumbImage:[ShareSDK imageWithPath:fullPath]
                                           image:[ShareSDK imageWithPath:path]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    [publishContent addFacebookWithContent:content image:[ShareSDK imageWithPath:fullPath]];
    [ShareSDK shareContent:publishContent type:type authOptions:nil shareOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
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


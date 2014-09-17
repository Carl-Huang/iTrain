
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
NSArray *parts;
NSArray *weekDays;
@implementation ExerciseRecordDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isFirst=true;
        parts=@[NSLocalizedString(@"Arm", nil),NSLocalizedString(@"Chest", nil),NSLocalizedString(@"Belly", nil),NSLocalizedString(@"Back", nil),NSLocalizedString(@"Buttocks", nil),NSLocalizedString(@"Thigh", nil)];
        weekDays=@[NSLocalizedString(@"Sunday", nil),NSLocalizedString(@"Monday", nil),NSLocalizedString(@"Tuesday", nil),NSLocalizedString(@"Wednesday", nil),NSLocalizedString(@"Thursday", nil),NSLocalizedString(@"Friday", nil),NSLocalizedString(@"Saturday",nil)];
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
    [_shareTitle setText:NSLocalizedString(@"ShareTitle", nil)];
    [_wxTv setText:NSLocalizedString(@"WxFriend", nil)];

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
    NSString *st;
    NSString *st1;
    if(row==0){
        st=NSLocalizedString(@"TrainPart", nil);
        st1=[parts objectAtIndex:[[_record part] integerValue]];
    }else if(row==1){
        st=NSLocalizedString(@"StartTrainTime", nil);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *destDateString = [dateFormatter stringFromDate:[_record starttime]];
        st1=destDateString;
    }else{
        st=NSLocalizedString(@"TotalTrainTime", nil);
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
    self.title =NSLocalizedString(@"RecordDetail", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:@selector(back)];
    [self setRightCustomBarItem:@"detail_fenxiang.png" action:@selector(popoverBtnClicked:forEvent:)];
    [KWPopoverView ReShow];
    [self initData];
    [_tabelView reloadData];
}

-(void)initData{
    [_yearLabel setText:[_record year]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLog(NSLocalizedString(@"RecordDetailFormat", nil));
    [dateFormatter setDateFormat:NSLocalizedString(@"RecordDetailFormat", nil)];
    
    NSString *destDateString = [dateFormatter stringFromDate:[_record date]];
    
    [_dateLabel setText:destDateString];
    [dateFormatter setDateFormat:@"HH:mm"];
    destDateString=[dateFormatter stringFromDate:[_record starttime]];
    [_timeLabel setText:destDateString];
    NSString *st;
    NSInteger weekIndex=[[_record weekday] integerValue]-1;
    st=[weekDays objectAtIndex:weekIndex];
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
    
    NSString *content=[NSString stringWithFormat:NSLocalizedString(@"ShareContent", nil),[parts objectAtIndex:[[_record part] integerValue]],[[_record time] integerValue]];
    [self showShare:content ShareType:ShareTypeWeixiSession ImagePath:nil];
}

-(void)fbTapped{
    [self tappedCancel];
    NSString *content=[NSString stringWithFormat:NSLocalizedString(@"ShareContent", nil),[parts objectAtIndex:[[_record part] integerValue]],[[_record time] integerValue]];
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


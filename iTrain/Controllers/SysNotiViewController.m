//
//  SysNotiViewController.m
//  iTrain
//
//  Created by Interest on 14-8-18.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SysNotiViewController.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "RTLabel.h"
#import "SyTableViewCell.h"

@interface SysNotiViewController ()<LoadingDelegate>

@end

NSInteger second;
NSInteger page;
@implementation SysNotiViewController
CGFloat cellHeight;
UIView *headView;

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
    second=-1;
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.view addSubview:self.tv];
    //    [self setExtraCellLineHidden:self.tv];
    
    child_array= [[NSMutableArray alloc]init];
    father_array= [[NSMutableArray alloc]init];
    //    UINib * nib = [UINib nibWithNibName:@"HelpChildCell" bundle:[NSBundle bundleForClass:[HelpChildCell class]]];
    //    [_tv registerNib:nib forCellReuseIdentifier:@"Cell"];
    UIColor *bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor=bg;
    _tv.backgroundColor=bg;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    page=1;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = NSLocalizedString(@"Notification", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    if(![OSHelper iOS7]){
         _tv.frame=self.view.frame;
    }
   
    NSLog(@"%f",_tv.frame.size.height);
    [self initData];
}

- (void)tapSetion:(UIGestureRecognizer *)sender
{
    UIView * view = sender.view;
    if(second!=view.tag){
        second = view.tag;
    }else{
        second = -1;
    }
    
    [self.tv reloadData];
}

-(void)initData{
    NSDictionary *dic=[[NSDictionary alloc]initWithObjects:@[@"10",[NSNumber numberWithInt:page]] forKeys:@[@"pageSize",@"pageNum"]];
    [SVProgressHUD show];
    [[HttpService sharedInstance] news:dic completionBlock:^(id object) {
        NSDictionary *dic=object;
        if([[dic valueForKey:@"success"] boolValue]){
            [SVProgressHUD dismissWithSuccess:NSLocalizedString(@"HttpSu", nil)];
            NSArray *tArray=[dic valueForKey:@"rows"];
            for(int i=0;i<tArray.count;i++){
                NSDictionary *tDic=[tArray objectAtIndex:i];
                [father_array addObject:[tDic valueForKey:@"title"]];
                [child_array addObject:[tDic valueForKey:@"context"]];
            }
            for(int i=0;i<tArray.count;i++){
                NSDictionary *tDic=[tArray objectAtIndex:i];
                [father_array addObject:[tDic valueForKey:@"title"]];
                [child_array addObject:[tDic valueForKey:@"context"]];
            }
            [_tv reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"HttpFaile", nil) duration:2];
        }
        
        
    } failureBlock:^(NSError *error, NSString *reponseString) {
        [SVProgressHUD dismissWithError:NSLocalizedString(@"HttpErroe", nil)];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [father_array count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView ;//=[[UIView alloc]init];
    NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:@"HelpHeadView" owner:self options:nil]; //通过这个方法,取得我们的视图
    headView=[nibViews objectAtIndex:0];
    headView.userInteractionEnabled = YES;
    
    headView.tag = section;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSetion:)];
    [headView addGestureRecognizer:tap];
    UIFont *font = [UIFont systemFontOfSize:15];
    UILabel *textLabel=[[headView subviews] objectAtIndex:0];
    textLabel.font=font;
    textLabel.text=[father_array objectAtIndex:section];
    UIImageView *imageView=[[headView subviews] objectAtIndex:2];
    if(section==second){
        imageView.image=[UIImage imageNamed:@"notify_click.png"];
    }else{
        imageView.image=[UIImage imageNamed:@"notify_default.png"];
    }
    return headView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==second){
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
//隐藏TabelView下面多余分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *sview = [[UIView alloc]init];
    sview.backgroundColor = [UIColor blackColor];
    
    [tableView setTableFooterView:sview];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

// 设置cell高度和uiLabel高度自适应
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    // 該行要顯示的內容
    SyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell settDelagate:self];
    }
    UIColor *bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    cell.backgroundColor=bg;
    
    [cell.rtLabel setBackgroundColor:bg];
    [cell.rtLabel setOpaque:NO];
    NSString *HTMLData =[child_array objectAtIndex:indexPath.section];
    NSLog(@"%@",HTMLData);
    [cell.rtLabel loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];

    // 設置顯示字體(一定要和之前計算時使用字體一至)
    return cell;
}

-(void)WebViewHeight:(CGFloat)height{
    if(cellHeight==height){
        return;
    }
    cellHeight=height;
    [_tv reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

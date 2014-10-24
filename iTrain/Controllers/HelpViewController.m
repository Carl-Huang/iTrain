//
//  HelpViewController.m
//  iTrain
//
//  Created by Interest on 14-8-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "HelpViewController.h"
#import "UserCollectionViewCell.h"

@interface HelpViewController ()

@end

NSInteger second=-1;

@implementation HelpViewController
UIView *headView;


- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
    
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title =NSLocalizedString(@"Feedback", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [self setRightCustomBarItems:_suggestView];
    //    [ _suggestBtn addTarget:self action:@selector(gotoSuggestView) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.view addSubview:self.tv];
    [self setExtraCellLineHidden:self.tv];
    
    father_array= [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"HelpQ1", nil), NSLocalizedString(@"HelpQ2", nil),NSLocalizedString(@"HelpQ3", nil),NSLocalizedString(@"HelpQ4", nil),NSLocalizedString(@"HelpQ5", nil),NSLocalizedString(@"HelpQ6", nil),NSLocalizedString(@"HelpQ7", nil),NSLocalizedString(@"HelpQ8" ,nil),nil];
    child_array= [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"HelpR1", nil),NSLocalizedString(@"HelpR2", nil),NSLocalizedString(@"HelpR3", nil),NSLocalizedString(@"HelpR4", nil),NSLocalizedString(@"HelpR5", nil),NSLocalizedString(@"HelpR6", nil),NSLocalizedString(@"HelpR7",nil),NSLocalizedString(@"HelpR8" ,nil), nil];
    //    UINib * nib = [UINib nibWithNibName:@"HelpChildCell" bundle:[NSBundle bundleForClass:[HelpChildCell class]]];
    //    [_tv registerNib:nib forCellReuseIdentifier:@"Cell"];
    UIColor *bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    _tv.backgroundColor=bg;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_suggestBtn addTarget:self action:@selector(gotoSuggestView)forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoSuggestView)];
    [_suggestView addGestureRecognizer:tap];
    [_SendTv setText:NSLocalizedString(@"FeedbackSend", nil)];
    [_TitleTv setText:NSLocalizedString(@"FAQ", nil)];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [father_array count];
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
    UIImageView *imageView=[[headView subviews] objectAtIndex:2];
    //    textLabel.numberOfLines=3;
    //    CGRect frame=textLabel.frame;
    
    // 列寬
    CGFloat contentWidth = 252;
    // 用何種字體進行顯示
    // 該行要顯示的內容
    NSString *content = [father_array objectAtIndex:section];
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    // 構建顯示行
    
    CGRect rect = [textLabel textRectForBounds:textLabel.frame limitedToNumberOfLines:0];
    // 設置顯示榘形大小
    rect.size = size;
    // 重置列文本區域
    
    textLabel.frame= rect;
    textLabel.text = content;
    // 設置自動換行(重要)
    textLabel.numberOfLines = 0;
    // 設置顯示字體(一定要和之前計算時使用字體一至)
    textLabel.font = font;
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
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:15];
    // 該行要顯示的內容
    NSString *content = [father_array objectAtIndex:section];
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(252, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"%f",size.height);
    return size.height+21;
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
-(void)gotoSuggestView{
    suggView= [[SuggestViewController alloc] init];
    [self.navigationController pushViewController:suggView
                                         animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 列寬
    CGFloat contentWidth = self.tv.frame.size.width;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:13];
    // 該行要顯示的內容
    NSString *content = [child_array objectAtIndex:indexPath.section];
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    if ([HelpViewController getPreferredLanguage]) {
        if (indexPath.section==1||indexPath.section==4||indexPath.section==5) {
            // 這裏返回需要的高度
            return size.height+40;
        }
    }
    if (indexPath.section==2) {
        return size.height+40;
        
    }else{
        return size.height+20;}
}

// 设置cell高度和uiLabel高度自适应
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    // 列寬
    CGFloat contentWidth = self.tv.frame.size.width;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:13];
    // 該行要顯示的內容
    NSString *content = [child_array objectAtIndex:indexPath.section];
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"%f",size.height);
    // 構建顯示行
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CGRect rect = [cell.textLabel textRectForBounds:cell.textLabel.frame limitedToNumberOfLines:0];
    UIColor *bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    cell.backgroundColor=bg;
    //[cell.textLabel setBackgroundColor:[UIColor blackColor]];
    // 設置顯示榘形大小
    rect.size = size;
    // 重置列文本區域
    cell.textLabel.frame= rect;
    cell.textLabel.text = content;
    // 設置自動換行(重要)
    cell.textLabel.numberOfLines = 0;
    // 設置顯示字體(一定要和之前計算時使用字體一至)
    cell.textLabel.font = font;
    return cell;
}

+ (BOOL)getPreferredLanguage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    NSLog(@"当前语言:%@", preferredLang);
    if([preferredLang isEqualToString:@"en"]){
        return YES;
    }
    return NO;
    
}
@end

//
//  SysNotiViewController.m
//  iTrain
//
//  Created by Interest on 14-8-18.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SysNotiViewController.h"

@interface SysNotiViewController ()

@end

NSInteger second;
@implementation SysNotiViewController

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
    
    child_array= [[NSMutableArray alloc]initWithObjects:@"答： 可以绝对可以。本产品年龄无关适用于任何年龄阶段的人，但是老人与小孩应该在成人监护下使用，脉宽强度也要调小一点。",@"答： 可以绝对可以。本产品年龄无关适用于任何年龄阶段的人，但是老人与小孩应该在成人监护下使用，脉宽强度也要调小一点。",@"答： 可以绝对可以。本产品年龄无关适用于任何年龄阶段的人，但是老人与小孩应该在成人监护下使用，脉宽强度也要调小一点。", nil];
    father_array= [[NSMutableArray alloc]initWithObjects:@"本产品适用于各个年龄阶段的人么？",@"肌肉会不会锻炼过度或者过度疲劳?", @"使用本产品又没有什么禁忌?", nil];
    //    UINib * nib = [UINib nibWithNibName:@"HelpChildCell" bundle:[NSBundle bundleForClass:[HelpChildCell class]]];
    //    [_tv registerNib:nib forCellReuseIdentifier:@"Cell"];
    UIColor *bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    _tv.backgroundColor=bg;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;

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
    textLabel.font=font;
    textLabel.text=[father_array objectAtIndex:section];
    
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
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    // 這裏返回需要的高度
    return size.height;
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
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 0) lineBreakMode:UILineBreakModeWordWrap];
    
    // 構建顯示行
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CGRect rect = [cell.textLabel textRectForBounds:cell.textLabel.frame limitedToNumberOfLines:0];
    UIColor *bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    cell.backgroundColor=bg;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  BlueToothViewController.m
//  iTrain
//
//  Created by Interest on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BlueToothViewController.h"

@interface BlueToothViewController ()

@end

@implementation BlueToothViewController

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
    UIColor *bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    _tv.backgroundColor=bg;

 
    self.view.backgroundColor=bg;
    _tv.backgroundColor=bg;
    _tv.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //    self.userTabelView = tableView;
    //    禁止滑动
    //    _userTabelView.scrollEnabled = NO;
    
     _tv.delegate = self;
        _tv.dataSource = self;
    [self setExtraCellLineHidden:_tv];
    [self.view addSubview:_tv];

}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BlueToothCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlueToothCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BlueToothCell" owner:self options:nil]lastObject];
    }
//    cell.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ul_ti"]];
    
    //    禁止选中效果
    cell.nameLabel.text = @"ll";
//    [cell.connectLabel setHidden:NO];
    
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
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

//
//  ExerciseRecordViewController.m
//  iTrain
//
//  Created by Interest on 14-8-23.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ExerciseRecordViewController.h"
#import "Record.h"
#import "AppDelegate.h"

@interface ExerciseRecordViewController ()

@end
UIColor *bg;
NSMutableArray *dataarray;
int deleteRow;
@implementation ExerciseRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataarray=[[NSMutableArray alloc]init];
        deleteRow=-1;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"训练";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [self initData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    //    self.userTabelView = tableView;
    //    禁止滑动
    //    _userTabelView.scrollEnabled = NO;
    
    [self setExtraCellLineHidden:self.tabelView];
    [_delBtn setEnabled:NO];
    [_delBtn addTarget:self  action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    
}

//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *CustomCellIdentifier = @"Cell";
    
    scell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseRecordCell"];
    if(!scell) {
        scell = [[[NSBundle mainBundle] loadNibNamed:@"ExerciseRecordCell" owner:self options:nil]lastObject];
    }
    int row=[indexPath row];
    Record *trecord=[dataarray objectAtIndex:row];
    scell.year.text = [trecord year];
    scell.name.text =[trecord part];
    scell.time.text=[[NSString stringWithFormat:@"%d",[[trecord time] integerValue]] stringByAppendingString:@"min"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    NSString *destDateString = [dateFormatter stringFromDate:[trecord date]];
    scell.date.text=destDateString;
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(290, 11,32 ,22)];
    [scell addSubview:btn];
    [btn setTag:indexPath.row];
    [btn addTarget:self action:@selector(gotoDetailView:) forControlEvents:UIControlEventTouchUpInside];
    //    设置选中背景
    scell.selectedBackgroundView = [[UIView alloc] initWithFrame:scell.frame] ;
    scell.selectedBackgroundView.backgroundColor=  [UIColor colorWithPatternImage:[UIImage imageNamed:@"record_xuanzhongbeijing.png"]];
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

-(void)gotoDetailView:(id)sender{
    _detail=[[ExerciseRecordDetailViewController alloc]init];
    _detail.record=[dataarray objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:_detail animated:YES];
    
}

//响应用户单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    _delBtn.backgroundColor=
    //     [UIColor colorWithPatternImage:[UIImage imageNamed:@"record_shanchujilu.png"]];
    deleteRow=indexPath.row;
    [_delBtn setEnabled:YES];
    [_delBtn setImage:[UIImage imageNamed:@"record_shanchujilu.png"] forState:UIControlStateNormal];
}


//删除事件
-(void)deleteCell:(id)sender{
    if (deleteRow!=-1) {
        AppDelegate *myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        Record *re=[dataarray objectAtIndex:deleteRow];
        [myAppDelegate.managedObjectContext deleteObject:re];
        NSError *error=nil;
        [myAppDelegate.managedObjectContext save:&error];
        [dataarray removeObjectAtIndex:deleteRow];
        [_tabelView reloadData];
        deleteRow=-1;
        [_delBtn setEnabled:NO];
        [_delBtn setImage:[UIImage imageNamed:@"record_shanchujilu_01.png"] forState:UIControlStateNormal];
    }else{
        return;
    }
}

-(void)initData{
    AppDelegate *myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record"inManagedObjectContext:myAppDelegate.managedObjectContext];
    //设置请求实体
    [request setEntity:entity];
    //指定对结果的排序方式
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time"ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else{
//        Record *tt=[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:myAppDelegate.managedObjectContext];;
//        [tt setStarttime:[NSDate date]];
//        [tt setDate:[NSDate date]];
//        [tt setPart:@""];
//        [tt setWeekday:@""];
//        [mutableFetchResult addObject:tt];
        dataarray=mutableFetchResult;
        [_tabelView reloadData];
    }
}
@end
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
#import "AppDelegate.h"
#import <AssetsLibrary/ALAsset.h>

#import <AssetsLibrary/ALAssetsLibrary.h>

#import <AssetsLibrary/ALAssetsGroup.h>

#import <AssetsLibrary/ALAssetRepresentation.h>

@interface UserViewController (){
    UserViewController* sview;
    NewUserViewController *newUser;
    UserInfoViewController *UserInfo;
}
@property (nonatomic, readonly) UIButton *m_btnNaviRight;
//@property (nonatomic, readonly)UIImageView *mimageview;

@end
UIColor *bg;
NSMutableArray *imageArray;
@implementation UserViewController
NSString   *currentName;
NSString   *currentImg;
NSString   *currentAge;
NSString   *currentUser;
NSInteger _index;
AppDelegate *myAppDelegate;
ALAssetsLibrary* lib;
@synthesize m_btnNaviRight = _btnNaviRight;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _index=-1;
        lib=[[ALAssetsLibrary alloc]init];
        imageArray=[[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self initUI];
}

-(void)initUI{
    _contentView.hidden = YES;
    // 初始化tableView的数据
    
    _dataArray=[[NSMutableArray alloc]init];
    
    NSArray *namelist = [NSArray arrayWithObjects:@"详情",@"删除", nil];
    NSArray *imagelist = [NSArray arrayWithObjects:@"user_xiangqing@2x.png",@"user_shanchu@2x.png", nil];
    
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

-(void)update{
    NSError* error=nil;
    [myAppDelegate.managedObjectContext save:&error];
}
-(void)initData{
    //创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"inManagedObjectContext:myAppDelegate.managedObjectContext];
    //设置请求实体
    [request setEntity:entity];
    //指定对结果的排序方式
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    self.dataArray = mutableFetchResult;
    for(User *user in self.dataArray){
        if([[user isChoose] boolValue]){
            _index=[self.dataArray indexOfObject:user];
            return;
        }
    }
    _index=0;
    [_userTabelView reloadData];
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_userTabelView) {
        return _dataArray.count;
    }else{
        return _contentImageList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView ==_userTabelView){
        UserCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCollectionViewCell"];
        User *user=[_dataArray objectAtIndex:indexPath.row];
        if(cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserCollectionViewCell" owner:self options:nil]lastObject];
            
        }
        NSString *st=[user photo];
        if(st!=nil){
            if([st hasPrefix:@"assets-library"]){
                [lib assetForURL:[NSURL URLWithString:[user photo]] resultBlock:^(ALAsset *asset)
                 {
                     // 使用asset来获取本地图片
                     ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                     CGImageRef imgRef = [assetRep fullResolutionImage];
                     UIImage *avatarImage = [UIImage imageWithCGImage:imgRef
                                                                scale:assetRep.scale
                                                          orientation:(UIImageOrientation)assetRep.orientation];
                     if(avatarImage!=nil){
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [cell.userImage setImage:avatarImage];
                         });
                     }
                 }
                    failureBlock:^(NSError *error)
                 {
                 }
                 ];
            }else{
                cell.userImage.image = [UIImage imageWithContentsOfFile:st];
            }
        }else{
            cell.userImage.image=[UIImage imageNamed:@"user_icon.png"];
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
        
        NSString *string=@"用户";
        cell.userName.text=[user name];
        cell.userLabel.text=[string stringByAppendingFormat:@"%d",(1+indexPath.row)];
        cell.userAge.text=[[NSString stringWithFormat:@"%d",[[user age] integerValue]] stringByAppendingString:@"岁"];
        [imageArray addObject:cell.select];
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
        
        UIView *cellView ;
        NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:@"UserSettingCell" owner:self options:nil]; //通过这个方法,取得我们的视图
        cellView=[nibViews objectAtIndex:0];
        cellView.userInteractionEnabled = YES;
        
        UILabel *textLabel=[[cellView subviews] objectAtIndex:0];
        textLabel.text=[NSString stringWithFormat:@"%@", [_contentNameList objectAtIndex:row]];
        UIImageView *iconImage=[[cellView subviews] objectAtIndex:1];
        iconImage.image=[UIImage imageNamed:[_contentImageList objectAtIndex:row]];
        
        
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
    [self setLeftCustomBarItem:@"ul_back.png" action:@selector(back)];
   
    [self setRightCustomBarItem:@"ul_kuang.png" action:@selector(popoverBtnClicked:forEvent:)];
    [self initData];
    if(_dataArray.count==0){
        [self setRightCustomBarItemState:YES];
    }else{
         [self setRightCustomBarItemState:NO];
    }
    [_userTabelView reloadData];
}

-(void)back{
    [KWPopoverView Dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
//跳转到新建用户页面
-(void)addPage{
    newUser= [[NewUserViewController alloc] init];
    [self.navigationController pushViewController:newUser animated:YES];
    
}

- (void)selectClicked:(id)sender forEvent:(UIEvent *)event{
    if(_dataArray.count==0){
        return;
    }
    UIButton *btn=sender;
    User *user=[self.dataArray objectAtIndex:_index];
    NSMutableArray *tArray=[[NSMutableArray alloc]init];
    [tArray addObject:[NSIndexPath indexPathForRow:_index inSection:0]];
    [user setIsChoose:[NSNumber numberWithBool:false]];
    User *nuser=[self.dataArray objectAtIndex:btn.tag];
    [nuser setIsChoose:[NSNumber numberWithBool:true]];
    _index=btn.tag;
    [[imageArray objectAtIndex:_index] setImage:[UIImage imageNamed:@"ul_gou.png"] forState:UIControlStateHighlighted];
    [self update];
    [tArray addObject:[NSIndexPath indexPathForRow:_index inSection:0]];
//    [_userTabelView reloadRowsAtIndexPaths:tArray withRowAnimation:UITableViewRowAnimationNone];
    [_userTabelView reloadData];
    [myAppDelegate setUser:user];
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
    User *user=[self.dataArray objectAtIndex:_index];
    UILabel *label=(UILabel *)[[_popContentView subviews] objectAtIndex:1];
    [label setText:[@"用户" stringByAppendingFormat:@"%d",(_index+1)]];
    UILabel *label1=(UILabel *)[[_popContentView subviews] objectAtIndex:2];
    [label1 setText:[user name]];
    UILabel *label2=(UILabel *)[[_popContentView subviews] objectAtIndex:3];
    [label2 setText:[[NSString stringWithFormat:@"%d",[[user age] integerValue]] stringByAppendingString:@"岁"]];
    NSString *pt=[user photo];
    if(pt!=nil){
        if([pt hasPrefix:@"assets-library"]){
            [lib assetForURL:[NSURL URLWithString:[user photo]] resultBlock:^(ALAsset *asset)
             {
                 // 使用asset来获取本地图片
                 ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                 CGImageRef imgRef = [assetRep fullResolutionImage];
                 UIImage *avatarImage = [UIImage imageWithCGImage:imgRef
                                                            scale:assetRep.scale
                                                      orientation:(UIImageOrientation)assetRep.orientation];
                 if(avatarImage!=nil){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [[[_popContentView subviews] objectAtIndex:0] setImage:avatarImage];
                     });
                 }
             }
                failureBlock:^(NSError *error)
             {
             }
             ];
        }else{
             [[[_popContentView subviews] objectAtIndex:0] setImage:[UIImage imageWithContentsOfFile:pt]];
        }
    }else{
        [[[_popContentView subviews] objectAtIndex:0] setImage:[UIImage imageNamed:@"user_icon.png"]];
    }
   
    [KWPopoverView showPopoverAtPoint:point1 inView:_contentView withContentView:_contentView];
}
//响应用户单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_contetTabelView) {
        if (indexPath.row==0) {
            //            详情'
            if(UserInfo==nil){
                UserInfo= [[UserInfoViewController alloc] init];
            }
            UserInfo.user=[self.dataArray objectAtIndex:_index];
            [self.navigationController pushViewController:UserInfo animated:YES];
            
            //            删除
        }else if(indexPath.row==1){
            [myAppDelegate.managedObjectContext deleteObject:[self.dataArray objectAtIndex:_index]];
            [self.dataArray removeObjectAtIndex:_index];
            NSError *error=nil;
            [myAppDelegate.managedObjectContext save:&error];
            if(_index>=self.dataArray.count){
                _index=self.dataArray.count-1;
            }
            [_userTabelView reloadData];
        }
        [KWPopoverView Dismiss];
    }
    
    
}


@end

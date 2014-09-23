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
#import <objc/objc.h>

#import <objc/runtime.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

#import <AssetsLibrary/ALAssetsGroup.h>

#import <AssetsLibrary/ALAssetRepresentation.h>

@interface UserViewController ()<UIGestureRecognizerDelegate>{
    UserViewController* sview;
    NewUserViewController *newUser;
    UserInfoViewController *UserInfo;
}
@property (nonatomic, readonly) UIButton *m_btnNaviRight;
//@property (nonatomic, readonly)UIImageView *mimageview;

@end
UIColor *tipColor;
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
    // 设置tableView的数据源
    _userTabelView.dataSource = self;
    // 设置tableView的委托
    _userTabelView.delegate = self;
    // 设置tableView的背景图
    bg= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor=bg;
    _userTabelView.backgroundColor=bg;
    _userTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    禁止滑动
    _contetTabelView.scrollEnabled = NO;
    _contetTabelView.tableHeaderView=_contentCell;
    [self setExtraCellLineHidden:_userTabelView];
    [_addBtn addTarget:self action:@selector(AddBtnDow) forControlEvents:UIControlEventTouchDown];
    [_addBtn addTarget:self action:@selector(AddBtnUp) forControlEvents:UIControlEventTouchUpOutside];
    [_addBtn addTarget:self action:@selector(AddBtnUp) forControlEvents:UIControlEventTouchDragOutside];
    [_addBtn addTarget:self action:@selector(AddBtnDow) forControlEvents:UIControlEventTouchDragEnter];
    
    
    [_delBtn addTarget:self action:@selector(DelBtnDow) forControlEvents:UIControlEventTouchDown];
    [_delBtn addTarget:self action:@selector(DelBtnUp) forControlEvents:UIControlEventTouchUpOutside];
    [_delBtn addTarget:self action:@selector(DelBtnUp) forControlEvents:UIControlEventTouchDragOutside];
    [_delBtn addTarget:self action:@selector(DelBtnDow) forControlEvents:UIControlEventTouchDragEnter];
    
    
    //设置按钮按下状态图片
    [_addBtn setImage:[UIImage imageNamed:@"ul_xinjian.png"] forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"ul_xinjian2.png"] forState:UIControlStateHighlighted];
    
    //设置按钮按下状态图片
    [_delBtn setImage:[UIImage imageNamed:@"del_xinjian.png"] forState:UIControlStateNormal];
    [_delBtn setImage:[UIImage imageNamed:@"del_xinjian_1.png"] forState:UIControlStateHighlighted];
    
    [_addBtn addTarget:self action:@selector(addPage) forControlEvents:UIControlEventTouchUpInside];
    [_delBtn addTarget:self  action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    sview=self;
    [_NewTip setTitle:NSLocalizedString(@"NewUser", nil) forState:UIControlStateNormal];
    [_delBtnText setTitle:NSLocalizedString(@"DelUser", nil) forState:UIControlStateNormal];
    tipColor=[_NewTip titleColorForState:UIControlStateNormal];
}

-(void)AddBtnDow{
    
    [_NewTip setTitleColor:tipColor forState:UIControlStateNormal];
}
-(void)AddBtnUp{
    [_NewTip setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}
-(void)DelBtnDow{
    
    [_delBtnText setTitleColor:tipColor forState:UIControlStateNormal];
}
-(void)DelBtnUp{
    [_delBtnText setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title =NSLocalizedString(@"UserList", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:@selector(back)];
    [self initData];
    [_userTabelView reloadData];
    if(self.dataArray.count==0){
        [_delBtnText setEnabled:NO];
        [_delBtn setEnabled:NO];
    }else{
        [_delBtnText setEnabled:YES];
        [_delBtn setEnabled:YES];
    }
    [_NewTip setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_delBtnText setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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
    if(self.dataArray.count==0){
        return;
    }else if(self.dataArray.count==1){
        _index=0;
        User *user=[self.dataArray objectAtIndex:0];
        [user setIsChoose:[NSNumber numberWithBool:YES] ];
        [myAppDelegate setUser:user];
    }else{
        for(User *user in self.dataArray){
            if([[user isChoose] boolValue]){
                _index=[self.dataArray indexOfObject:user];
                [myAppDelegate setUser:user];
            }
        }
        if(_index==-1){
            _index=0;
        }
    }
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (tableView==_userTabelView) {
    return _dataArray.count;
    //    }else{
    //        return _contentImageList.count;
    //    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if(tableView ==_userTabelView){
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
            UIImage *avImage= [UIImage imageWithContentsOfFile:st];
            NSLog(@"%f,%f",avImage.size.width,avImage.size.height);
            cell.userImage.image = avImage;
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
    
    NSString *string=NSLocalizedString(@"UserNo", nil);
    cell.userName.text=[user name];
    cell.userLabel.text=[string stringByAppendingFormat:@"%d",(1+indexPath.row)];
    cell.userAge.text=[NSLocalizedString(@"Age", nil) stringByAppendingFormat:@"%d",[[user age] integerValue]];
    [imageArray addObject:cell.select];
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


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
//跳转到新建用户页面
-(void)addPage{
    [self AddBtnUp];
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
    [_userTabelView reloadData];
    [myAppDelegate setUser:nuser];
}



//响应用户单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(UserInfo==nil){
        UserInfo= [[UserInfoViewController alloc] init];
    }
    UserInfo.user=[self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:UserInfo animated:YES];
}
-(void)delete:(id)sender{
    [self DelBtnUp];
    [myAppDelegate.managedObjectContext deleteObject:[self.dataArray objectAtIndex:_index]];
    [self.dataArray removeObjectAtIndex:_index];
    NSError *error=nil;
    [myAppDelegate.managedObjectContext save:&error];
    if(_index>=self.dataArray.count){
        _index=self.dataArray.count-1;
    }
    
    if(self.dataArray.count==0){
        [_delBtnText setEnabled:NO];
        [_delBtn setEnabled:NO];
        [myAppDelegate setUser:nil];
    }else{
        [myAppDelegate setUser:[self.dataArray objectAtIndex:_index]];
    }
    [_userTabelView reloadData];
}
@end

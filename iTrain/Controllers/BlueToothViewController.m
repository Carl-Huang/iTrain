//
//  BlueToothViewController.m
//  iTrain
//
//  Created by Interest on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BlueToothViewController.h"
#import "CBLEManager.h"
#import "CBLEPeriphral.h"
#import "Device.h"


@interface BlueToothViewController ()
@property (nonatomic,strong) NSArray * dataSource;
@end

@implementation BlueToothViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = @[];
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
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BlueToothCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlueToothCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BlueToothCell" owner:self options:nil]lastObject];
    }
//    cell.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ul_ti"]];
//    int row=[indexPath row];
    
    CBPeripheral * peripheral = _dataSource[indexPath.row];
    cell.nameLabel.text = peripheral.name;
    
    //cell.nameLabel.text=[_dataSource objectAtIndex:row];
    //    禁止选中效果
//    cell.nameLabel.text = @"ll";
//    [cell.connectLabel setHidden:NO];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral * peripheral = _dataSource[indexPath.row];
    if(peripheral.isConnected)
    {
        
       
        return ;
    }
    
//    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"Connecting...";
   // [[CBLEManager sharedManager] ]
    [[CBLEManager sharedManager] connectToPeripheral:peripheral];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([CBLEManager sharedManager].peripheral == nil)
        {
           // hud.labelText = @"Time out";
//[hud hide:YES afterDelay:1];
            [[CBLEManager sharedManager] disconnectFromPeripheral:peripheral];
            return ;
        }
        
        if([CBLEManager sharedManager].characteristicForWrite == nil)
        {
           // hud.labelText = @"Time out";
            //[hud hide:YES afterDelay:1];
            [[CBLEManager sharedManager] disconnect];
        }
        
    });
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
    self.title = @"开始训练";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [[CBLEManager sharedManager] startScan];
    [[CBLEManager sharedManager] setDiscoverHandler:^(void){
        _dataSource = [[CBLEManager sharedManager] foundPeripherals];
        [_tv reloadData];
    }];
    
    [[CBLEManager sharedManager] setConnectedHandler:^(CBPeripheral * peripheral){

    }];
    
    [[CBLEManager sharedManager] setConnectedAllCompleteHandler:^(CBPeripheral * peripheral){
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getMoelData];
    }];
    
    [_tv reloadData];
}

-(void)getMoelData{
    [[CBLEManager sharedManager] createData:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x03], nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

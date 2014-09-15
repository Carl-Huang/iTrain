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
#import "DXAlertView.h"

@interface BlueToothViewController ()
@property (nonatomic,strong) NSMutableArray * dataSource;
@end
BOOL isScan;
@implementation BlueToothViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [[NSMutableArray alloc]init];
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
    _tv.delegate = self;
    _tv.dataSource = self;
    [self setExtraCellLineHidden:_tv];
    [self.view addSubview:_tv];
    
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isScan) {
        return 1;
    }else {
        return _dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BlueToothCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlueToothCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BlueToothCell" owner:self options:nil]lastObject];
    }
    if (isScan) {
        cell.searchLabel.hidden=NO;
    }else{
        cell.searchLabel.hidden=YES;
        cell.nameLabel.hidden=NO;
        cell.iconImg.hidden=NO;
        cell.connectLabel.hidden=NO;
        CBPeripheral * peripheral = _dataSource[indexPath.row];
        if(peripheral.isConnected){
            cell.connectLabel.text=@"已连接";
        }else{
            cell.connectLabel.text=@"未连接";
        }
        cell.nameLabel.text = peripheral.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isScan){
        [tableView reloadData];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral * peripheral = _dataSource[indexPath.row];
    if(peripheral.isConnected)
    {
        return ;
    }
    
    [[CBLEManager sharedManager] connectToPeripheral:peripheral];
    
   
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
    self.title = @"蓝牙连接";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [[CBLEManager sharedManager] stopScan];
    [[CBLEManager sharedManager] startScan];
    
    _dataSource = [[CBLEManager sharedManager] foundPeripherals];
    if(_dataSource.count==0){
        isScan=YES;
    }else{
        isScan=NO;
    }
    [[CBLEManager sharedManager] setDiscoverHandler:^(void){
        _dataSource = [[CBLEManager sharedManager] foundPeripherals];
        isScan=NO;
        [_tv reloadData];
    }];
    
    [[CBLEManager sharedManager] setConnectedHandler:^(CBPeripheral * peripheral){
        
    }];
    
    [[CBLEManager sharedManager] setConnectedAllCompleteHandler:^(CBPeripheral * peripheral){
        [self getMoelData:peripheral];
    }];
    
    [_tv reloadData];
}

-(void)getMoelData:(CBPeripheral *)per{
    [[CBLEManager sharedManager] setSendDataHandler:^(NSString *st,CBPeripheral *per){
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"蓝牙连接成功" leftButtonTitle:nil rightButtonTitle:@"OK"];
        [alert show];
        alert.leftBlock = ^() {
            
        };
        alert.rightBlock = ^() {
            [self.navigationController popViewControllerAnimated:YES];
            //[_tv reloadData];
        };
        alert.dismissBlock = ^() {
            NSLog(@"Do something interesting after dismiss block");
        };
        
    }];
    [[CBLEManager sharedManager] createData:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x03], nil] withCBPeripheral:per];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[CBLEManager sharedManager] setSendDataHandler:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

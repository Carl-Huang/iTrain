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
    [_deviceTv setText:NSLocalizedString(@"Device", nil) ];
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
        [cell.searchLabel setText: NSLocalizedString(@"Search", nil)];
    }else{
        cell.searchLabel.hidden=YES;
        cell.ContentView.hidden=NO;
        cell.iconImg.hidden=NO;
        cell.connectLabel.hidden=NO;
        CBPeripheral * peripheral = _dataSource[indexPath.row];
        if(peripheral.isConnected){
            cell.connectLabel.text= NSLocalizedString(@"Connected", nil) ;
        }else{
            cell.connectLabel.text= NSLocalizedString(@"UnConnected", nil) ;
        }
        NSString *st=[[CBLEManager sharedManager].verDic objectForKey:CFBridgingRelease(CFUUIDCreateString(nil, [peripheral UUID]))];
        if(st!=nil){
             cell.deviceVer.text =[NSString stringWithFormat:@"%@ Ver %@",peripheral.name,st];
             NSInteger ss=[[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] integerValue];
            cell.appVer.text=[NSString stringWithFormat:@"App Ver %d.*",ss];
        }
        cell.nameLabel.text =peripheral.name;
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
    self.title = NSLocalizedString(@"BLEConnect", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [[CBLEManager sharedManager]check];
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
        [self getMoelData:peripheral withMode:YES];
    }];
    
    [_tv reloadData];
}

-(void)getMoelData:(CBPeripheral *)per withMode:(BOOL)mode{
    [[CBLEManager sharedManager] setSendDataHandler:^(NSString *st,CBPeripheral *per){
        if(mode){
            
           
            int a=[self parseInt:[[st substringFromIndex:8] substringToIndex:2]];
            [[CBLEManager sharedManager]addVer:[NSString stringWithFormat:@"%d.*",a]  withKey:CFBridgingRelease(CFUUIDCreateString(nil, [per UUID]))];
             [_tv reloadData];
 
            [self getMoelData:per withMode:NO];
        }else{
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText: NSLocalizedString(@"ConnectSu", nil) leftButtonTitle:nil rightButtonTitle:@"OK"];
            [alert show];
            alert.rightBlock = ^() {
                [self.navigationController popViewControllerAnimated:YES];
            };
        }
    }];
    if(mode){
      [[CBLEManager sharedManager] createData:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x0F], nil] withCBPeripheral:per];
    }else{
        [[CBLEManager sharedManager] createData:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x03], nil] withCBPeripheral:per];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [[CBLEManager sharedManager] setSendDataHandler:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(int)parseInt:(NSString *)str{
    int d=[[str substringFromIndex:1] integerValue];
    if([[str substringFromIndex:1] isEqualToString:@"a"]){
        d=10;
    }else if([[str substringFromIndex:1] isEqualToString:@"b"]){
        d=11;
    }else if([[str substringFromIndex:1] isEqualToString:@"c"]){
        d=12;
    }else if([[str substringFromIndex:1] isEqualToString:@"d"]){
        d=13;
    }else if([[str substringFromIndex:1] isEqualToString:@"e"]){
        d=14;
    }else if([[str substringFromIndex:1] isEqualToString:@"f"]){
        d=15;
    }
    int t=[[str substringToIndex:1] intValue]*16+d;
    return t;
}


-(void)Nofication{
    NSInteger ss=[[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] integerValue];
   
}
@end

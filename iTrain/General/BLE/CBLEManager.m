//
//  CBLEManager.m
//  iFind
//
//  Created by Carl on 13-9-19.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import "CBLEManager.h"
#import "DXAlertView.h"
#define WRITE_SERVICE_UUID     @"0xFFE5"
#define WRITE_UUID             @"0xFFE9"
#define READ_SERVICE_UUID      @"0xFFE0"
#define READ_UUID              @"0xFFE4"
@implementation CBLEManager
#pragma mark - Life Cycle
+(id)sharedManager
{
    static CBLEManager *bleManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bleManager = [[self alloc] init];
    });
    return bleManager;
}

-(id)init
{
    if((self = [super init]))
    {
        _connectedPeripherals = [[NSMutableArray alloc] init];
        _foundPeripherals = [[NSMutableArray alloc] init];
        _bleCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        _sendSu1=YES;
        _sendSu2=YES;
        _verDic=[[NSMutableDictionary alloc]init];
    }
    return self;
}



-(void)dealloc
{
    //_peripheral.delegate = nil;
    //_peripheral = nil;
    _bleCentralManager.delegate = nil;
    _bleCentralManager = nil;
    _connectedPeripherals = nil;
    _foundPeripherals = nil;
}

#pragma  mark - Instance Methods

- (void)startScan
{
    [self startScan:nil];
}


/**
 **开始搜索蓝牙设备
 **/
- (void)startScan:(NSArray *)services
{
    NSMutableArray * servicesUUIDs = nil;
    if(services != nil || [services count] != 0)
    {
        for(NSString * uuid in services)
        {
            [servicesUUIDs addObject:[CBUUID UUIDWithString:uuid]];
        }
    }
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [_bleCentralManager scanForPeripheralsWithServices:nil options:dic];
}

- (void)stopScan
{
    [_bleCentralManager stopScan];
}

-(void)check{
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    for(CBPeripheral *per in _foundPeripherals){
        if(per==nil){
            [temp addObject:per];
        }
        
    }
    [_foundPeripherals removeObjectsInArray:temp];
}
-(void)discoverServicesWithUUIDs:(NSArray *)uuids withCBPeripheral:(CBPeripheral *)_peripheral
{
    if(_peripheral == nil)
    {
       // NSLog(@"The connected peripheral is nil.");
        return;
    }
    NSMutableArray * services = [@[] mutableCopy];
    if (uuids == nil || [uuids count] == 0)
    {
        services = nil;
    }
    else
    {
        for (NSString * uuid in uuids) {
            [services addObject:[CBUUID UUIDWithString:uuid]];
        }
    }
    [_peripheral discoverServices:services];
}

-(void)discoverCharacteristicWithService:(CBService *)service withCharacters:(NSArray *)uuids
{
    
    for(int i=0;i<2;i++){
        CBPeripheral *_peripheral;
        if(i==0){
            _peripheral=_peripheral1;
        }else{
            _peripheral=_peripheral2;
        }
        if(_peripheral == nil)
        {
           // NSLog(@"The connected peripheral is nil.");
            return ;
        }
        
        NSMutableArray * chars = [@[] mutableCopy];
        if (uuids == nil || [uuids count] == 0)
        {
            chars = nil;
        }
        else
        {
            for (NSString * uuid in uuids) {
                [chars addObject:[CBUUID UUIDWithString:uuid]];
            }
        }
        
        [_peripheral discoverCharacteristics:chars forService:service];
    }
}

-(void)addVer:(NSString *)ver withKey:(NSString *)key{
     [_verDic setObject:ver forKey:key];
}

- (void)connectToPeripheral:(CBPeripheral *)peripheral
{
    NSAssert(peripheral != nil, @"The CBPeripheral is nil.%@",NSStringFromSelector(_cmd));
    if([peripheral isConnected])
    {
        //[self disconnectFromPeripheral:peripheral];
        //NSLog(@"The peripheral is already connected.");
        return ;
        
    }
    [_bleCentralManager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}

-(void)disconnect
{
    if(_peripheral1 != nil && [_peripheral1 isConnected])
    {
        [self disconnectFromPeripheral:_peripheral1];
    }
    if(_peripheral2 != nil && [_peripheral2 isConnected])
    {
        [self disconnectFromPeripheral:_peripheral2];
    }
}

- (void)disconnectFromPeripheral:(CBPeripheral *)peripheral
{
    NSAssert(peripheral != nil, @"The CBPeripheral is nil.%@",NSStringFromSelector(_cmd));
    [_bleCentralManager cancelPeripheralConnection:peripheral];
}

- (void)clear
{
    [_connectedPeripherals removeAllObjects];
    [_foundPeripherals removeAllObjects];
    [_verDic removeAllObjects];
}

-(BOOL)isConnected{
    BOOL isConnectes=NO;
    if(_peripheral1 != nil && [_peripheral1 isConnected])
    {
        isConnectes= YES;
    }
    if(_peripheral2 != nil && [_peripheral2 isConnected])
    {
        isConnectes= YES;
    }
    return isConnectes;
}

- (void)addFoundPeripheral:(CBPeripheral *)peripheral
{
    if(![_foundPeripherals containsObject:peripheral])
    {
        NSLog(@"Add peripheral");
        [_foundPeripherals addObject:peripheral];
        peripheral.delegate=self;
        if(self.discoverHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.discoverHandler();
            });
        }
    }
    
    
}
- (void)removeFoundPeripheral:(CBPeripheral *)peripheral
{
    
    if([_foundPeripherals containsObject:peripheral])
    {
        [_foundPeripherals removeObject:peripheral];
        [_verDic removeObjectForKey:CFBridgingRelease(CFUUIDCreateString(nil, [peripheral UUID]))];
        if(self.discoverHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.discoverHandler();
            });
        }
    }
}

-(void)sendData:(NSData *)data
{
    //[sendArray ]
    for(int i=0;i<2;i++){
        CBPeripheral *_peripheral;
        if(i==0){
            _peripheral=_peripheral1;
        }else{
            _peripheral=_peripheral2;
        }
        if(_peripheral == nil)
        {
           // NSLog(@"The connected peripheral is nil.");
            return ;
        }
        
        if(![_peripheral isConnected])
        {
           // NSLog(@"The peripheral is disconnected.");
            return ;
        }
        CBCharacteristic * _characteristicForWrite;
        if(_peripheral1==_peripheral){
            _characteristicForWrite=_writecharacteristic1;
        }else{
            _characteristicForWrite=_writecharacteristic2;
        }
        if(_characteristicForWrite == nil)
        {
            //NSLog(@"The write characteristic is nil.");
            return ;
        }
        
        if(data == nil)
        {
            //NSLog(@"The data is nil.");
            return ;
        }
        
        [_peripheral writeValue:data forCharacteristic:_characteristicForWrite type:CBCharacteristicWriteWithResponse];
        if(_peripheral1==_peripheral){
            _sendSu1=NO;
        }else{
            _sendSu2=NO;
        }
    }
}


#pragma mark - CBCentralManagerDelegate Methods
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            //[self startScan];
            NSLog(@"The Bluetooth powered on.");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"The Bluetooth powered off.");
            [self stopScan];
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"The Bluetooth state resetting.");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"The Bluetooth state unauthorized.");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"The Bluetooth state unknown.");
            break;
        default:
            break;
    }
}

/**
 **搜索到一个蓝牙设备的回调
 **/
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
       if([RSSI intValue] < -100)
    {
       // NSLog(@"The rssi is weak.");
        return ;
    }
    
    //    if([RSSI intValue] > -15)
    //    {
    //        NSLog(@"The rssi is impossible.");
    //        return ;
    //    }
    [self addFoundPeripheral:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
   // NSLog(@"CBCentralManager did connect peripheral %@",peripheral.name);
    if(_peripheral1==nil){
        _peripheral1=peripheral;
    }else if(_peripheral1!=nil&&_peripheral2==nil){
        _peripheral2=peripheral;
    }else{
        if(!_isRenew1&&!_isRenew2){
            _peripheral1=peripheral;
            _isRenew1=!_isRenew1;
        }else if(_isRenew1&&_isRenew2){
            _peripheral2=peripheral;
            _isRenew2=!_isRenew2;
        }else{
            _peripheral1=peripheral;
            _isRenew2=!_isRenew2;
        }
    }
    peripheral.delegate = self;
    [self discoverServicesWithUUIDs:nil withCBPeripheral:peripheral];
    
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
   // NSLog(@"CBCentralMananger did fail to connect peripheral:%@",error);
    if(peripheral==_peripheral1){
        _peripheral1=nil;
        _sendSu1=YES;
    }else{
        _sendSu2=YES;
       _peripheral2=nil;
    }
    [self removeFoundPeripheral:peripheral];
    
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
//    NSLog(@"Disconnect peripheral:%@,rssi:%d,with error:%@",peripheral.name,peripheral.RSSI.intValue,error);
    if(error)
    {
        //some error
        //有可能是设备离远了
        //[central retrievePeripherals:@[(id)peripheral.UUID]];
        
        
        if(self.disconnectHandler)
        {
            self.disconnectHandler(peripheral);
        }
        
    }
    
    if(peripheral==_peripheral1){
        _peripheral1=nil;
         _sendSu1=YES;
    }else{
         _sendSu2=YES;
        _peripheral2=nil;
    }
    [self removeFoundPeripheral:peripheral];
    
    
}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
   
    CBPeripheral * peripheral;
    for(peripheral in peripherals)
    {
        [self connectToPeripheral:peripheral];
        [self addFoundPeripheral:peripheral];
    }
    
}


#pragma mark - CBPeripheralDelegate Methods

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if(error)
    {
       // NSLog(@"Discover services error : %@",[error description]);
        return ;
    }
   
    for(CBService * service in peripheral.services)
    {
        if([service.UUID isEqual:[CBUUID UUIDWithString:WRITE_SERVICE_UUID]]||[service.UUID isEqual:[CBUUID UUIDWithString:READ_SERVICE_UUID]])
        {
            
            
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if(error)
    {
       // NSLog(@"Discover characteristics error : %@",[error description]);
        return ;
    }

    
//    CBPeripheral *_tperipheral=nil;
//    for(CBPeripheral *_peripheral in _peripherals){
//        if([CFBridgingRelease(CFUUIDCreateString(nil, [peripheral UUID])) isEqual:CFBridgingRelease(CFUUIDCreateString(nil, [_peripheral UUID]))]){
//            _tperipheral=_peripheral;
//            break;
//        }
//    }
    for(CBCharacteristic * characteristic in service.characteristics)
    {
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:WRITE_UUID]])
        {
            if(peripheral==_peripheral1){
                _writecharacteristic1=characteristic;
                _Stu1=2;
            }else{
                _writecharacteristic2=characteristic;
            }
            if(self.connectedAllCompleteHandler)
            {
                self.connectedAllCompleteHandler(peripheral);
                
            }
        }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:READ_UUID]]){
            if(peripheral==_peripheral1){
                _receivecharacteristic1=characteristic;
            }else{
                _receivecharacteristic2=characteristic;
            }
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error)
    {
       // NSLog(@"Peripheral write value %@ with error :%@",characteristic.value,[error description]);
        return ;
    }
    
//    if(characteristic.value == nil)
//    {
//        NSLog(@"The characteristic value is nil.");
//    }
    
    
    
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Peripheral read value with error : %@",[error description]);
        return ;
    }
    
    
    if(characteristic.value == nil)
    {
        return ;
    }
    NSData *data=characteristic.value;
    [self parse:data withPer:peripheral];
    
}

-(void)parse:(NSData *)data withPer:(CBPeripheral *)per{
    Byte *testByte = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",testByte[i]&0xff]; ///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
   
    if(hexStr.length<8){
        return;
    }
    if(![[hexStr substringToIndex:2] isEqualToString:@"5a"]){
        return;
    }
    if(![[[hexStr substringFromIndex:2] substringToIndex:2] isEqualToString:@"a5"]){
        return;
    }
   // NSLog(@"==%@",hexStr);
    if([[[hexStr substringFromIndex:4] substringToIndex:2] isEqualToString:@"0a"]){
        if(self.endHandler){
            self.endHandler(per);
        }
        [self createData:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x01], nil]];
    }else if([[[hexStr substringFromIndex:4] substringToIndex:2] isEqualToString:@"08"]){
        DXAlertView *alertView=[[DXAlertView alloc]initWithTitle:NSLocalizedString(@"elec", nil) contentText:nil leftButtonTitle:nil rightButtonTitle:@"OK"];
        [alertView show];
        [self createData:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x01], nil]];
    }else if([[[hexStr substringFromIndex:4] substringToIndex:2] isEqualToString:@"09"]){
        if(self.powerHandler){
            self.powerHandler(hexStr,per);
        }
    }else{
        if([[[hexStr substringFromIndex:4] substringToIndex:2] isEqualToString:@"03"]){
            NSMutableArray *temp=[[NSMutableArray alloc]init];
            hexStr=[hexStr substringFromIndex:8];
            [temp addObject: [NSNumber numberWithInt:[self parseInt:[[hexStr substringFromIndex:0] substringToIndex:2]]]];
            [temp addObject: [NSNumber numberWithInt:[self parseInt:[[hexStr substringFromIndex:2] substringToIndex:2]]]];
            [temp addObject: [NSNumber numberWithInt:[self parseInt:[[hexStr substringFromIndex:4] substringToIndex:2]]]];
            [temp addObject: [NSNumber numberWithInt:[self parseInt:[[hexStr substringFromIndex:6] substringToIndex:2]]]];
            [temp addObject: [NSNumber numberWithInt:[self parseInt:[[hexStr substringFromIndex:8] substringToIndex:2]]]];
            _modelArray=[[NSArray alloc]initWithArray:temp];
        }
        // NSLog(@"%@",hexStr);
        if(_sendSu1&&_sendSu2){
            if(self.sendDataHandler){
                self.sendDataHandler(hexStr,per);
            }
        }else{
            if(_peripheral1==per){
                _sendSu1=YES;
            }else{
                _sendSu2=YES;
            }
            if(_sendSu1&&_sendSu2){
                if(self.sendDataHandler){
                    self.sendDataHandler(hexStr,per);
                }
            }
        }
    }
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
-(NSArray *)getModel{
    return _modelArray;
}


-(void)createData:(NSArray *)array{
    NSArray *reArray;
    if(array.count==1){
        reArray=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x5A],[NSNumber numberWithInt:0xA5],array[0],[NSNumber numberWithInt:0x00], nil];
    }else{
        reArray=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x5A],[NSNumber numberWithInt:0xA5],[NSNumber numberWithInt:0x04],[NSNumber numberWithInt:0x05],array[0],array[1],array[2],array[3],array[4],[NSNumber numberWithInt:[self checkByte:array]], nil];
    }
    [self sendData:[self msrRead:reArray]];
}

-(void)createData:(NSArray *)array withCBPeripheral:(CBPeripheral *)peripheral{
    NSArray *reArray=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0x5A],[NSNumber numberWithInt:0xA5],array[0],[NSNumber numberWithInt:0x00], nil];
    if(peripheral == nil)
    {
        //NSLog(@"The connected peripheral is nil.");
        return ;
    }
    
    if(![peripheral isConnected])
    {
        //NSLog(@"The peripheral is disconnected.");
        return ;
    }
    CBCharacteristic * _characteristicForWrite;
    if(peripheral==_peripheral1){
        _characteristicForWrite=_writecharacteristic1;
    }else{
        _characteristicForWrite=_writecharacteristic2;
    }
    if(_characteristicForWrite == nil)
    {
        //NSLog(@"The write characteristic is nil.");
        return ;
    }
    NSData *data=[self msrRead:reArray];
    if(data == nil)
    {
     //   NSLog(@"The data is nil.");
        return ;
    }
    [peripheral writeValue:data forCharacteristic:_characteristicForWrite type:CBCharacteristicWriteWithResponse];
    if(_peripheral1==peripheral){
         _sendSu1=NO;
    }else{
         _sendSu2=NO;
    }
}

-(NSData *)msrRead:(NSArray *)array
{
    Byte byte[array.count];
    
    for(int temp=0;temp<array.count;temp++){
        NSNumber *t=array[temp];
        byte[temp]=[t intValue];
    }
    NSData *data = [[NSData alloc]initWithBytes:byte length:array.count];
    return data;
}

-(int)checkByte:(NSArray *)array{
    int re=0x05;
    for(int i=0;i<array.count;i++){
        re=re+[array[i] intValue];
    }
    return re;
}
-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        //NSLog(@"Update rssi with error:%@",error);
        return ;
    }
   // NSLog(@"New RSSI:%d",peripheral.RSSI.intValue);
    
}








@end

//
//  CBLEManager.m
//  iFind
//
//  Created by Carl on 13-9-19.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import "CBLEManager.h"
#define SERVICE_UUID     @"0xFFE0"
#define CHAR_UUID        @"0xFFE4"
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
    }
    return self;
}



-(void)dealloc
{
    _peripheral.delegate = nil;
    _peripheral = nil;
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
    [_bleCentralManager scanForPeripheralsWithServices:servicesUUIDs options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey]];
}

- (void)stopScan
{
    [_bleCentralManager stopScan];
}

-(void)discoverServicesWithUUIDs:(NSArray *)uuids
{
    if(_peripheral == nil)
    {
        NSLog(@"The connected peripheral is nil.");
        return ;
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
    if(_peripheral == nil)
    {
        NSLog(@"The connected peripheral is nil.");
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



- (void)connectToPeripheral:(CBPeripheral *)peripheral
{
    NSAssert(peripheral != nil, @"The CBPeripheral is nil.%@",NSStringFromSelector(_cmd));
    if([peripheral isConnected])
    {
        //[self disconnectFromPeripheral:peripheral];
        NSLog(@"The peripheral is already connected.");
        return ;
        
    }
    [_bleCentralManager connectPeripheral:peripheral options:nil];
}

-(void)disconnect
{
    if(_peripheral != nil && [_peripheral isConnected])
    {
        [self disconnectFromPeripheral:_peripheral];
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
    
}


- (void)addFoundPeripheral:(CBPeripheral *)peripheral
{
//    if(peripheral.name == nil)
//    {
//        NSLog(@"Peripheral name is nil");
//        return;
//    }
//    NSRange range = [peripheral.name rangeOfString:@"RM"];
//    if(range.location != 2)
//    {
//        NSLog(@"Peripheral name is invalidate.");
//        return ;
//    }
//              NSLog(@"测试打印  uuid %@" , (id)peripheral.UUID);
    if(![_foundPeripherals containsObject:peripheral])
    {
        NSLog(@"Add peripheral");
        [_foundPeripherals addObject:peripheral];
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
    if(_peripheral == nil)
    {
        NSLog(@"The connected peripheral is nil.");
        return ;
    }
    
    if(![_peripheral isConnected])
    {
        NSLog(@"The peripheral is disconnected.");
        return ;
    }
    
    if(_characteristicForWrite == nil)
    {
        NSLog(@"The write characteristic is nil.");
        return ;
    }
    
    if(data == nil)
    {
        NSLog(@"The data is nil.");
        return ;
    }
    
    [_peripheral writeValue:data forCharacteristic:_characteristicForWrite type:CBCharacteristicWriteWithResponse];
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

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{

    NSLog(@"Discover peripheral,name:%@,RSSI:%d",peripheral.name,[RSSI intValue]);

    if([RSSI intValue] < -100)
    {
        NSLog(@"The rssi is weak.");
        return ;
    }
    
    if([RSSI intValue] > -15)
    {
        NSLog(@"The rssi is impossible.");
        return ;
    }
   NSLog(@"adverisement:%@",advertisementData);
    [self addFoundPeripheral:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"CBCentralManager did connect peripheral %@",peripheral.name);
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    [self discoverServicesWithUUIDs:@[SERVICE_UUID]];

}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"CBCentralMananger did fail to connect peripheral:%@",error);
    self.peripheral = nil;
    [self removeFoundPeripheral:peripheral];
    
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Disconnect peripheral:%@,rssi:%d,with error:%@",peripheral.name,peripheral.RSSI.intValue,error);
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
    
    
    self.peripheral = nil;
    [self removeFoundPeripheral:peripheral];

}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"Did retrieve peripherals %lu",(unsigned long)[peripherals count]);
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
        NSLog(@"Discover services error : %@",[error description]);
        return ;
    }
    NSLog(@"Discover services %lu",(unsigned long)[peripheral.services count]);
    for(CBService * service in peripheral.services)
    {
//        if([service.UUID isEqual:[CBUUID UUIDWithString:SERVICE_UUID]])
//        {
//            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CHAR_UUID]] forService:service];
//        }
//        else
//        {
//            [peripheral discoverCharacteristics:nil forService:service];
//        }
        [peripheral discoverCharacteristics:nil forService:service];

    }
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Discover characteristics error : %@",[error description]);
        return ;
    }
    NSLog(@"Discover characteristics %lu",(unsigned long)[service.characteristics count]);
    for(CBCharacteristic * characteristic in service.characteristics)
    {
        NSLog(@"%@",characteristic.UUID );
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:CHAR_UUID]])
        {
            _characteristicForWrite = characteristic;
            //[peripheral setNotifyValue:YES forCharacteristic:characteristic];
            if(self.connectedAllCompleteHandler)
            {
                self.connectedAllCompleteHandler(peripheral);
            }
        }
    }
    
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Peripheral write value %@ with error :%@",characteristic.value,[error description]);
        return ;
    }
    
    if(characteristic.value == nil)
    {
        NSLog(@"The characteristic value is nil.");
    }
    
    NSLog(@"Did write value %@, characteristic uuid %@",[[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding],characteristic.UUID);
        
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Peripheral read value with error : %@",[error description]);
        return ;
    }
    NSLog(@"Did update value %@, in characteristic uuid %@, service uuid:%@",characteristic.value,characteristic.UUID,characteristic.service.UUID);
    if(characteristic.value == nil)
    {
        return ;
    }
    
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"Update rssi with error:%@",error);
        return ;
    }
    NSLog(@"New RSSI:%d",peripheral.RSSI.intValue);
    
}








@end

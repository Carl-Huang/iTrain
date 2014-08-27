//
//  CBLEPeriphral.m
//  iFind
//
//  Created by Carl on 13-9-19.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import "CBLEPeriphral.h"
#define SERVICE_UUID     @"0xFFE0"
#define CHAR_UUID        @"0xFFE1"

@implementation CBLEPeriphral

-(void)dealloc
{
    _peripheral.delegate = nil;
    _peripheral = nil;
    _characteristicForBattery = nil;
    _rssiUpdateHandler = nil;
    _batteryLevelUpdateHandler = nil;

}

-(id)initWithPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
   if((self = [super init]))
   {
       self.peripheral = peripheral;
       
       self.peripheral.delegate = self;
       //取得蓝牙的信号
       self.rssi = [peripheral.RSSI intValue];
       //取得蓝牙的uuid
       if(peripheral.UUID != NULL)
           self.UUID = [[self class] convertCFUUIDIntoString:peripheral.UUID];
       
       [self discoverServices];
       
       
   }
    return self;
}


-(void)discoverServices
{
    NSArray * services = @[[CBUUID UUIDWithString:SERVICE_UUID]];
    [_peripheral discoverServices:services];
}

-(void)discoverCharacteristic
{

    [_peripheral discoverCharacteristics:nil forService:nil];
}



-(void)readRSSI:(NSTimer *)timer
{
    
    if(![_peripheral isConnected])
    {
        return;
    }
    NSLog(@"Peripheral read rssi.");
    [_peripheral readRSSI];
    
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
        if([service.UUID isEqual:[CBUUID UUIDWithString:SERVICE_UUID]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CHAR_UUID]] forService:service];
        }
        else
        {
            [peripheral discoverCharacteristics:nil forService:service];
        }
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
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:CHAR_UUID]])
        {
            _characteristicForWrite = characteristic;
            //[peripheral setNotifyValue:YES forCharacteristic:characteristic];
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
    NSLog(@"Did write value %@, characteristic uuid %@",characteristic.value,characteristic.UUID);
    
    if(characteristic == _characteristicForBattery)
    {
        [self readBatteryLevel];
    }
    
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
    
    self.rssi = peripheral.RSSI.intValue;
    if(self.rssiUpdateHandler)
    {
        self.rssiUpdateHandler(self.rssi);
    }
    
    
}


+ (NSString *)convertCFUUIDIntoString:(CFUUIDRef)uuid
{
    NSAssert(uuid != NULL, @"The CFUUID is null.");
    NSString * uuidStr = (__bridge  NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    return uuidStr;
}


-(void)readBatteryLevel
{
    if(_characteristicForBattery == nil) return;
    if([self.peripheral isConnected])
        [self.peripheral readValueForCharacteristic:_characteristicForBattery];
}





@end

//
//  CBLEPeriphral.h
//  iFind
//
//  Created by Carl on 13-9-19.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
typedef void (^RSSIUpdateHandler)(int rssi);
typedef void (^BatteryLevelUpdateHandler)(void);
@interface CBLEPeriphral : NSObject <CBPeripheralDelegate>

@property (nonatomic,retain) CBPeripheral * peripheral;
@property (nonatomic,assign) int rssi;
@property (nonatomic,retain) NSString * UUID;
@property (nonatomic,assign) int batteryLevel;
@property (nonatomic,retain) CBCharacteristic * characteristicForWrite;
@property (nonatomic,retain) CBCharacteristic * characteristicForBattery;
@property (nonatomic,copy) RSSIUpdateHandler rssiUpdateHandler;
@property (nonatomic,copy) BatteryLevelUpdateHandler batteryLevelUpdateHandler;
-(id)initWithPeripheral:(CBPeripheral *)peripheral;

-(void)discoverServices;

-(void)readRSSI:(NSTimer *)timer;
-(void)readBatteryLevel;

@end

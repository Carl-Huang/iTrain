//
//  CBLEManager.h
//  iFind
//  BLE 管理类
//  Created by Carl on 13-9-19.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CBLEPeriphral.h"
#import <AudioToolbox/AudioToolbox.h>
#define Peripheral_Count 1
typedef void (^DiscoverNewPeripheralHandler)(void);
typedef void (^SendDataHandler)(NSString *st);
typedef void (^ConnectedPeripheralHandler)(CBPeripheral * peripheral);
typedef void (^ConnectedAllCompleteHandler)(CBPeripheral * peripheral);
typedef void (^DisconnectPeripheralHandler)(CBPeripheral * peripheral);
@interface CBLEManager : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic,readonly) CBCentralManager * bleCentralManager;
@property (nonatomic,retain) CBPeripheral * peripheral;
@property (nonatomic,retain) NSMutableArray * connectedPeripherals;
@property (nonatomic,retain) NSMutableArray * foundPeripherals;
@property (nonatomic,retain) CBCharacteristic * characteristicForWrite;
@property (nonatomic,copy) DiscoverNewPeripheralHandler discoverHandler;
@property (nonatomic,copy) ConnectedPeripheralHandler connectedHandler;
@property (nonatomic,copy) ConnectedAllCompleteHandler connectedAllCompleteHandler;
@property (nonatomic,copy) DisconnectPeripheralHandler disconnectHandler;
@property (nonatomic,copy) SendDataHandler sendDataHandler;
@property (nonatomic ,copy)NSArray *modelArray;
+(CBLEManager *)sharedManager;
-(void)startScan;
-(void)startScan:(NSArray *)services;
-(void)stopScan;
-(void)connectToPeripheral:(CBPeripheral *)peripheral;
-(void)disconnectFromPeripheral:(CBPeripheral *)peripheral;
-(void)disconnect;
-(void)clear;
-(void)sendData:(NSData *)data;
-(void)createData:(NSArray *)array;
-(BOOL)isConnected;
-(NSArray *)getModel;





@end

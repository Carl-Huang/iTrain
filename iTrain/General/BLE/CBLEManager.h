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
typedef void (^CloseHandler)(void);
typedef void (^SendDataHandler)(NSString *st,CBPeripheral * peripheral);
typedef void (^ConnectedPeripheralHandler)(CBPeripheral * peripheral);
typedef void (^EndPeripheralHandler)(CBPeripheral * peripheral);
typedef void (^PowerHandler)(NSString *st,CBPeripheral * peripheral);
typedef void (^ConnectedAllCompleteHandler)(CBPeripheral * peripheral);
typedef void (^DisconnectPeripheralHandler)(CBPeripheral * peripheral);
@interface CBLEManager : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic,readonly) CBCentralManager * bleCentralManager;
@property (nonatomic,strong)CBCharacteristic *writecharacteristic1;
@property (nonatomic,strong)CBCharacteristic *receivecharacteristic1;
@property (nonatomic,strong)CBCharacteristic *writecharacteristic2;
@property (nonatomic,strong)CBCharacteristic *receivecharacteristic2;
@property (nonatomic,retain) CBPeripheral * peripheral1;
@property (nonatomic,retain) CBPeripheral * peripheral2;
@property (nonatomic)NSInteger Stu1;
@property (nonatomic)NSInteger Stu2;
@property (nonatomic,retain) NSMutableArray * connectedPeripherals;
@property (nonatomic,retain) NSMutableArray * foundPeripherals;
@property (nonatomic,strong) NSMutableDictionary * verDic;
@property (nonatomic,copy) DiscoverNewPeripheralHandler discoverHandler;
@property (nonatomic,copy) ConnectedPeripheralHandler connectedHandler;
@property (nonatomic,copy) ConnectedAllCompleteHandler connectedAllCompleteHandler;
@property (nonatomic,copy) CloseHandler closeHandler;
@property (nonatomic,copy) DisconnectPeripheralHandler disconnectHandler;
@property (nonatomic,copy) SendDataHandler sendDataHandler;
@property (nonatomic,copy) EndPeripheralHandler endHandler;
@property (nonatomic,copy) PowerHandler powerHandler;
@property (nonatomic ,copy)NSArray *modelArray;
@property (nonatomic)BOOL isRenew1 ;
@property (nonatomic)BOOL isRenew2 ;
@property (nonatomic)BOOL sendSu1 ;
@property (nonatomic)BOOL sendSu2 ;
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
-(void)createData:(NSArray *)array withCBPeripheral:(CBPeripheral *)peripheral;
-(NSArray *)getModel;

-(void)check;

-(void)addVer:(NSString *)ver withKey:(NSString *)key;

@end

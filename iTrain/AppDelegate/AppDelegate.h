//
//  AppDelegate.h
//  iTrain
//  Created by Carl on 14-8-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <EventKit/EventKit.h>
#import "User.h"
#import "ExerciseParamViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,
WXApiDelegate>
{
    enum WXScene _scene;
    MainViewController *rootView ;
    SSInterfaceOrientationMask _interfaceOrientationMask;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong,nonatomic) User  *user;
@property (nonatomic) BOOL isUserUnit;
@property (nonatomic)NSDate *startDate;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSString *part;
@property (nonatomic)NSTimeInterval terval;
@property (nonatomic, strong)NSDate *lastDate;
@property (nonatomic,strong)ExerciseParamViewController *evc;
@property (nonatomic) SSInterfaceOrientationMask interfaceOrientationMask;

@property(strong,nonatomic,readonly)NSManagedObjectModel* managedObjectModel;

@property(strong,nonatomic,readonly)NSManagedObjectContext* managedObjectContext;

@property(strong,nonatomic,readonly)NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property(strong,nonatomic,readonly) EKEventStore *eventDB;
@end

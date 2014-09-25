//
//  AppDelegate.m
//  iTrain
//
//  Created by Carl on 14-8-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "APService.h"

@implementation AppDelegate
@synthesize managedObjectModel=_managedObjectModel;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;
@synthesize eventDB=_eventDB;
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _isUserUnit=NO;
    application.applicationIconBadgeNumber = 0;
    [ShareSDK registerApp:@"2f5f22504fd1"];     //参数为ShareSDK官网中添加应用后得到的AppKey
    [self initializePlat];
    _interfaceOrientationMask = SSInterfaceOrientationMaskAll;
    //监听用户信息变更
    [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                               target:self
                               action:@selector(userInfoUpdateHandler:)];
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    // Required
    [APService setupWithOption:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (DEVICE_IS_IPHONE5) {
        rootView= [[MainViewController alloc] initWithNibName:@"MainViewController4" bundle:nil];
    }else {
        rootView= [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    }
    
    self.navController = [[UINavigationController alloc] init];
    [self.navController pushViewController:rootView animated:YES];
    [self.window setRootViewController:_navController];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"tittle_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.window makeKeyAndVisible];
    /**延长启动页面时间**/
    [NSThread sleepForTimeInterval:1];
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif){
        
    }
    
    return YES;
}


- (void)initializePlat
{
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    /**
     连接Facebook应用以使用相关功能，此应用需要引用FacebookConnection.framework
     https://developers.facebook.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    
    
    
    
    /**
     连接Line应用以使用相关功能，此应用需要引用LineConnection.framework库
     **/
    // [ShareSDK connectLine];
    
    /**
     连接WhatsApp应用以使用相关功能，此应用需要引用WhatsAppConnection.framework库
     **/
    // [ShareSDK connectWhatsApp];
    
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kAPNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kAPNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kAPNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kAPNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
//{
//    if (UIInterfaceOrientationIsLandscape(newStatusBarOrientation))
//    {
//        self.viewController.leftSize = self.window.height - (320 - 44.0);
//    }
//    else
//    {
//        self.viewController.leftSize = self.window.width - (320 - 44.0);
//    }
//}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    application.applicationIconBadgeNumber = 0;
    // Required
    [APService handleRemoteNotification:userInfo];
    [self goTo];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    application.applicationIconBadgeNumber = 0;
    [self goTo];
}

-(void)goTo{
    [self.navController pushViewController:[[SettingViewController alloc] init] animated:NO];
    [self.navController pushViewController:[[AboutViewController alloc] init] animated:NO];
    [self.navController pushViewController:[[SysNotiViewController alloc]init] animated:YES];
}

//- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url
//                        wxDelegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
//}


- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    switch (plat)
    {
        case ShareTypeSinaWeibo:
            platName = NSLocalizedString(@"TEXT_SINA_WEIBO", @"新浪微博");
            break;
        case ShareType163Weibo:
            platName = NSLocalizedString(@"TEXT_NETEASE_WEIBO", @"网易微博");
            break;
        case ShareTypeDouBan:
            platName = NSLocalizedString(@"TEXT_DOUBAN", @"豆瓣");
            break;
        case ShareTypeFacebook:
            platName = @"Facebook";
            break;
        case ShareTypeKaixin:
            platName = NSLocalizedString(@"TEXT_KAIXIN", @"开心网");
            break;
        case ShareTypeQQSpace:
            platName = NSLocalizedString(@"TEXT_QZONE", @"QQ空间");
            break;
        case ShareTypeRenren:
            platName = NSLocalizedString(@"TEXT_RENREN", @"人人网");
            break;
        case ShareTypeSohuWeibo:
            platName = NSLocalizedString(@"TEXT_SOHO_WEIBO", @"搜狐微博");
            break;
        case ShareTypeTencentWeibo:
            platName = NSLocalizedString(@"TEXT_TENCENT_WEIBO", @"腾讯微博");
            break;
        case ShareTypeTwitter:
            platName = @"Twitter";
            break;
        case ShareTypeInstapaper:
            platName = @"Instapaper";
            break;
        case ShareTypeYouDaoNote:
            platName = NSLocalizedString(@"TEXT_YOUDAO_NOTE", @"有道云笔记");
            break;
        case ShareTypeGooglePlus:
            platName = @"Google+";
            break;
        case ShareTypeLinkedIn:
            platName = @"LinkedIn";
            break;
        default:
            platName = NSLocalizedString(@"TEXT_UNKNOWN", @"未知");
    }
    
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++)
    {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = (ShareType)[[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:plat],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}



#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    
}
//托管对象
-(NSManagedObjectModel *)managedObjectModel
{
    
    if (_managedObjectModel!=nil) {
        return _managedObjectModel;
    }
    //    NSURL* modelURL=[[NSBundle mainBundle] URLForResource:@"CoreDataExample" withExtension:@"momd"];
    //    _managedObjectModel=[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    _managedObjectModel=[NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}
//托管对象上下文
-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext!=nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator* coordinator=[self persistentStoreCoordinator];
    if (coordinator!=nil) {
        _managedObjectContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
//持久化存储协调器
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator!=nil) {
        return _persistentStoreCoordinator;
    }
    //    NSURL* storeURL=[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreaDataExample.CDBStore"];
    //    NSFileManager* fileManager=[NSFileManager defaultManager];
    //    if(![fileManager fileExistsAtPath:[storeURL path]])
    //    {
    //        NSURL* defaultStoreURL=[[NSBundle mainBundle] URLForResource:@"CoreDataExample" withExtension:@"CDBStore"];
    //        if (defaultStoreURL) {
    //            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
    //        }
    //    }
    NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSURL* storeURL=[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"CoreDataExample.sqlite"]];
    NSLog(@"path is %@",storeURL);
    NSError* error=nil;
    _persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    return _persistentStoreCoordinator;
}

-(EKEventStore *)eventDB{
    if(_eventDB!=nil){
        return _eventDB;
    }
    _eventDB=[[EKEventStore alloc]init];
    return _eventDB;
}


- (void)networkDidSetup:(NSNotification *)notification {
    //[_infoLabel setText:@"已连接"];
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    //[_infoLabel setText:@"未连接。。。"];
    NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    //[_infoLabel setText:@"已注册"];
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    //[_infoLabel setText:@"已登录"];
    NSLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification

{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                          
                                                    message:notification.alertBody
                          
                                                   delegate:nil
                          
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
    
    //这里，你就可以通过notification的useinfo，干一些你想做的事情了
    
    application.applicationIconBadgeNumber -=1;
    
}
@end

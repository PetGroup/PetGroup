//
//  AppDelegate.m
//  PetGroup
//
//  Created by Tolecen on 13-8-13.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#include <netdb.h>
#import <dlfcn.h>
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "DDLog.h"
#import "DDTTYLogger.h"


#define DataStoreModel @"LocalDataStore.sqlite"
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [SFHFKeychainUtils deleteItemForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil];
//    [SFHFKeychainUtils deleteItemForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil];
     [self installUncaughtExceptionHandler];
    //把NSlog 输出到文件中 给测试时想着打开即可
    [self redirectLogToDocumentFolder];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

   // [MagicalRecord setupCoreDataStackWithStoreNamed:DataStoreModel];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.loadingV = [[LoadingViewController alloc] init];
    self.window.rootViewController = self.loadingV;
    self.xmppHelper=[[XMPPHelper alloc] init];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
    return YES;
}
- (void) redirectLogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"debug_log.txt"];
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}
- (void)installUncaughtExceptionHandler
{
    InstallUncaughtExceptionHandler();
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    
    
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",pToken];
    NSLog(@"regisger success:%@", deviceTokenStr);
    //注册成功，将deviceToken保存到应用服务器数据库中
    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenStr = %@",deviceTokenStr);
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:PushDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //将deviceToken保存在NSUserDefaults
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    // 处理推送消息
//    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue]+1;
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"通知" message:@"我的信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//    
//    [alert show];
//    
//    NSLog(@"%@", userInfo);
    
}



- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Regist fail%@",error);  
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.xmppHelper disconnect];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
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
    //暂时注释
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
       // Reachability * reach2 = [Reachability reachabilityWithHostname:@"www.google.com"];
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if (reach) {
        // messageV->titleLabel.text=@"消息";
        if ([[TempData sharedInstance] ifOpened]) {
            if (![self.xmppHelper ifXMPPConnected]) {
                [_loadingV setLabelTitle:@"消息(连接中...)"];
                [_loadingV setMakeLogin];
            }
        }
        
    }
    else{
        // messageV->titleLabel.text=@"消息(未连接)";
        [_loadingV setLabelTitle:@"消息(未连接)"];
        [self.xmppHelper disconnect];
    }
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //    messageV->titleLabel.text=@"消息";
            if ([[TempData sharedInstance] ifOpened]) {
                if (![self.xmppHelper ifXMPPConnected]) {
                    [_loadingV setLabelTitle:@"消息(连接中...)"];
                    [_loadingV setMakeLogin];
                }
            }
            //[self logIn];
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //   messageV->titleLabel.text=@"消息（未连接）";
            [_loadingV setLabelTitle:@"消息(未连接)"];
            [self.xmppHelper disconnect];
        });
    };
    
    [reach startNotifier];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //  NSLog( @"Notification Says Reachable");
    }
    else
    {
        //    NSLog( @"Notification Says Unreachable");
    }
}

@end

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
#import "MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import "WBApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "MBProgressHUD.h"
#import "ReconnectionManager.h"

#define DataStoreModel @"LocalDataStore.sqlite"
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ShareSDK registerApp:@"eefa7b0ec35"];
    [ShareSDK convertUrlEnabled:NO];
    [self initializePlat];
//    [SFHFKeychainUtils deleteItemForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil];
//    [SFHFKeychainUtils deleteItemForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil];
//     [self installUncaughtExceptionHandler];
//    //把NSlog 输出到文件中 给测试时想着打开即可
//    [self redirectLogToDocumentFolder];
    inActive = YES;
    if (launchOptions) {
        //截取apns推送的消息
        NSDictionary* pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        NSLog(@"pushInfoStr-->>%@",pushInfo);
        NSString * infoType = [pushInfo objectForKey:@"type"];
        if (infoType) {
            TempData * td = [TempData sharedInstance];
            td.needDisplayPushNotification = YES;
            [[NSUserDefaults standardUserDefaults] setObject:pushInfo forKey:@"RemoteNotification"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
    }
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

   // [MagicalRecord setupCoreDataStackWithStoreNamed:DataStoreModel];
    
    [MobClick startWithAppkey:@"528c5e1056240b39ce0a0f90" reportPolicy:SEND_ON_EXIT channelId:@""];
    [self setChannel:@"1"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    // Override point for customization after application launch.
    self.loadingV = [[LoadingViewController alloc] init];
    self.window.rootViewController = self.loadingV;
    self.xmppHelper=[[XMPPHelper alloc] init];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    return YES;
}
-(void)setChannel:(NSString *)theChannel
{
    [[NSUserDefaults standardUserDefaults] setObject:theChannel forKey:@"theChannel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void) redirectLogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"debug_log.txt"];
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}
//- (void)installUncaughtExceptionHandler
//{
//    InstallUncaughtExceptionHandler();
//}
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
    NSLog(@"uuuuuuuuinfo：%@", userInfo);
    NSString * infoType = [userInfo objectForKey:@"type"];
    if (infoType&&!inActive) {
        TempData * td = [TempData sharedInstance];
        td.needDisplayPushNotification = YES;
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"RemoteNotification"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_loadingV performSelector:@selector(makeTabbarPresentAViewController:) withObject:nil afterDelay:1];
    }


    
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Regist fail%@",error);  
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    inActive = NO;
    [TempData sharedInstance].appActive = NO;
    [self.xmppHelper disconnect];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    for (MBProgressHUD * view in self.window.subviews) {
        if ([view isKindOfClass:[MBProgressHUD class]]) {
            [view hide:YES];
        }
    }
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
    inActive = YES;
    [TempData sharedInstance].appActive = YES;
    ReconnectionManager * reconnetMannager = [ReconnectionManager sharedInstance];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
       // Reachability * reach2 = [Reachability reachabilityWithHostname:@"www.google.com"];
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if (reach) {
        reconnetMannager.networkAvailable = YES;
        // messageV->titleLabel.text=@"消息";
        if ([[TempData sharedInstance] ifOpened]) {
            if (![self.xmppHelper ifXMPPConnected]) {
                [_loadingV setLabelTitle:@"消息(连接中...)"];
                [_loadingV setMakeLogin];
            }
        }
        
    }
    else{
        reconnetMannager.networkAvailable = NO;
        // messageV->titleLabel.text=@"消息(未连接)";
        [_loadingV setLabelTitle:@"消息(未连接)"];
        [self.xmppHelper disconnect];
    }
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            reconnetMannager.networkAvailable = YES;
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
            reconnetMannager.networkAvailable = NO;
            //   messageV->titleLabel.text=@"消息（未连接）";
            [_loadingV setLabelTitle:@"消息(未连接)"];
            [self.xmppHelper disconnect];
        });
    };
    
    [reach startNotifier];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"inspectNewSubject" object:self];//检查新专题
    
//    if ([[TempData sharedInstance] ifOpened]){
//        [_loadingV makeTabbarPresentAViewController:nil];
//    }

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
    NSLog(@"the application was terminate");
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
- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"2455646689"
                               appSecret:@"8285248b5dcc0690df9d747a71754073"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801460737"
                                  appSecret:@"79c7a0dfc43683d3f5f6b637004bfccd"
                                redirectUri:@"http://www.52pet.net"
                                   wbApiCls:[WBApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"100584356"
                           appSecret:@"	2fb71cb3592fd340adfd2257d1bc16fe"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"100584356"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wxa45ff01dc73e9109" wechatCls:[WXApi class]];
}
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
@end

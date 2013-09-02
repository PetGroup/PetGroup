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


#import "ViewController.h"
#define DataStoreModel @"LocalDataStore.sqlite"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
   // [MagicalRecord setupCoreDataStackWithStoreNamed:DataStoreModel];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.loadingV = [[LoadingViewController alloc] init];
    self.window.rootViewController = self.loadingV;
    self.xmppHelper=[[XMPPHelper alloc] init];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    //   // Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if (reach) {
        // messageV->titleLabel.text=@"消息";
        [_loadingV setLabelTitle:@"消息"];
    }
    else{
        // messageV->titleLabel.text=@"消息(未连接)";
        [_loadingV setLabelTitle:@"消息(未连接)"];
    }
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //    messageV->titleLabel.text=@"消息";
            [_loadingV setLabelTitle:@"消息"];
            //[self logIn];
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //   messageV->titleLabel.text=@"消息（未连接）";
            [_loadingV setLabelTitle:@"消息(未连接)"];
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

//
//  AppDelegate.h
//  PetGroup
//
//  Created by Tolecen on 13-8-13.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "TempData.h"
#import "LoadingViewController.h"
#import "UncaughtExceptionHandler.h"
@class ViewController;
@class XMPPHelper;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoadingViewController * loadingV;
@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic,strong) XMPPHelper *xmppHelper;
@end

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

@class ContentDetailViewController;
@class ViewController;
@class XMPPHelper;
@class MBProgressHUD;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL inActive;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoadingViewController * loadingV;
@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic,strong) XMPPHelper *xmppHelper;
@end

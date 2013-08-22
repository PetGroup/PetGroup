//
//  LoadingViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLNavigationController.h"
@class ViewController,CustomTabBar,LeveyTabBarController,MessageViewController,DynamicViewController,NearByViewController,ContactsViewController,MoreViewController,LoginViewController,DetailMessageViewController,KKChatController;
@interface LoadingViewController : UIViewController
{
    UIImageView *splashImageView;
    MessageViewController * messageV;
}
@property (strong,nonatomic) CustomTabBar * tabBarC;
@property (strong,nonatomic) MLNavigationController * NaviMessage, *NaviDynamic,* NaviNearBy, * NaviContacts, * NaviMore ,* NaviRandom;
@end

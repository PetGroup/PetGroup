//
//  LoadingViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLNavigationController.h"
#import "LocationManager.h"
@class ViewController,CustomTabBar,LeveyTabBarController,MessageViewController,DynamicViewController,NearByViewController,ContactsViewController,MoreViewController,LoginViewController,DetailMessageViewController,KKChatController;
@interface LoadingViewController : UIViewController<UIAlertViewDelegate>
{
    UIImageView *splashImageView;
    MessageViewController * messageV;
    
    NSString * appStoreURL;
}
@property (strong,nonatomic) CustomTabBar * tabBarC;
@property (strong,nonatomic) MLNavigationController * NaviMessage, *NaviDynamic,* NaviNearBy, * NaviContacts, * NaviMore ,* NaviRandom;
-(void)setLabelTitle:(NSString *)title;
-(void)setMakeLogin;
@end

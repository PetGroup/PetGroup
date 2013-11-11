//
//  CustomTabBarController.h
//  TestTabbar]
//
//  Created by zuo jianjun on 11-7-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// Modified by Tolecen

#import <UIKit/UIKit.h>
//@class MainView;
@interface CustomTabBar : UITabBarController {
	NSMutableArray * buttons;
	int currentSelectedIndex;
	UIImageView   * slideView;
    UILabel * lab;
    UIImageView * imagView;
    NSArray * nameArr;
    int a;
    NSDictionary * tabTitle;
    UIView * tabBarBackgroundView;
    NSArray * theNormalArray;
    NSArray * theSelectedArray;
    NSArray * theControllerArray;
}
@property (nonatomic ,retain)  NSMutableArray * buttons;
@property (nonatomic ,retain)  UIImageView    * slideView;
@property (nonatomic ,assign)  int   currentSelectedIndex;
//-(void) ccccc;
-(id)initWithImages:(NSArray *)normalArray AndSelected:(NSArray *)selectedArray AndControllers:(NSArray *)controllers;
-(void)hideAll;
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
-(void) hidesTabBar;
-(void) customTabBar;
-(void) selectedTabBarItem:(UIButton *) button;
-(void)buttontag:(int)sender;
- (void)notificationWithNumber:(BOOL)ifNumber AndTheNumber:(int)number OrDot:(BOOL)dot WithButtonIndex:(int)index;
- (void)removeNotificatonOfIndex:(int)index;
-(void)setSelectedPage:(int)index;
@end
@interface UIViewController (CustomTabBarControllerSupport)
@property(nonatomic, retain, readonly) CustomTabBar *customTabBarController;
@end
//@interface UIViewController (UICustomTabBarItem)
//
//@property(nonatomic,readonly,strong) CustomTabBar *customTabBarController;
//
//@end

//
//  MessageViewController.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MessageCell.h"
#import "AppDelegate.h"
#import "ControlRandomDelegate.h"
#import "KKChatController.h"
//#import "ChatDelegate.h"
#import "NotConnectDelegate.h"
#import "TempData.h"
#import "MLNavigationController.h"
#import "SRRefreshView.h"
#import "StoreMsgDelegate.h"
#import "WelcomeViewController.h"

@class XMPPHelper;
@interface MessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,NotConnectDelegate,UISearchBarDelegate,SRRefreshDelegate,StoreMsgDelegate>
{
    UISearchBar * searchBar;
    UISearchDisplayController * searchDisplay;
    NSMutableArray *friendsUsers;
    NSDictionary * theDict;
    NSString *chatUserName;
    @public
    UILabel *titleLabel;
    
    NSUserDefaults * uDefault;
    NSMutableArray * allNameKeys;
    NSDictionary * unReadDict;
    NSDictionary * contentDict;
    NSArray * searchResultArray;
    NSMutableArray * pyAndCnArray;
    int nameCount;
//    NSMutableData * dataSource;
    NSString * currentID;
    
    NSMutableDictionary * userInfoDict;
    NSMutableDictionary * postDict;
    
    NSTimer * checkLocTimer;
    double userLatitude;
    double userLongitude;
    
    SRRefreshView   *_slimeView;
    NSMutableArray * newFReqArray;
    NSMutableArray * reqInfoArray;  //(用户名，状态)
    int newFUnreadCount;
   // NSMutableDictionary * peopleDict;
    
    NSMutableDictionary * officalMsg;
    
    int reqFlag;
    NSMutableArray * sayHelloArray;
    
    SystemSoundID soundID;
}


@property (strong,nonatomic) UITableView * messageTable;
@property (strong,nonatomic) AppDelegate * appDel;

@end

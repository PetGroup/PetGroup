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
#import "FriendsReqsViewController.h"
#import "NotificationViewController.h"
#import "JudgeDrawMood.h"
#import "SubjectViewController.h"
@class XMPPHelper,ReconnectionManager;
@interface MessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,NotConnectDelegate,UISearchBarDelegate,SRRefreshDelegate,StoreMsgDelegate,UISearchDisplayDelegate>
{
    UISearchBar * searchBar;
    UISearchDisplayController * searchDisplay;
//    NSMutableArray *friendsUsers;
//    NSDictionary * theDict;
//    NSString *chatUserName;
    @public
    UILabel *titleLabel;
    
//    NSUserDefaults * uDefault;
//    NSMutableArray * allNameKeys;
//    NSDictionary * unReadDict;
//    NSDictionary * contentDict;
    
    NSMutableArray * pyAndCnArray;
    int nameCount;
//    NSMutableData * dataSource;
    NSString * currentID;
    
//    NSMutableDictionary * userInfoDict;
//    NSMutableDictionary * postDict;
    
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
    
    NSMutableArray * newReceivedMsgArray;
    NSMutableArray * allMsgArray;
    
    NSMutableArray * pyChineseArray;
    NSArray * searchResultArray;
    
    NSMutableArray * allMsgUnreadArray;
    
    NSMutableArray * allNickNameArray;
    NSMutableArray * allHeadImgArray;
    NSString * appStoreURL;
    
    float diffH;
    
    BOOL firstOpen;
    UIImageView *TopBarBGV;
    
    JudgeDrawMood * judgeDrawmood;
    ReconnectionManager * reV;
    
    UILabel * noNetLabel;
}


@property (strong,nonatomic) UITableView * messageTable;
@property (strong,nonatomic) AppDelegate * appDel;
@property (strong,nonatomic) MLNavigationController * mlNavigationController;
@property (strong,nonatomic) NSTimer * regerTimer;

-(void)logInToServer;
-(void)logInToChatServer;
-(void)makeScrollToTheTop:(NSNumber *)index;
-(void)setTheTitleLabelText;

@end

//
//  KKChatController.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "XMPPFramework.h"
#import "Common.h"
#import "UIExpandingTextView.h"
#import "TempData.h"
#import "StoreMsgDelegate.h"
@class AppDelegate, XMPPHelper;
@interface KKChatController : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UIExpandingTextViewDelegate,StoreMsgDelegate>
{
    UILabel *titleLabel;
    NSString * userName;
   // NSMutableDictionary * userDefaults;
    NSUserDefaults * uDefault;
    NSMutableDictionary * peopleDict;
    UIView * inPutView;
    UILongPressGestureRecognizer *btnLongTap;
    UIButton * tempBtn;
    UIView * popLittleView;
    UIView * btnBG;
    int readyIndex;
    NSIndexPath * indexPathTo;
    NSString * tempStr;
    UIView * clearView;
    BOOL canAdd;
    NSString * currentID;
    UIImageView * inputbg;
    UIButton * senBtn;
    int previousTime;
    int touchTimePre;
    int touchTimeFinal;
    NSMutableDictionary * userInfoDict;
    NSMutableDictionary * postDict;
    NSString * myHeadImg;
}
@property (strong, nonatomic)  UITableView *tView;
@property (strong, nonatomic)  UITextField *messageTextField;
//@property (strong, nonatomic)  UIButton * sendBtn;
@property(nonatomic, retain) NSString *chatWithUser;
@property(nonatomic, retain) NSString *nickName;
@property(nonatomic, retain) NSString *chatUserImg;
@property (strong,nonatomic) AppDelegate * appDel;
@property (strong,nonatomic) UIExpandingTextView *textView;
@property (assign,nonatomic) id<StoreMsgDelegate> msgDelegate;
- (void)sendButton:(id)sender;
- (void)closeButton:(id)sender;
@end
